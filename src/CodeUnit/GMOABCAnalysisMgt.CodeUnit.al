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

                if Amount <> 0 then begin
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
    end;

    procedure ApplyPreview(var TempPreview: Record "GMO ABC Preview Line" temporary; Model: enum "GMO ABC Model"; StartDate: Date; EndDate: Date)
    var
        Setup: Record "GMO ABC Analysis Setup";
        Buf: Record "GMO ABC Preview Line" temporary;
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
        Buf.Copy(TempPreview, true);
        Buf.Reset();

        if Buf.IsEmpty() then
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

        if Buf.FindSet() then
            repeat
                if not Item.Get(Buf."Item No.") then
                    continue;

                case Model of
                    Model::Revenue:
                        begin
                            Item.Validate("GMO Class (Revenue)", Buf.Class);
                            Item.Validate("GMO Last Calc (Revenue)", NowDT);
                        end;
                    Model::"Gross Profit":
                        begin
                            Item.Validate("GMO Class (Gross Profit)", Buf.Class);
                            Item.Validate("GMO Last Calc (GP)", NowDT);
                        end;
                    Model::COGS:
                        begin
                            Item.Validate("GMO Class (COGS)", Buf.Class);
                            Item.Validate("GMO Last Calc (COGS)", NowDT);
                        end;
                end;
                Item.Modify(true);
                Updated += 1;
                TotalAmt += Buf.Value;

                // Create history line
                HistLine.Init();
                HistLine."Entry No." := HistHdr."Entry No.";
                HistLine."Line No." := Buf."Line No.";
                HistLine."Item No." := Buf."Item No.";
                HistLine.Value := Buf.Value;
                HistLine."Value %" := Buf."Value %";
                HistLine."Cum. %" := Buf."Cum. %";
                HistLine.Class := Buf.Class;
                HistLine.Insert(true);

                // Optional: update counting period code per policy
                MaybeUpdateCountingCode(Item."No.", Buf.Class, Model, Setup);

                // Mirror to SKUs
                SKU.Reset();
                SKU.SetRange("Item No.", Item."No.");
                if SKU.FindSet(true) then
                    repeat
                        case Model of
                            Model::Revenue:
                                begin
                                    SKU.Validate("GMO Class (Revenue)", Buf.Class);
                                    SKU.Validate("GMO Last Calc (Revenue)", NowDT);
                                end;
                            Model::"Gross Profit":
                                begin
                                    SKU.Validate("GMO Class (Gross Profit)", Buf.Class);
                                    SKU.Validate("GMO Last Calc (GP)", NowDT);
                                end;
                            Model::COGS:
                                begin
                                    SKU.Validate("GMO Class (COGS)", Buf.Class);
                                    SKU.Validate("GMO Last Calc (COGS)", NowDT);
                                end;
                        end;
                        SKU.Modify(true);
                    until SKU.Next() = 0;
            until Buf.Next() = 0;

        // Update history header totals
        HistHdr."Total Amount" := TotalAmt;
        HistHdr."Items Count" := Updated;
        HistHdr.Modify(true);

        // Optional info message (kept silent here to avoid double-message with page)
        // Message('%1 items updated.', Updated);
    end;

    procedure RecalculateAllDistinctWindows(ApplyChanges: Boolean)
    var
        Setup: Record "GMO ABC Analysis Setup";
        Preview: Record "GMO ABC Preview Line" temporary;
        E, S : Date;
        Model: Enum "GMO ABC Model";
    begin
        EnsureSetup(Setup);

        Model := Model::Revenue;
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, Preview);
        if ApplyChanges and not Preview.IsEmpty() then
            ApplyPreview(Preview, Model, S, E);

        Preview.DeleteAll();
        Model := Model::"Gross Profit";
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, Preview);
        if ApplyChanges and not Preview.IsEmpty() then
            ApplyPreview(Preview, Model, S, E);

        Preview.DeleteAll();
        Model := Model::COGS;
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, Preview);
        if ApplyChanges and not Preview.IsEmpty() then
            ApplyPreview(Preview, Model, S, E);
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
        Setup."Counting Code Mapping ID" := 'DEFAULT';
        Setup.Insert(true);
    end;

    local procedure CalcItemAmount(Model: Enum "GMO ABC Model"; StartDate: Date; EndDate: Date; ItemNo: Code[20]): Decimal
    var
        VE: Record "Value Entry";
        amt: Decimal;
        c: Decimal;
        s: Decimal;
    begin
        amt := 0;
        VE.Reset();
        VE.SetRange("Item No.", ItemNo);
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
        end;

        if CumPct <= ATh then exit(ABC() ::A);
        if CumPct <= BTh then exit(ABC() ::B);
        exit(ABC() ::C);
    end;

    local procedure ABC(): Enum "GMO ABC Class"
    begin
        exit(0);
    end;

    local procedure MaybeUpdateCountingCode(ItemNo: Code[20]; ClassOpt: Enum "GMO ABC Class"; Model: Enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup")
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
        if not Line.Get(HeaderCode, Model, ClassOpt) then exit;

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
    begin
        if HeaderCode = '' then exit(false);

        if H.Get(HeaderCode) then exit(true);

        H.Init();
        H.Code := HeaderCode;
        H.Description := StrSubstNo('%1 ABC → Counting Period mapping', HeaderCode);
        H.Insert(true);

        EnsureDefaultPolicyLines(HeaderCode);
        exit(true);
    end;

    local procedure EnsureDefaultPolicyLines(HeaderCode: Code[10])
    begin
        EnsurePolicyLine(HeaderCode, ModelOpt() ::Revenue, ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::Revenue, ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::Revenue, ClassOpt() ::C);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Gross Profit", ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Gross Profit", ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"Gross Profit", ClassOpt() ::C);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::C);
    end;

    local procedure EnsurePolicyLine(HeaderCode: Code[10]; Model: enum "GMO ABC Model"; ClassOpt: enum "GMO ABC Class")
    var
        L: Record "GMO ABC Counting Policy Line";
    begin
        if L.Get(HeaderCode, Model, ClassOpt) then
            exit;

        L.Init();
        L."Header Code" := HeaderCode;
        L.Model := Model;
        L.Class := ClassOpt;
        L.Insert(true);
    end;

    local procedure ModelOpt(): enum "GMO ABC Model"
    begin
        exit(0);
    end;

    local procedure ClassOpt(): enum "GMO ABC Class"
    begin
        exit(0);
    end;

    local procedure CalcDatesFromSetup(Model: enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup"; AnchorDate: Date; var StartDate: Date; var EndDate: Date)
    var
        DaysBack: Integer;
    begin
        case Model of
            Model::Revenue:
                DaysBack := Setup."Rev Period (Days)";
            Model::"Gross Profit":
                DaysBack := Setup."GP Period (Days)";
            Model::COGS:
                DaysBack := Setup."COGS Period (Days)";
        end;
        if DaysBack <= 0 then DaysBack := 365;

        EndDate := AnchorDate;
        StartDate := CalcDate(StrSubstNo('<-%1D>', DaysBack), AnchorDate);
    end;
}
