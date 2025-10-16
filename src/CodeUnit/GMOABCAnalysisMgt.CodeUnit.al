codeunit 73030582 "GMO ABC Analysis Mgt."
{


    procedure CalculatePreview(Model: Enum "GMO ABC Model"; StartDate: Date; EndDate: Date; var TempPreview: Record "GMO ABC Preview Line" temporary)
    var
        Setup: Record "GMO ABC Analysis Setup";
        Item: Record Item;
        Amount: Decimal;
        CumPct: Decimal;
        TotalValue: Decimal;
        LNo: Integer;
    begin
        EnsureSetup(Setup);
        TempPreview.DeleteAll();
        TotalValue := 0;
        LNo := 0;

        Item.Reset();
        Item.SetRange(Blocked, false);
        if Item.FindSet() then
            repeat
                Amount := CalcItemAmount(Model, StartDate, EndDate, Item."No.");
                if Amount < 0 then Amount := 0;

                // Skip items with zero value - don't display them
                if Amount > 0 then begin
                    if LNo = 0 then LNo := NextLineNo(TempPreview);

                    TempPreview.Init();
                    TempPreview."Line No." := LNo;
                    LNo += 10000;

                    TempPreview."Item No." := Item."No.";
                    TempPreview.Description := Item.Description;
                    TempPreview.Model := Model;
                    TempPreview.Value := Round(Amount, 0.01, '=');
                    TempPreview."Value %" := 0;
                    TempPreview."Cum. %" := 0;
                    TempPreview.Class := TempPreview.Class::C;
                    TempPreview.Insert();

                    TotalValue += Amount;
                end;
            until Item.Next() = 0;

        if TotalValue = 0 then exit;

        // Classify items by value
        TempPreview.Reset();
        TempPreview.SetCurrentKey(Value);
        TempPreview.Ascending(false);

        CumPct := 0;
        if TempPreview.FindSet() then
            repeat
                TempPreview."Value %" := (TempPreview.Value / TotalValue) * 100;
                CumPct += TempPreview."Value %";
                TempPreview."Cum. %" := CumPct;
                TempPreview.Class := ClassFromCumPercent(Model, Setup, CumPct);
                TempPreview.Modify();
            until TempPreview.Next() = 0;

        TempPreview.Reset();
    end;

    procedure ApplyPreview(var TempPreview: Record "GMO ABC Preview Line" temporary; Model: enum "GMO ABC Model"; StartDate: Date; EndDate: Date)
    var
        Setup: Record "GMO ABC Analysis Setup";
        TempBuf: Record "GMO ABC Preview Line" temporary;
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        HistHdr: Record "GMO ABC History Header";
        HistLine: Record "GMO ABC History Line";
        NowDT: DateTime;
        Updated: Integer;
        TotalAmt: Decimal;
    begin
        EnsureSetup(Setup);

        // 🔒 Defensive copy (server-side) so we control filters and traversal
        TempBuf.Copy(TempPreview, true);
        TempBuf.Reset();

        if TempBuf.IsEmpty() then
            Error('No preview lines to apply. Run Calculate first.');

        NowDT := CurrentDateTime;
        Updated := 0;
        TotalAmt := 0;

        // Create history header
        HistHdr.Init();
        HistHdr.Model := Model;
        HistHdr."Start Date" := StartDate;
        HistHdr."End Date" := EndDate;
        HistHdr."Created By" := CopyStr(UserId(), 1, 50);
        HistHdr."Created At" := NowDT;
        HistHdr.Insert(true);

        if TempBuf.FindSet() then
            repeat
                if not Item.Get(TempBuf."Item No.") then
                    continue;

                case Model of
                    Model::Revenue:
                        begin
                            Item.Validate("GMO Class (Revenue)", TempBuf.Class);
                            Item.Validate("GMO Last Calc (Revenue)", NowDT);
                        end;
                    Model::"Gross Profit":
                        begin
                            Item.Validate("GMO Class (Gross Profit)", TempBuf.Class);
                            Item.Validate("GMO Last Calc (GP)", NowDT);
                        end;
                    Model::COGS:
                        begin
                            Item.Validate("GMO Class (COGS)", TempBuf.Class);
                            Item.Validate("GMO Last Calc (COGS)", NowDT);
                        end;
                    Model::"Sales Quantity":
                        begin
                            Item.Validate("GMO Class (Sales Qty)", TempBuf.Class);
                            Item.Validate("GMO Last Calc (Sales Qty)", NowDT);
                        end;
                    Model::"Usage Value":
                        begin
                            Item.Validate("GMO Class (Usage Value)", TempBuf.Class);
                            Item.Validate("GMO Last Calc (Usage Value)", NowDT);
                        end;
                end;
                Item.Modify(true);
                Updated += 1;
                TotalAmt += TempBuf.Value;

                // Create history line
                HistLine.Init();
                HistLine."Entry No." := HistHdr."Entry No.";
                HistLine."Line No." := TempBuf."Line No.";
                HistLine."Item No." := TempBuf."Item No.";
                HistLine.Value := TempBuf.Value;
                HistLine."Value %" := TempBuf."Value %";
                HistLine."Cum. %" := TempBuf."Cum. %";
                HistLine.Class := TempBuf.Class;
                HistLine.Insert(true);

                // Optional: update counting period code per policy
                MaybeUpdateCountingCode(Item."No.", TempBuf.Class, Model, Setup);

                // Mirror to SKUs
                SKU.Reset();
                SKU.SetRange("Item No.", Item."No.");
                if SKU.FindSet(true) then
                    repeat
                        case Model of
                            Model::Revenue:
                                begin
                                    SKU.Validate("GMO Class (Revenue)", TempBuf.Class);
                                    SKU.Validate("GMO Last Calc (Revenue)", NowDT);
                                end;
                            Model::"Gross Profit":
                                begin
                                    SKU.Validate("GMO Class (Gross Profit)", TempBuf.Class);
                                    SKU.Validate("GMO Last Calc (GP)", NowDT);
                                end;
                            Model::COGS:
                                begin
                                    SKU.Validate("GMO Class (COGS)", TempBuf.Class);
                                    SKU.Validate("GMO Last Calc (COGS)", NowDT);
                                end;
                            Model::"Sales Quantity":
                                begin
                                    SKU.Validate("GMO Class (Sales Qty)", TempBuf.Class);
                                    SKU.Validate("GMO Last Calc (Sales Qty)", NowDT);
                                end;
                            Model::"Usage Value":
                                begin
                                    SKU.Validate("GMO Class (Usage Value)", TempBuf.Class);
                                    SKU.Validate("GMO Last Calc (Usage Value)", NowDT);
                                end;
                        end;
                        SKU.Modify(true);
                    until SKU.Next() = 0;
            until TempBuf.Next() = 0;

        // Update history header totals
        HistHdr."Total Amount" := TotalAmt;
        HistHdr."Items Count" := Updated;
        HistHdr.Modify(true);

        // Update the "Last Run" timestamp in Setup
        if Setup.Get('SETUP') then begin
            Setup."Last Run" := NowDT;
            Setup.Modify(true);
        end;

        // Optional info message (kept silent here to avoid double-message with page)
        // Message('%1 items updated.', Updated);
    end;

    procedure RecalculateAllDistinctWindows(ApplyChanges: Boolean)
    var
        Setup: Record "GMO ABC Analysis Setup";
        TempPreview: Record "GMO ABC Preview Line" temporary;
        E, S : Date;
        Model: Enum "GMO ABC Model";
    begin
        EnsureSetup(Setup);

        Model := Model::Revenue;
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, TempPreview);
        if ApplyChanges and not TempPreview.IsEmpty() then
            ApplyPreview(TempPreview, Model, S, E);

        TempPreview.DeleteAll();
        Model := Model::"Gross Profit";
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, TempPreview);
        if ApplyChanges and not TempPreview.IsEmpty() then
            ApplyPreview(TempPreview, Model, S, E);

        TempPreview.DeleteAll();
        Model := Model::COGS;
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, TempPreview);
        if ApplyChanges and not TempPreview.IsEmpty() then
            ApplyPreview(TempPreview, Model, S, E);
    end;

    procedure RecalculateAllUsingSetupPeriods(ApplyChanges: Boolean)
    begin
        RecalculateAllDistinctWindows(ApplyChanges);
    end;

    procedure RunABCReportInteractive()
    begin
        Report.RunModal(Report::"GMO ABC Analysis", true, false);
    end;

    // ---- helpers ----

    local procedure NextLineNo(var Buf: Record "GMO ABC Preview Line" temporary): Integer
    begin
        Buf.SetCurrentKey("Line No.");
        if Buf.FindLast() then
            exit(Buf."Line No." + 10000);
        exit(10000);
    end;

    local procedure EnsureSetup(var Setup: Record "GMO ABC Analysis Setup")
    begin
        if Setup.Get('SETUP') then exit;

        Setup.Init();
        Setup."Primary Key" := 'SETUP';
        Setup."Rev A %" := 80;
        Setup."Rev B %" := 95;
        Setup."Rev Period (Days)" := 365;
        Setup."GP A %" := 80;
        Setup."GP B %" := 95;
        Setup."GP Period (Days)" := 365;
        Setup."COGS A %" := 80;
        Setup."COGS B %" := 95;
        Setup."COGS Period (Days)" := 365;
        Setup."Sales Qty A %" := 80;
        Setup."Sales Qty B %" := 95;
        Setup."Sales Qty Period (Days)" := 365;
        Setup."Usage Value A %" := 80;
        Setup."Usage Value B %" := 95;
        Setup."Usage Value Period (Days)" := 365;
        Setup."Counting Code Mapping ID" := 'DEFAULT';
        Setup.Insert(true);
    end;

    local procedure CalcItemAmount(Model: Enum "GMO ABC Model"; StartDate: Date; EndDate: Date; ItemNo: Code[20]): Decimal
    var
        VE: Record "Value Entry";
        amt: Decimal;
        c: Decimal;
        s: Decimal;
        q: Decimal;
    begin
        amt := 0;
        VE.Reset();
        VE.SetRange("Item No.", ItemNo);
        // Include: Sale, Consumption, Negative Adjmt (for scrap)
        // Exclude: Output, Purchase, Positive Adjmt, Transfer, etc.
        VE.SetFilter("Item Ledger Entry Type", '%1|%2|%3',
            VE."Item Ledger Entry Type"::Sale,
            VE."Item Ledger Entry Type"::Consumption,
            VE."Item Ledger Entry Type"::"Negative Adjmt.");
        if (StartDate <> 0D) or (EndDate <> 0D) then
            VE.SetRange("Posting Date", StartDate, EndDate);

        if VE.FindSet(false) then
            repeat
                case Model of
                    Model::Revenue:
                        begin
                            s := VE."Sales Amount (Actual)";
                            amt += s;
                        end;
                    Model::"Gross Profit":
                        begin
                            s := VE."Sales Amount (Actual)";
                            c := VE."Cost Amount (Actual)";
                            amt += (s + c); // cost is negative → profit
                        end;
                    Model::COGS:
                        begin
                            c := VE."Cost Amount (Actual)";
                            if c < 0 then
                                amt += -c; // outbound cost only
                        end;
                    Model::"Sales Quantity":
                        begin
                            q := VE."Invoiced Quantity";
                            if q > 0 then
                                amt += q; // positive sales quantity only
                        end;
                    Model::"Usage Value":
                        begin
                            // Usage Value = (Sales + Consumption) Qty × Unit Cost
                            // For outbound entries, use absolute values
                            q := VE."Invoiced Quantity";
                            c := VE."Cost Amount (Actual)";
                            if q < 0 then q := -q; // make quantity positive
                            if c < 0 then c := -c; // make cost positive
                            amt += c; // Cost already represents Qty × Unit Cost
                        end;
                end;
            until VE.Next() = 0;

        exit(amt);
    end;

    local procedure ClassFromCumPercent(Model: Enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup"; CumPct: Decimal): Enum "GMO ABC Class"
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
            Model::"Sales Quantity":
                begin
                    ATh := Setup."Sales Qty A %";
                    BTh := Setup."Sales Qty B %";
                end;
            Model::"Usage Value":
                begin
                    ATh := Setup."Usage Value A %";
                    BTh := Setup."Usage Value B %";
                end;
        end;

        if CumPct <= ATh then exit(ABC() ::A);
        if CumPct <= BTh then exit(ABC() ::B);
        exit(ABC() ::C);
    end;

    local procedure ABC(): Enum "GMO ABC Class"
    var
        ABCClass: Enum "GMO ABC Class";
    begin
        exit(ABCClass);
    end;

    local procedure MaybeUpdateCountingCode(ItemNo: Code[20]; ABCClassification: Enum "GMO ABC Class"; Model: Enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup")
    var
        Line: Record "GMO ABC Counting Policy Line";
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        PeriodCode: Code[10];
        HeaderCode: Code[10];
    begin
        HeaderCode := Setup."Counting Code Mapping ID";
        if HeaderCode = '' then HeaderCode := 'DEFAULT';

        if not EnsurePolicyExists(HeaderCode) then exit;
        if not Line.Get(HeaderCode, Model, ABCClassification) then exit;

        PeriodCode := Line."Counting Period Code";
        if PeriodCode = '' then exit;

        if Item.Get(ItemNo) then 
            if Item."Phys Invt Counting Period Code" <> PeriodCode then begin
                Item.Validate("Phys Invt Counting Period Code", PeriodCode);
                Item.Modify(true);
            end;


        SKU.Reset();
        SKU.SetRange("Item No.", ItemNo);
        if SKU.FindSet(true) then
            repeat
                if SKU."Phys Invt Counting Period Code" <> PeriodCode then begin
                    SKU.Validate("Phys Invt Counting Period Code", PeriodCode);
                    SKU.Modify(true);
                end;
            until SKU.Next() = 0;
    end;

    procedure EnsurePolicyExists(HeaderCode: Code[10]): Boolean
    var
        H: Record "GMO ABC Counting Policy Header";
        PolicyDescriptionLbl: Label '%1 ABC → Counting Period mapping', Comment = '%1 = Header Code';
    begin
        if HeaderCode = '' then exit(false);

        if H.Get(HeaderCode) then exit(true);

        H.Init();
        H.Code := HeaderCode;
        H.Description := StrSubstNo(PolicyDescriptionLbl, HeaderCode);
        H.Insert(true);

        EnsureDefaultPolicyLines(HeaderCode);
        exit(true);
    end;

    local procedure EnsureDefaultPolicyLines(HeaderCode: Code[10])
    begin
        EnsurePolicyLine(HeaderCode, ModelOpt() ::Revenue, ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::Revenue, ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::Revenue, ClassOpt() ::C);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::Revenue, ClassOpt() ::D);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Gross Profit", ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Gross Profit", ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Gross Profit", ClassOpt() ::C);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Gross Profit", ClassOpt() ::D);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::C);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::D);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Sales Quantity", ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Sales Quantity", ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Sales Quantity", ClassOpt() ::C);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Sales Quantity", ClassOpt() ::D);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Usage Value", ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Usage Value", ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Usage Value", ClassOpt() ::C);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Usage Value", ClassOpt() ::D);
    end;

    local procedure EnsurePolicyLine(HeaderCode: Code[10]; Model: enum "GMO ABC Model"; ABCClassification: enum "GMO ABC Class")
    var
        L: Record "GMO ABC Counting Policy Line";
    begin
        if L.Get(HeaderCode, Model, ABCClassification) then
            exit;

        L.Init();
        L."Header Code" := HeaderCode;
        L.Model := Model;
        L.Class := ABCClassification;
        L.Insert(true);
    end;

    local procedure ModelOpt(): enum "GMO ABC Model"
    var
        Model: Enum "GMO ABC Model";
    begin
        exit(Model);
    end;

    local procedure ClassOpt(): enum "GMO ABC Class"
    var
        ABCClass: Enum "GMO ABC Class";
    begin
        exit(ABCClass);
    end;

    local procedure CalcDatesFromSetup(Model: enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup"; AnchorDate: Date; var StartDate: Date; var EndDate: Date)
    var
        DaysBack: Integer;
        DateFormulaLbl: Label '<-%1D>', Comment = '%1 = Number of days', Locked = true;
    begin
        case Model of
            Model::Revenue:
                DaysBack := Setup."Rev Period (Days)";
            Model::"Gross Profit":
                DaysBack := Setup."GP Period (Days)";
            Model::COGS:
                DaysBack := Setup."COGS Period (Days)";
            Model::"Sales Quantity":
                DaysBack := Setup."Sales Qty Period (Days)";
            Model::"Usage Value":
                DaysBack := Setup."Usage Value Period (Days)";
        end;
        if DaysBack <= 0 then DaysBack := 365;

        EndDate := AnchorDate;
        StartDate := CalcDate(StrSubstNo(DateFormulaLbl, DaysBack), AnchorDate);
    end;
}
