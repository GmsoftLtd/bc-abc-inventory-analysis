codeunit 73030582 "GSO ABC Analysis Mgt."
{
    var
        NoLinesErr: Label 'There are no preview lines to apply. Run Calculate first.';
        PolicyDescriptionLbl: Label '%1 ABC to Counting Period mapping', Comment = '%1 = Policy code';
        DateFormulaTok: Label '<-%1D>', Locked = true;
        SetupCodeTok: Label 'SETUP', Locked = true;
        DefaultPolicyTok: Label 'DEFAULT', Locked = true;

    /// <summary>
    /// Builds the preview buffer for one model and period. Items are ranked by value and classified
    /// A/B/C by cumulative percentage. Items without value in the period get class D when
    /// "Zero Consumption as D" is enabled in setup, otherwise they are left out.
    /// </summary>
    procedure CalculatePreview(Model: Enum "GSO ABC Model"; StartDate: Date; EndDate: Date; var TempPreview: Record "GSO ABC Preview Line" temporary)
    var
        Setup: Record "GSO ABC Analysis Setup";
        Item: Record Item;
        Amount: Decimal;
        CumPct: Decimal;
        TotalValue: Decimal;
        LineNo: Integer;
    begin
        GetSetup(Setup);
        TempPreview.Reset();
        TempPreview.DeleteAll();

        Item.SetRange(Blocked, false);
        Item.SetRange("GSO Exclude", false);
        if Setup."Exclude Non-Inventory" then
            Item.SetRange(Type, Item.Type::Inventory);
        if Item.FindSet() then
            repeat
                Amount := CalcItemValue(Model, StartDate, EndDate, Item."No.");
                if Amount < 0 then
                    Amount := 0;

                if (Amount > 0) or Setup."Zero Consumption as D" then begin
                    LineNo += 10000;
                    TempPreview.Init();
                    TempPreview."Line No." := LineNo;
                    TempPreview."Item No." := Item."No.";
                    TempPreview.Description := Item.Description;
                    TempPreview.Model := Model;
                    TempPreview.Value := Round(Amount, 0.01);
                    if TempPreview.Value > 0 then
                        TempPreview.Class := TempPreview.Class::C
                    else
                        TempPreview.Class := TempPreview.Class::D;
                    TempPreview.Insert();
                    TotalValue += TempPreview.Value;
                end;
            until Item.Next() = 0;

        if TotalValue = 0 then
            exit;

        // Classify by cumulative share, highest value first. Zero-value lines keep class D.
        TempPreview.SetCurrentKey(Value);
        TempPreview.Ascending(false);
        TempPreview.SetFilter(Value, '>0');
        if TempPreview.FindSet() then
            repeat
                TempPreview."Value %" := TempPreview.Value / TotalValue * 100;
                CumPct += TempPreview."Value %";
                TempPreview."Cum. %" := CumPct;
                TempPreview.Class := ClassFromCumPercent(Model, Setup, CumPct);
                TempPreview.Modify();
            until TempPreview.Next() = 0;

        TempPreview.Reset();
    end;

    /// <summary>
    /// Writes the preview classes to Items and SKUs, records a history entry and optionally
    /// updates physical inventory counting period codes. Returns the number of items updated.
    /// Items with "ABC Manual Override" are recorded in history but not changed.
    /// </summary>
    procedure ApplyPreview(var TempPreview: Record "GSO ABC Preview Line" temporary; Model: Enum "GSO ABC Model"; StartDate: Date; EndDate: Date) Updated: Integer
    var
        Setup: Record "GSO ABC Analysis Setup";
        TempBuf: Record "GSO ABC Preview Line" temporary;
        Item: Record Item;
        HistHdr: Record "GSO ABC History Header";
        HistLine: Record "GSO ABC History Line";
        NowDT: DateTime;
        TotalAmt: Decimal;
        PeriodCode: Code[10];
        UpdateCounting: Boolean;
    begin
        EnsureSetup(Setup);
        if Setup."Update Counting Codes" then
            EnsurePolicyExists(Setup."Counting Code Mapping ID");

        TempBuf.Copy(TempPreview, true);
        TempBuf.Reset();
        if TempBuf.IsEmpty() then
            Error(NoLinesErr);

        NowDT := CurrentDateTime();

        HistHdr.Init();
        HistHdr.Model := Model;
        HistHdr."Start Date" := StartDate;
        HistHdr."End Date" := EndDate;
        HistHdr."Created By" := CopyStr(UserId(), 1, MaxStrLen(HistHdr."Created By"));
        HistHdr."Created At" := NowDT;
        HistHdr."Items Count" := TempBuf.Count();
        HistHdr.Insert(true);

        TempBuf.FindSet();
        repeat
            HistLine.Init();
            HistLine."Entry No." := HistHdr."Entry No.";
            HistLine."Line No." := TempBuf."Line No.";
            HistLine."Item No." := TempBuf."Item No.";
            HistLine.Value := TempBuf.Value;
            HistLine."Value %" := TempBuf."Value %";
            HistLine."Cum. %" := TempBuf."Cum. %";
            HistLine.Class := TempBuf.Class;
            HistLine.Insert(true);
            TotalAmt += TempBuf.Value;

            if Item.Get(TempBuf."Item No.") then
                if not Item."GSO Manual Override" then begin
                    UpdateCounting := false;
                    if Setup."Update Counting Codes" then
                        UpdateCounting := GetCountingPeriodCode(Setup, Model, TempBuf.Class, PeriodCode);

                    SetItemClass(Item, Model, TempBuf.Class, NowDT);
                    if UpdateCounting and (Item."Phys Invt Counting Period Code" <> PeriodCode) then begin
                        Item.Validate("Phys Invt Counting Period Code", PeriodCode);
                        Item.Modify(true);
                    end else
                        Item.Modify(false);

                    UpdateSKUs(Item."No.", Model, TempBuf.Class, NowDT, UpdateCounting and Setup."Update SKU", PeriodCode);
                    Updated += 1;
                end;
        until TempBuf.Next() = 0;

        HistHdr."Total Amount" := TotalAmt;
        HistHdr.Modify(true);

        Setup."Last Run" := NowDT;
        Setup.Modify(true);
    end;

    /// <summary>
    /// Recalculates every model using its own period from setup. Used by the job queue.
    /// </summary>
    procedure RecalculateAllModels(ApplyChanges: Boolean)
    var
        TempPreview: Record "GSO ABC Preview Line" temporary;
        Model: Enum "GSO ABC Model";
        Ordinal: Integer;
        StartDate: Date;
        EndDate: Date;
    begin
        foreach Ordinal in Model.Ordinals() do begin
            Model := Enum::"GSO ABC Model".FromInteger(Ordinal);
            GetDefaultDates(Model, StartDate, EndDate);
            CalculatePreview(Model, StartDate, EndDate, TempPreview);
            if ApplyChanges and not TempPreview.IsEmpty() then
                ApplyPreview(TempPreview, Model, StartDate, EndDate);
        end;
    end;

    /// <summary>
    /// Returns the default analysis window for a model: work date back by the period configured in setup.
    /// </summary>
    procedure GetDefaultDates(Model: Enum "GSO ABC Model"; var StartDate: Date; var EndDate: Date)
    var
        Setup: Record "GSO ABC Analysis Setup";
        DaysBack: Integer;
    begin
        GetSetup(Setup);
        case Model of
            Model::Revenue:
                DaysBack := Setup."Rev Period (Days)";
            Model::"Gross Profit":
                DaysBack := Setup."GP Period (Days)";
            Model::COGS:
                DaysBack := Setup."COGS Period (Days)";
            Model::"Usage Value":
                DaysBack := Setup."Usage Value Period (Days)";
            Model::GMROII:
                DaysBack := Setup."GMROII Period (Days)";
            Model::"Pick Frequency":
                DaysBack := Setup."Pick Freq Period (Days)";
        end;
        if DaysBack <= 0 then
            DaysBack := 365;

        EndDate := WorkDate();
        StartDate := CalcDate(StrSubstNo(DateFormulaTok, DaysBack), EndDate);
    end;

    /// <summary>
    /// Calculates the ranking value of one item for a model and period. Shared by the worksheet and all reports.
    /// </summary>
    procedure CalcItemValue(Model: Enum "GSO ABC Model"; StartDate: Date; EndDate: Date; ItemNo: Code[20]): Decimal
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        Amount: Decimal;
        Cost: Decimal;
        AvgInv: Decimal;
    begin
        case Model of
            Model::"Pick Frequency":
                begin
                    // Number of outbound (pick/issue) ledger entries
                    ItemLedgerEntry.SetRange("Item No.", ItemNo);
                    ItemLedgerEntry.SetFilter("Entry Type", '%1|%2',
                        ItemLedgerEntry."Entry Type"::Sale,
                        ItemLedgerEntry."Entry Type"::Consumption);
                    SetPostingDateFilter(ItemLedgerEntry, StartDate, EndDate);
                    exit(ItemLedgerEntry.Count());
                end;
            Model::GMROII:
                begin
                    // Gross margin in the period divided by current inventory value, as a percentage
                    ValueEntry.SetRange("Item No.", ItemNo);
                    ValueEntry.SetFilter("Item Ledger Entry Type", '%1|%2|%3',
                        ValueEntry."Item Ledger Entry Type"::Sale,
                        ValueEntry."Item Ledger Entry Type"::Consumption,
                        ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.");
                    SetPostingDateFilter(ValueEntry, StartDate, EndDate);
                    ValueEntry.CalcSums("Sales Amount (Actual)", "Cost Amount (Actual)");
                    Amount := ValueEntry."Sales Amount (Actual)" + ValueEntry."Cost Amount (Actual)";

                    if not Item.Get(ItemNo) then
                        exit(0);
                    Item.CalcFields(Inventory);
                    AvgInv := Item.Inventory * Item."Unit Cost";
                    if AvgInv <= 0 then
                        exit(0);
                    exit(Amount / AvgInv * 100);
                end;
            else begin
                ValueEntry.SetRange("Item No.", ItemNo);
                // Gross Profit only makes sense on sales; the other value models include consumption and scrap
                if Model = Model::"Gross Profit" then
                    ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale)
                else
                    ValueEntry.SetFilter("Item Ledger Entry Type", '%1|%2|%3',
                        ValueEntry."Item Ledger Entry Type"::Sale,
                        ValueEntry."Item Ledger Entry Type"::Consumption,
                        ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.");
                SetPostingDateFilter(ValueEntry, StartDate, EndDate);

                case Model of
                    Model::Revenue:
                        begin
                            ValueEntry.CalcSums("Sales Amount (Actual)");
                            exit(ValueEntry."Sales Amount (Actual)");
                        end;
                    Model::"Gross Profit":
                        begin
                            ValueEntry.CalcSums("Sales Amount (Actual)", "Cost Amount (Actual)");
                            exit(ValueEntry."Sales Amount (Actual)" + ValueEntry."Cost Amount (Actual)"); // cost is negative
                        end;
                    else begin
                        // COGS and Usage Value: outbound cost as a positive number
                        if ValueEntry.FindSet() then
                            repeat
                                Cost := ValueEntry."Cost Amount (Actual)";
                                if Cost < 0 then
                                    Amount += -Cost
                                else
                                    if Model = Model::"Usage Value" then
                                        Amount += Cost;
                            until ValueEntry.Next() = 0;
                        exit(Amount);
                    end;
                end;
            end;
        end;
    end;

    /// <summary>
    /// Reads the setup record. When it does not exist the defaults are returned without inserting.
    /// </summary>
    procedure GetSetup(var Setup: Record "GSO ABC Analysis Setup")
    begin
        if Setup.Get(SetupCodeTok) then
            exit;
        InitSetupDefaults(Setup);
    end;

    /// <summary>
    /// Reads the setup record, creating it with defaults when missing.
    /// </summary>
    procedure EnsureSetup(var Setup: Record "GSO ABC Analysis Setup")
    begin
        if Setup.Get(SetupCodeTok) then
            exit;
        InitSetupDefaults(Setup);
        Setup.Insert(true);
    end;

    local procedure InitSetupDefaults(var Setup: Record "GSO ABC Analysis Setup")
    var
        ModInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModInfo);
        Setup.Init();
        Setup."Primary Key" := SetupCodeTok;
        Setup."Counting Code Mapping ID" := DefaultPolicyTok;
        Setup."Last Upgraded To" := CopyStr(Format(ModInfo.AppVersion), 1, MaxStrLen(Setup."Last Upgraded To"));
    end;

    procedure EnsurePolicyExists(HeaderCode: Code[10]): Boolean
    var
        Header: Record "GSO ABC Counting Policy Header";
    begin
        if HeaderCode = '' then
            exit(false);

        if not Header.Get(HeaderCode) then begin
            Header.Init();
            Header.Code := HeaderCode;
            Header.Description := CopyStr(StrSubstNo(PolicyDescriptionLbl, HeaderCode), 1, MaxStrLen(Header.Description));
            Header.Insert(true);
        end;

        EnsureDefaultPolicyLines(HeaderCode);
        exit(true);
    end;

    local procedure EnsureDefaultPolicyLines(HeaderCode: Code[10])
    var
        Line: Record "GSO ABC Counting Policy Line";
        Model: Enum "GSO ABC Model";
        Class: Enum "GSO ABC Class";
        ModelOrdinal: Integer;
        ClassOrdinal: Integer;
    begin
        foreach ModelOrdinal in Model.Ordinals() do
            foreach ClassOrdinal in Class.Ordinals() do
                if ClassOrdinal <> Class::Unknown.AsInteger() then
                    if not Line.Get(HeaderCode, Enum::"GSO ABC Model".FromInteger(ModelOrdinal), Enum::"GSO ABC Class".FromInteger(ClassOrdinal)) then begin
                        Line.Init();
                        Line."Header Code" := HeaderCode;
                        Line.Model := Enum::"GSO ABC Model".FromInteger(ModelOrdinal);
                        Line.Class := Enum::"GSO ABC Class".FromInteger(ClassOrdinal);
                        Line.Insert(true);
                    end;
    end;

    // ---- helpers ----

    local procedure SetPostingDateFilter(var ValueEntry: Record "Value Entry"; StartDate: Date; EndDate: Date)
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
            exit;
        if (StartDate <> 0D) and (EndDate <> 0D) then
            ValueEntry.SetRange("Posting Date", StartDate, EndDate)
        else
            if StartDate <> 0D then
                ValueEntry.SetFilter("Posting Date", '>=%1', StartDate)
            else
                ValueEntry.SetFilter("Posting Date", '<=%1', EndDate);
    end;

    local procedure SetPostingDateFilter(var ItemLedgerEntry: Record "Item Ledger Entry"; StartDate: Date; EndDate: Date)
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
            exit;
        if (StartDate <> 0D) and (EndDate <> 0D) then
            ItemLedgerEntry.SetRange("Posting Date", StartDate, EndDate)
        else
            if StartDate <> 0D then
                ItemLedgerEntry.SetFilter("Posting Date", '>=%1', StartDate)
            else
                ItemLedgerEntry.SetFilter("Posting Date", '<=%1', EndDate);
    end;

    local procedure ClassFromCumPercent(Model: Enum "GSO ABC Model"; Setup: Record "GSO ABC Analysis Setup"; CumPct: Decimal): Enum "GSO ABC Class"
    var
        ATh: Decimal;
        BTh: Decimal;
    begin
        case Model of
            Model::Revenue:
                begin
                    ATh := Setup."Rev A %";
                    BTh := Setup."Rev B %";
                end;
            Model::"Gross Profit":
                begin
                    ATh := Setup."GP A %";
                    BTh := Setup."GP B %";
                end;
            Model::COGS:
                begin
                    ATh := Setup."COGS A %";
                    BTh := Setup."COGS B %";
                end;
            Model::"Usage Value":
                begin
                    ATh := Setup."Usage Value A %";
                    BTh := Setup."Usage Value B %";
                end;
            Model::GMROII:
                begin
                    ATh := Setup."GMROII A %";
                    BTh := Setup."GMROII B %";
                end;
            Model::"Pick Frequency":
                begin
                    ATh := Setup."Pick Freq A %";
                    BTh := Setup."Pick Freq B %";
                end;
        end;

        if CumPct <= ATh then
            exit(Enum::"GSO ABC Class"::A);
        if CumPct <= BTh then
            exit(Enum::"GSO ABC Class"::B);
        exit(Enum::"GSO ABC Class"::C);
    end;

    local procedure SetItemClass(var Item: Record Item; Model: Enum "GSO ABC Model"; Class: Enum "GSO ABC Class"; NowDT: DateTime)
    begin
        case Model of
            Model::Revenue:
                begin
                    Item."GSO Class (Revenue)" := Class;
                    Item."GSO Last Calc (Revenue)" := NowDT;
                end;
            Model::"Gross Profit":
                begin
                    Item."GSO Class (Gross Profit)" := Class;
                    Item."GSO Last Calc (GP)" := NowDT;
                end;
            Model::COGS:
                begin
                    Item."GSO Class (COGS)" := Class;
                    Item."GSO Last Calc (COGS)" := NowDT;
                end;
            Model::"Usage Value":
                begin
                    Item."GSO Class (Usage Value)" := Class;
                    Item."GSO Last Calc (Usage Value)" := NowDT;
                end;
            Model::GMROII:
                begin
                    Item."GSO Class (GMROII)" := Class;
                    Item."GSO Last Calc (GMROII)" := NowDT;
                end;
            Model::"Pick Frequency":
                begin
                    Item."GSO Class (Pick Frequency)" := Class;
                    Item."GSO Last Calc (Pick Freq)" := NowDT;
                end;
        end;
    end;

    local procedure SetSKUClass(var SKU: Record "Stockkeeping Unit"; Model: Enum "GSO ABC Model"; Class: Enum "GSO ABC Class"; NowDT: DateTime)
    begin
        case Model of
            Model::Revenue:
                begin
                    SKU."GSO Class (Revenue)" := Class;
                    SKU."GSO Last Calc (Revenue)" := NowDT;
                end;
            Model::"Gross Profit":
                begin
                    SKU."GSO Class (Gross Profit)" := Class;
                    SKU."GSO Last Calc (GP)" := NowDT;
                end;
            Model::COGS:
                begin
                    SKU."GSO Class (COGS)" := Class;
                    SKU."GSO Last Calc (COGS)" := NowDT;
                end;
            Model::"Usage Value":
                begin
                    SKU."GSO Class (Usage Value)" := Class;
                    SKU."GSO Last Calc (Usage Value)" := NowDT;
                end;
            Model::GMROII:
                begin
                    SKU."GSO Class (GMROII)" := Class;
                    SKU."GSO Last Calc (GMROII)" := NowDT;
                end;
            Model::"Pick Frequency":
                begin
                    SKU."GSO Class (Pick Frequency)" := Class;
                    SKU."GSO Last Calc (Pick Freq)" := NowDT;
                end;
        end;
    end;

    local procedure UpdateSKUs(ItemNo: Code[20]; Model: Enum "GSO ABC Model"; Class: Enum "GSO ABC Class"; NowDT: DateTime; UpdateCounting: Boolean; PeriodCode: Code[10])
    var
        SKU: Record "Stockkeeping Unit";
    begin
        SKU.SetRange("Item No.", ItemNo);
        if SKU.FindSet(true) then
            repeat
                SetSKUClass(SKU, Model, Class, NowDT);
                if UpdateCounting and (SKU."Phys Invt Counting Period Code" <> PeriodCode) then begin
                    SKU.Validate("Phys Invt Counting Period Code", PeriodCode);
                    SKU.Modify(true);
                end else
                    SKU.Modify(false);
            until SKU.Next() = 0;
    end;

    local procedure GetCountingPeriodCode(Setup: Record "GSO ABC Analysis Setup"; Model: Enum "GSO ABC Model"; Class: Enum "GSO ABC Class"; var PeriodCode: Code[10]): Boolean
    var
        Line: Record "GSO ABC Counting Policy Line";
    begin
        PeriodCode := '';
        if Setup."Counting Code Mapping ID" = '' then
            exit(false);
        if not Line.Get(Setup."Counting Code Mapping ID", Model, Class) then
            exit(false);
        PeriodCode := Line."Counting Period Code";
        exit(PeriodCode <> '');
    end;
}
