report 73030578 "GMO ABC Exceptions"
{
    Caption = 'ABC Exception Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GMOABCExceptions.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code";

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(ExceptionType; ExceptionType)
            {
            }
            column(ExceptionDetails; ExceptionDetails)
            {
            }
            column(RevenueClass; Format("GMO Class (Revenue)"))
            {
            }
            column(GPClass; Format("GMO Class (Gross Profit)"))
            {
            }
            column(COGSClass; Format("GMO Class (COGS)"))
            {
            }
            column(LastCalcRev; Format("GMO Last Calc (Revenue)"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                ExceptionType := '';
                ExceptionDetails := '';

                // Exception 1: Never calculated
                if IsNeverCalculated(Item) then begin
                    ExceptionType := 'Never Calculated';
                    ExceptionDetails := 'Item has never been classified';
                end
                // Exception 2: Outdated calculation (>90 days)
                else if IsOutdated(Item) then begin
                    ExceptionType := 'Outdated';
                    ExceptionDetails := StrSubstNo('Last calculation more than %1 days ago', DaysThreshold);
                end
                // Exception 3: Inconsistent classes across models
                else if HasInconsistentClasses(Item) then begin
                    ExceptionType := 'Inconsistent';
                    ExceptionDetails := 'Different classes across models';
                end
                // Exception 4: High inventory but low class
                else if IsHighInventoryLowClass(Item) then begin
                    ExceptionType := 'Inventory Mismatch';
                    ExceptionDetails := 'High inventory value but Class C';
                end
                // Exception 5: Zero activity
                else if HasZeroActivity(Item) then begin
                    ExceptionType := 'No Activity';
                    ExceptionDetails := 'No sales/movement in analysis period';
                end else
                    CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DaysThreshold; DaysThreshold)
                    {
                        ApplicationArea = All;
                        Caption = 'Outdated Threshold (Days)';
                        ToolTip = 'Number of days after which calculation is considered outdated.';
                    }
                    field(InventoryThreshold; InventoryThreshold)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Value Threshold';
                        ToolTip = 'Minimum inventory value to flag as high inventory.';
                    }
                }
            }
        }
    }

    var
        DaysThreshold: Integer;
        InventoryThreshold: Decimal;
        ExceptionType: Text[50];
        ExceptionDetails: Text[250];
        ReportTitleLbl: Label 'ABC Exception Report';

    local procedure IsNeverCalculated(ItemRec: Record Item): Boolean
    begin
        exit((ItemRec."GMO Last Calc (Revenue)" = 0DT) and
             (ItemRec."GMO Last Calc (GP)" = 0DT) and
             (ItemRec."GMO Last Calc (COGS)" = 0DT));
    end;

    local procedure IsOutdated(ItemRec: Record Item): Boolean
    var
        LatestCalc: DateTime;
    begin
        LatestCalc := ItemRec."GMO Last Calc (Revenue)";
        if ItemRec."GMO Last Calc (GP)" > LatestCalc then
            LatestCalc := ItemRec."GMO Last Calc (GP)";
        if ItemRec."GMO Last Calc (COGS)" > LatestCalc then
            LatestCalc := ItemRec."GMO Last Calc (COGS)";

        if LatestCalc = 0DT then
            exit(false);

        exit(CurrentDateTime - LatestCalc > DaysThreshold * 86400000);
    end;

    local procedure HasInconsistentClasses(ItemRec: Record Item): Boolean
    var
        Classes: array[3] of Integer;
    begin
        Classes[1] := ItemRec."GMO Class (Revenue)".AsInteger();
        Classes[2] := ItemRec."GMO Class (Gross Profit)".AsInteger();
        Classes[3] := ItemRec."GMO Class (COGS)".AsInteger();

        exit((Classes[1] <> Classes[2]) or (Classes[1] <> Classes[3]));
    end;

    local procedure IsHighInventoryLowClass(ItemRec: Record Item): Boolean
    var
        InventoryValue: Decimal;
    begin
        ItemRec.CalcFields(Inventory);
        InventoryValue := ItemRec.Inventory * ItemRec."Unit Cost";

        exit((InventoryValue > InventoryThreshold) and
             (ItemRec."GMO Class (Revenue)" = ItemRec."GMO Class (Revenue)"::C));
    end;

    local procedure HasZeroActivity(ItemRec: Record Item): Boolean
    var
        VE: Record "Value Entry";
    begin
        VE.SetRange("Item No.", ItemRec."No.");
        VE.SetFilter("Posting Date", '%1..%2', CalcDate('<-1Y>', WorkDate()), WorkDate());
        exit(VE.IsEmpty());
    end;

    trigger OnPreReport()
    begin
        if DaysThreshold = 0 then
            DaysThreshold := 90;
        if InventoryThreshold = 0 then
            InventoryThreshold := 10000;
    end;
}