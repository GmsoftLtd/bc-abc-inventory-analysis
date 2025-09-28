codeunit 73030620 "GMO ABC Analysis Mgt."
{


    // =========================================================
    // PUBLIC API
    // =========================================================

    /// Build the temporary preview for the selected model and period.
    /// - Fills TempPreview with one line per Item having non-zero value.
    /// - Computes Value %, Cum. %, and Class (A/B/C) based on Setup thresholds.
    procedure CalculatePreview(Model: Enum "GMO ABC Model"; StartDate: Date; EndDate: Date; var TempPreview: Record "GMO ABC Preview Line" temporary)
    var
        Setup: Record "GMO ABC Analysis Setup";
        Item: Record Item;
        TotalValue: Decimal;
        CumPct: Decimal;
        Amount: Decimal;
    begin
        EnsureSetup(Setup);

        // Start fresh
        TempPreview.DeleteAll();
        TotalValue := 0;

        // Aggregate per item and upsert into temp buffer by PK ("Item No.", Model)
        Item.Reset();
        Item.SetRange(Blocked, false);
        if Item.FindSet() then
            repeat
                Amount := CalcItemAmount(Model, StartDate, EndDate, Item."No.");
                if Amount < 0 then
                    Amount := 0; // clamp negatives

                if Amount <> 0 then begin
                    if TempPreview.Get(Item."No.", Model) then begin
                        TempPreview.Value += Round(Amount, 0.01, '=');
                        TempPreview.Modify();
                    end else begin
                        TempPreview.Init();
                        TempPreview."Item No." := Item."No.";
                        TempPreview.Model := Model; // set both PK fields before Insert
                        TempPreview.Description := Item.Description;
                        TempPreview.Value := Round(Amount, 0.01, '=');
                        TempPreview."Value %" := 0;
                        TempPreview."Cum. %" := 0;
                        TempPreview.Class := TempPreview.Class::C;
                        TempPreview.Insert();
                    end;
                    TotalValue += Amount;
                end;
            until Item.Next() = 0;

        if TotalValue = 0 then
            exit;

        // Compute % and class in Value-desc order
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

    /// Apply preview lines to Item and SKUs for the given model/period.
    /// - Writes per-model class and timestamps.
    /// - Optionally maps to Physical Inventory Counting Period Code via policy lines.
    procedure ApplyPreview(var TempPreview: Record "GMO ABC Preview Line" temporary; Model: Enum "GMO ABC Model"; StartDate: Date; EndDate: Date)
    var
        Setup: Record "GMO ABC Analysis Setup";
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        NowDT: DateTime;
    begin
        EnsureSetup(Setup);

        if TempPreview.IsEmpty() then
            Error('No preview lines to apply. Run Calculate first.');

        NowDT := CurrentDateTime;

        TempPreview.Reset();
        if TempPreview.FindSet() then
            repeat
                if not Item.Get(TempPreview."Item No.") then
                    continue;

                // Update Item per model
                case Model of
                    Model::Revenue:
                        begin
                            Item.Validate("GMO Class (Revenue)", TempPreview.Class);
                            Item.Validate("GMO Last Calc (Revenue)", NowDT);
                        end;
                    Model::"GrossProfit":
                        begin
                            Item.Validate("GMO Class (Gross Profit)", TempPreview.Class);
                            Item.Validate("GMO Last Calc (GP)", NowDT);
                        end;
                    Model::COGS:
                        begin
                            Item.Validate("GMO Class (COGS)", TempPreview.Class);
                            Item.Validate("GMO Last Calc (COGS)", NowDT);
                        end;
                end;
                Item.Modify(true);

                // Map to counting period code if configured
                MaybeUpdateCountingCode(Item."No.", TempPreview.Class, Model, Setup);

                // Mirror to all SKUs for the item
                SKU.Reset();
                SKU.SetRange("Item No.", Item."No.");
                if SKU.FindSet(true) then
                    repeat
                        case Model of
                            Model::Revenue:
                                begin
                                    SKU.Validate("GMO Class (Revenue)", TempPreview.Class);
                                    SKU.Validate("GMO Last Calc (Revenue)", NowDT);
                                end;
                            Model::"GrossProfit":
                                begin
                                    SKU.Validate("GMO Class (Gross Profit)", TempPreview.Class);
                                    SKU.Validate("GMO Last Calc (GP)", NowDT);
                                end;
                            Model::COGS:
                                begin
                                    SKU.Validate("GMO Class (COGS)", TempPreview.Class);
                                    SKU.Validate("GMO Last Calc (COGS)", NowDT);
                                end;
                        end;
                        SKU.Modify(true);
                    until SKU.Next() = 0;
            until TempPreview.Next() = 0;
    end;

    /// Batch: recalc each model using its own Setup period; optionally apply.
    procedure RecalculateAllDistinctWindows(ApplyChanges: Boolean)
    var
        Setup: Record "GMO ABC Analysis Setup";
        Preview: Record "GMO ABC Preview Line" temporary;
        Model: Enum "GMO ABC Model";
        S, E : Date;
    begin
        EnsureSetup(Setup);

        // Revenue
        Model := Model::Revenue;
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, Preview);
        if ApplyChanges and not Preview.IsEmpty() then
            ApplyPreview(Preview, Model, S, E);

        // Gross Profit
        Preview.DeleteAll();
        Model := Model::"GrossProfit";
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, Preview);
        if ApplyChanges and not Preview.IsEmpty() then
            ApplyPreview(Preview, Model, S, E);

        // COGS
        Preview.DeleteAll();
        Model := Model::COGS;
        CalcDatesFromSetup(Model, Setup, WorkDate(), S, E);
        CalculatePreview(Model, S, E, Preview);
        if ApplyChanges and not Preview.IsEmpty() then
            ApplyPreview(Preview, Model, S, E);
    end;

    /// Alternative name: recalc each model using Setup windows (same as above).
    procedure RecalculateAllUsingSetupPeriods(ApplyChanges: Boolean)
    begin
        RecalculateAllDistinctWindows(ApplyChanges);
    end;

    /// Open the ABC report with its request page (user picks parameters).
    procedure RunABCReportInteractive()
    var
        ReportId: Integer;
    begin
        ReportId := Report::"GMO ABC Analysis";
        Report.RunModal(ReportId, true, false);
    end;

    // =========================================================
    // PRIVATE HELPERS
    // =========================================================

    /// Ensure Setup exists; seed conservative defaults.
    local procedure EnsureSetup(var Setup: Record "GMO ABC Analysis Setup")
    begin
        if Setup.Get('SETUP') then
            exit;

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

    /// Compute model value per item for date window using Value Entry.
    local procedure CalcItemAmount(Model:Enum "GMO ABC Model"; StartDate: Date; EndDate: Date; ItemNo: Code[20]): Decimal
    var
        VE: Record "Value Entry";
        amt: Decimal;
        s: Decimal;
        c: Decimal;
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
                            amt += s; // returns reduce revenue via negative sales
                        end;
                    Model::"GrossProfit":
                        begin
                            s := VE."Sales Amount (Actual)";
                            c := VE."Cost Amount (Actual)";
                            amt += (s + c); // cost on sales is negative → net profit
                        end;
                    Model::COGS:
                        begin
                            c := VE."Cost Amount (Actual)";
                            if c < 0 then
                                amt += -c; // outbound cost only (absolute)
                        end;
                end;
            until VE.Next() = 0;

        exit(amt);
    end;

    /// Translate cumulative % into A/B/C using model thresholds from Setup.
    local procedure ClassFromCumPercent(Model:Enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup"; CumPct: Decimal): Enum "GMO ABC Class"
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
            Model::"GrossProfit":
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

        if CumPct <= ATh then
            exit(ABC() ::A);
        if CumPct <= BTh then
            exit(ABC() ::B);
        exit(ABC() ::C);
    end;

    /// Local option scope helper (A/B/C).
    local procedure ABC(): Enum "GMO ABC Class"
    begin
        exit(0);
    end;

    /// Set Item/SKU Phys. Invt. Counting Period Code from policy mapping (if configured).
    local procedure MaybeUpdateCountingCode(ItemNo: Code[20]; ClassOpt: Enum "GMO ABC Class"; Model: Enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup")
    var
        Line: Record "GMO ABC Counting Policy Line";
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        PeriodCode: Code[10];
        HeaderCode: Code[10];
    begin
        HeaderCode := Setup."Counting Code Mapping ID";
        if HeaderCode = '' then
            HeaderCode := 'DEFAULT';

        // Ensure header + lines exist to avoid "does not exist" errors
        if not EnsurePolicyExists(HeaderCode) then
            exit;

        if not Line.Get(HeaderCode, Model, ClassOpt) then
            exit;

        PeriodCode := Line."Counting Period Code";
        if PeriodCode = '' then
            exit;

        // Update Item
        if Item.Get(ItemNo) then
            if Item."Phys Invt Counting Period Code" <> PeriodCode then begin
                Item.Validate("Phys Invt Counting Period Code", PeriodCode);
                Item.Modify(true);
            end;


        // Update all SKUs for the item
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

    /// Create policy header (HeaderCode) and default 9 lines (A/B/C × 3 models) if missing.
    procedure EnsurePolicyExists(HeaderCode: Code[10]): Boolean
    var
        H: Record "GMO ABC Counting Policy Header";
    begin
        if HeaderCode = '' then
            exit(false);

        if H.Get(HeaderCode) then
            exit(true);

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

        EnsurePolicyLine(HeaderCode, ModelOpt() ::"GrossProfit", ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"GrossProfit", ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::"GrossProfit", ClassOpt() ::C);

        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::A);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::B);
        EnsurePolicyLine(HeaderCode, ModelOpt() ::COGS, ClassOpt() ::C);
    end;

    local procedure EnsurePolicyLine(HeaderCode: Code[10]; Model:enum "GMO ABC Model"; Class: enum "GMO ABC Class")
    var
        L: Record "GMO ABC Counting Policy Line";
    begin
        if L.Get(HeaderCode, Model, ClassOpt()) then
            exit;

        L.Init();
        L."Header Code" := HeaderCode;
        L.Model := Model;
        L.Class := ClassOpt();
        // "Counting Period Code" left blank by default; admin may fill it
        L.Insert(true);
    end;

    // option scope helpers for policy creation
    local procedure ModelOpt(): Enum "GMO ABC Model"
    begin
        exit(0);
    end;

    local procedure ClassOpt(): Enum "GMO ABC Class"
    begin
        exit(0);
    end;

    /// Calculate S/E from Setup for a given model with an anchor date (usually WorkDate()).
    local procedure CalcDatesFromSetup(Model:Enum "GMO ABC Model"; Setup: Record "GMO ABC Analysis Setup"; AnchorDate: Date; var StartDate: Date; var EndDate: Date)
    var
        DaysBack: Integer;
    begin
        case Model of
            Model::Revenue:
                DaysBack := Setup."Rev Period (Days)";
            Model::"GrossProfit":
                DaysBack := Setup."GP Period (Days)";
            Model::COGS:
                DaysBack := Setup."COGS Period (Days)";
        end;
        if DaysBack <= 0 then
            DaysBack := 365;

        EndDate := AnchorDate;
        StartDate := CalcDate(StrSubstNo('<-%1D>', DaysBack), AnchorDate);
    end;
}
