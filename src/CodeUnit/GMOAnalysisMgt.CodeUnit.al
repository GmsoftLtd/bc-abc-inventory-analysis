codeunit 73030582 "GMO Analysis Mgt."
{


    // PUBLIC: Preview + Apply for models
    procedure CalculatePreview(Model: Enum "GMO ABC Model"; StartDate: Date; EndDate: Date; var TempPreview: Record "GMO ABC Preview Line" temporary)
    var
        Setup: Record "GMO Analysis Setup";
        Item: Record Item;
        Total: Decimal;
        LineNo: Integer;
        v: Decimal;
    begin
        if not EnsureSetup(Setup) then Error('GMO Analysis Setup not found.');
        ValidateModelThresholds(Model, Setup);

        Item.Reset();
        Item.SetRange(Blocked, false);
        if Setup."Exclude Non-Inventory" then Item.SetRange(Type, Item.Type::Inventory);
        Item.SetRange("GMO Exclude", false);

        Total := 0;
        LineNo := 0;

        if Item.FindSet() then
            repeat

                case Model of
                    Model::Revenue:
                        v := CalcRevenue(Item."No.", StartDate, EndDate);
                    Model::GrossProfit:
                        v := CalcGrossProfit(Item."No.", StartDate, EndDate);
                    Model::COGS:
                        v := CalcCOGS(Item."No.", StartDate, EndDate, Setup."Include Transfers");
                end;
                if v < 0 then v := 0;
                LineNo += 1;
                TempPreview.Init();
                TempPreview."Line No." := LineNo;
                TempPreview."Item No." := Item."No.";
                TempPreview.Description := Item.Description;
                TempPreview.Model := Model;
                TempPreview.Value := Round(v, 0.01);
                TempPreview.Insert();
                Total += v;

            until Item.Next() = 0;

        RankAndClassify(TempPreview, Total, Model, Setup);
    end;

    procedure ApplyPreview(var TempPreview: Record "GMO ABC Preview Line" temporary; Model: Enum "GMO ABC Model"; StartDate: Date; EndDate: Date)
    var
        Setup: Record "GMO Analysis Setup";
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        HistH: Record "GMO ABC History Header";
        HistL: Record "GMO ABC History Line";
        LineNo: Integer;
        Total: Decimal;
        CountItems: Integer;
    begin
        if not EnsureSetup(Setup) then Error('GMO Analysis Setup not found.');

        HistH.Init();
        HistH.Model := Model;
        HistH."Start Date" := StartDate;
        HistH."End Date" := EndDate;
        HistH."Created By" := UserId;
        HistH."Created At" := CurrentDateTime;

        TempPreview.Reset();
        if TempPreview.FindSet() then
            repeat
                Total += TempPreview.Value;
                CountItems += 1;
            until TempPreview.Next() = 0;
        HistH."Total Amount" := Round(Total, 0.01);
        HistH."Items Count" := CountItems;
        HistH.Insert(true);

        TempPreview.Reset();
        if TempPreview.FindSet() then
            repeat
                LineNo += 1;
                HistL.Init();
                HistL."Entry No." := HistH."Entry No.";
                HistL."Line No." := LineNo;
                HistL."Item No." := TempPreview."Item No.";
                HistL.Class := TempPreview.Class;
                HistL.Value := TempPreview.Value;
                HistL."Value %" := TempPreview."Value %";
                HistL."Cum. %" := TempPreview."Cum. %";
                HistL.Insert();

                if Item.Get(TempPreview."Item No.") then begin
                    case Model of
                        Model::Revenue:
                            begin
                                if not Item."GMO Manual Override" then
                                    Item."GMO Class (Revenue)" := TempPreview.Class;
                                Item."GMO Last Calc (Revenue)" := CurrentDateTime;
                            end;
                        Model::GrossProfit:
                            begin
                                if not Item."GMO Manual Override" then
                                    Item."GMO Class (Gross Profit)" := TempPreview.Class;
                                Item."GMO Last Calc (GP)" := CurrentDateTime;
                            end;
                        Model::COGS:
                            begin
                                if not Item."GMO Manual Override" then
                                    Item."GMO Class (COGS)" := TempPreview.Class;
                                Item."GMO Last Calc (COGS)" := CurrentDateTime;
                            end;
                    end;

                    if Setup."Update Counting Codes" then
                        ApplyCountingPeriodCodeToItem(Item, Model, TempPreview.Class, Setup);
                    Item.Modify(true);

                    if Setup."Update SKU" and Setup."Update Counting Codes" then begin
                        SKU.Reset();
                        SKU.SetRange("Item No.", Item."No.");
                        if SKU.FindSet(true) then
                            repeat
                                ApplyCountingPeriodCodeToSKU(SKU, Model, TempPreview.Class, Setup);
                                SKU.Modify(true);
                            until SKU.Next() = 0;
                    end;
                end;
            until TempPreview.Next() = 0;
    end;

    // Batch job compatibility (generic legacy recalculation)
    procedure RecalculateAll(Interactive: Boolean)
    var
        Setup: Record "GMO Analysis Setup";
        Tlm: Codeunit "GMO Telemetry";
        StartDate, EndDate : Date;
        Tmp: Record "GMO ABC Preview Line" temporary;
    begin
        if not EnsureSetup(Setup) then Error('GMO Analysis Setup not found.');
        if not Setup.Enabled then begin
            if Interactive then Message('GMO Analysis is disabled in Setup.');
            exit;
        end;

        // Default to COGS model with default period (common for inventory value focus)
        StartDate := CalcDate(StrSubstNo('<-%1D>', Setup."COGS Period (Days)"), WorkDate());
        EndDate := WorkDate();

        Clear(Tmp);
        DeleteAllTemp(Tmp);
        CalculatePreview("GMO ABC Model"::COGS, StartDate, EndDate, Tmp);
        ApplyPreview(Tmp, "GMO ABC Model"::COGS, StartDate, EndDate);

        Setup."Last Run" := CurrentDateTime;
        Setup.Modify(true);
        Tlm.LogInfo('GMO-RECALC-OK', 'GMO recalculation completed successfully.');
    end;

    // ----- helpers & calculators -----

    local procedure DeleteAllTemp(var Temp: Record "GMO ABC Preview Line" temporary)
    begin
        Temp.Reset();
        Temp.DeleteAll();
    end;

    local procedure RankAndClassify(var TempPreview: Record "GMO ABC Preview Line" temporary; Total: Decimal; Model: Enum "GMO ABC Model"; Setup: Record "GMO Analysis Setup")
    var
        AThr, BThr, Running : Decimal;
    begin
        GetModelThresholds(Model, Setup, AThr, BThr);
        Running := 0;
        TempPreview.Reset();
        TempPreview.SetCurrentKey(Value);
        TempPreview.SetAscending(Value, false);

        if Total = 0 then begin
            if TempPreview.FindSet() then
                repeat
                    TempPreview."Value %" := 0;
                    TempPreview."Cum. %" := 0;
                    if Setup."Zero Consumption as D" then
                        TempPreview.Class := TempPreview.Class::D
                    else
                        TempPreview.Class := TempPreview.Class::C;
                    TempPreview.Modify();
                until TempPreview.Next() = 0;
            exit;
        end;

        if TempPreview.FindSet() then
            repeat
                TempPreview."Value %" := Round(TempPreview.Value / Total * 100, 0.00001);
                Running += TempPreview.Value;
                TempPreview."Cum. %" := Round(Running / Total * 100, 0.00001);

                if TempPreview."Cum. %" <= AThr then
                    TempPreview.Class := TempPreview.Class::A
                else
                    if TempPreview."Cum. %" <= BThr then
                        TempPreview.Class := TempPreview.Class::B
                    else
                        TempPreview.Class := TempPreview.Class::C;

                TempPreview.Modify();
            until TempPreview.Next() = 0;
    end;

    local procedure CalcRevenue(ItemNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
var
    VE: Record "Value Entry";
    Revenue: Decimal;
begin
    Revenue := 0;

    VE.Reset();
    VE.SetRange("Item No.", ItemNo);
    VE.SetRange("Posting Date", StartDate, EndDate);
    VE.SetRange("Item Ledger Entry Type", VE."Item Ledger Entry Type"::Sale);
    VE.SetFilter("Invoiced Quantity", '<>0'); // only invoiced movement

    if VE.FindSet() then
        repeat
            // Include returns as negative to get NET revenue
            Revenue += VE."Sales Amount (Actual)";
        until VE.Next() = 0;

    if Revenue < 0 then
        Revenue := 0; // clamp to zero if net returns exceed sales

    exit(Round(Revenue, 0.01));
end;

   local procedure CalcGrossProfit(ItemNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
var
    VE: Record "Value Entry";
    SalesAmt: Decimal;
    CostAmt: Decimal;
    GP: Decimal;
begin
    SalesAmt := 0;
    CostAmt := 0;

    VE.Reset();
    VE.SetRange("Item No.", ItemNo);
    VE.SetRange("Posting Date", StartDate, EndDate);
    VE.SetRange("Item Ledger Entry Type", VE."Item Ledger Entry Type"::Sale);
    VE.SetFilter("Invoiced Quantity", '<>0');

    if VE.FindSet() then
        repeat
            SalesAmt += VE."Sales Amount (Actual)";   // positive for shipments, negative for returns
            CostAmt  += VE."Cost Amount (Actual)";    // negative for shipments, positive for returns
        until VE.Next() = 0;

    // GP = Sales − COGS; with sign conventions above this is Sales + Cost
    GP := SalesAmt + CostAmt;
    if GP < 0 then
        GP := 0;

    exit(Round(GP, 0.01));
end;
local procedure CalcCOGS(ItemNo: Code[20]; StartDate: Date; EndDate: Date; IncludeTransfers: Boolean): Decimal
var
    VE: Record "Value Entry";
    Cogs: Decimal;
    TypeFilter: Text;
begin
    Cogs := 0;

    VE.Reset();
    VE.SetRange("Item No.", ItemNo);
    VE.SetRange("Posting Date", StartDate, EndDate);

    if IncludeTransfers then
        TypeFilter := StrSubstNo('%1|%2|%3|%4|%5',
            Format(VE."Item Ledger Entry Type"::Sale),
            Format(VE."Item Ledger Entry Type"::"Negative Adjmt."),
            Format(VE."Item Ledger Entry Type"::Consumption),
            Format(VE."Item Ledger Entry Type"::"Assembly Consumption"),
            Format(VE."Item Ledger Entry Type"::Transfer))
    else
        TypeFilter := StrSubstNo('%1|%2|%3|%4',
            Format(VE."Item Ledger Entry Type"::Sale),
            Format(VE."Item Ledger Entry Type"::"Negative Adjmt."),
            Format(VE."Item Ledger Entry Type"::Consumption),
            Format(VE."Item Ledger Entry Type"::"Assembly Consumption"));

    VE.SetFilter("Item Ledger Entry Type", TypeFilter);
    VE.SetFilter("Cost Amount (Actual)", '<0'); // only outbound costs

    if VE.FindSet() then
        repeat
            // Outbound cost is negative; flip sign to get positive COGS value
            Cogs += -VE."Cost Amount (Actual)";
        until VE.Next() = 0;

    exit(Round(Cogs, 0.01));
end;

    local procedure GetModelThresholds(Model: Enum "GMO ABC Model"; Setup: Record "GMO Analysis Setup"; var AThr: Decimal; var BThr: Decimal)
    begin
        case Model of
            Model::Revenue:
                begin
                    AThr := Setup."Rev A %";
                    BThr := Setup."Rev B %";
                end;
            Model::GrossProfit:
                begin
                    AThr := Setup."GP A %";
                    BThr := Setup."GP B %";
                end;
            Model::COGS:
                begin
                    AThr := Setup."COGS A %";
                    BThr := Setup."COGS B %";
                end;
        end;
    end;

    local procedure ValidateModelThresholds(Model: Enum "GMO ABC Model"; Setup: Record "GMO Analysis Setup")
    var
        AThr, BThr : Decimal;
    begin
        GetModelThresholds(Model, Setup, AThr, BThr);
        if AThr <= 0 then Error('A Threshold %% must be greater than 0.');
        if BThr <= AThr then Error('B Threshold %% must be greater than A Threshold %%.');
        if BThr > 100 then Error('B Threshold %% cannot exceed 100.');
    end;

    local procedure ApplyCountingPeriodCodeToItem(var Item: Record Item; Model: Enum "GMO ABC Model"; Class: Enum "GMO Class"; Setup: Record "GMO Analysis Setup")
    var
        Line: Record "GMO Counting Policy Line";
    begin
        if Setup."Counting Code Mapping ID" = '' then exit;
        if not Line.Get(Setup."Counting Code Mapping ID", Model, Class) then exit;
        if Line."Item Period Code" <> '' then
            Item.Validate("Phys Invt Counting Period Code", Line."Item Period Code");
    end;

    local procedure ApplyCountingPeriodCodeToSKU(var SKU: Record "Stockkeeping Unit"; Model: Enum "GMO ABC Model"; Class: Enum "GMO Class"; Setup: Record "GMO Analysis Setup")
    var
        Line: Record "GMO Counting Policy Line";
    begin
        if Setup."Counting Code Mapping ID" = '' then exit;
        if not Line.Get(Setup."Counting Code Mapping ID", Model, Class) then exit;
        if Line."SKU Period Code" <> '' then
            SKU.Validate("Phys Invt Counting Period Code", Line."SKU Period Code");
    end;

    local procedure MaybeUpdateCountingCode(ItemNo: Code[20]; ClassOpt: Option A,B,C; ModelOpt: Option Revenue,"Gross Profit",COGS)
var
    Setup: Record "GMO Analysis Setup";
    Line: Record "GMO Counting Policy Line";
    Item: Record Item;
    SKU: Record "Stockkeeping Unit";
begin
    if not Setup.Get('SETUP') then
        exit;
    if Setup."Counting Code Mapping ID" = '' then
        exit; // mapping not configured → do nothing

    // Find the mapping line for this Model/Class
    if not Line.Get(Setup."Counting Code Mapping ID", ModelOpt, ClassOpt) then
        exit;
    if Line."Period Code" = '' then
        exit; // admin intentionally left blank

    // Update Item
    if Item.Get(ItemNo) then 
      if Item."Phys Invt Counting Period Code" <> Line."Period Code" then begin
            Item.Validate("Phys Invt Counting Period Code", Line."Period Code");
            Item.Modify(true);
        end;


    // Update SKUs for this item (if any)
    SKU.Reset();
    SKU.SetRange("Item No.", ItemNo);
    if SKU.FindSet(true) then
        repeat
            if SKU."Phys Invt Counting Period Code" <> Line."Period Code" then begin
                SKU.Validate("Phys Invt Counting Period Code", Line."Period Code");
                SKU.Modify(true);
            end;
        until SKU.Next() = 0;
end;

    local procedure EnsureSetup(var Setup: Record "GMO Analysis Setup"): Boolean
    begin
        exit(Setup.Get('SETUP'));
    end;
}