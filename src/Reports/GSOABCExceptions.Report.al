report 73030578 "GSO ABC Exceptions"
{
    Caption = 'ABC Exception Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOABCExceptions.rdl';
    InherentPermissions = X;
    InherentEntitlements = X;

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
            column(RunDate; Format(CurrentDateTime, 0, '<Standard Format,9>'))
            {
            }
            column(RunByUser; UserId)
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
            column(RevenueClass; Format("GSO Class (Revenue)"))
            {
            }
            column(GPClass; Format("GSO Class (Gross Profit)"))
            {
            }
            column(COGSClass; Format("GSO Class (COGS)"))
            {
            }
            column(SalesQtyClass; Format("GSO Class (Sales Qty)"))
            {
            }
            column(UsageValueClass; Format("GSO Class (Usage Value)"))
            {
            }
            column(LastCalcRev; Format("GSO Last Calc (Revenue)"))
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
                else
                    if IsOutdated(Item) then begin
                        ExceptionType := 'Outdated';
                        ExceptionDetails := StrSubstNo(OutdatedDetailsLbl, DaysThreshold);
                    end
                    // Exception 3: Inconsistent classes across models
                    else
                        if HasInconsistentClasses(Item) then begin
                            ExceptionType := 'Inconsistent';
                            ExceptionDetails := 'Different classes across models';
                        end
                        // Exception 4: High inventory but low class
                        else
                            if IsHighInventoryLowClass(Item) then begin
                                ExceptionType := 'Inventory Mismatch';
                                ExceptionDetails := 'High inventory value but Class C';
                            end
                            // Exception 5: Zero activity
                            else
                                if HasZeroActivity(Item) then begin
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
                    field(DaysThresholdField; DaysThreshold)
                    {
                        ApplicationArea = All;
                        Caption = 'Outdated Threshold (Days)';
                        ToolTip = 'Number of days after which calculation is considered outdated. Default: 90 days.';
                    }
                    field(InventoryThresholdField; InventoryThreshold)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Value Threshold';
                        ToolTip = 'Minimum inventory value to flag as high inventory. Default: 10000.';
                    }
                }
                group(Note)
                {
                    Caption = 'Note';
                    InstructionalText = 'This report identifies items with potential ABC classification issues: never calculated, outdated calculations, inconsistent classes across models, high inventory with low class, or zero activity.';
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
        OutdatedDetailsLbl: Label 'Last calculation more than %1 days ago', Locked = true;

    local procedure IsNeverCalculated(ItemRec: Record Item): Boolean
    begin
        exit((ItemRec."GSO Last Calc (Revenue)" = 0DT) and
             (ItemRec."GSO Last Calc (GP)" = 0DT) and
             (ItemRec."GSO Last Calc (COGS)" = 0DT) and
             (ItemRec."GSO Last Calc (Sales Qty)" = 0DT) and
             (ItemRec."GSO Last Calc (Usage Value)" = 0DT) and
             (ItemRec."GSO Last Calc (GMROII)" = 0DT) and
             (ItemRec."GSO Last Calc (Pick Freq)" = 0DT));
    end;

    local procedure IsOutdated(ItemRec: Record Item): Boolean
    var
        LatestCalc: DateTime;
        DaysSinceCalc: Integer;
        MillisecondsPerDay: BigInteger;
        TimeDifference: BigInteger;
    begin
        LatestCalc := ItemRec."GSO Last Calc (Revenue)";
        if ItemRec."GSO Last Calc (GP)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (GP)";
        if ItemRec."GSO Last Calc (COGS)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (COGS)";
        if ItemRec."GSO Last Calc (Sales Qty)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (Sales Qty)";
        if ItemRec."GSO Last Calc (Usage Value)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (Usage Value)";
        if ItemRec."GSO Last Calc (GMROII)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (GMROII)";
        if ItemRec."GSO Last Calc (Pick Freq)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (Pick Freq)";

        if LatestCalc = 0DT then
            exit(false);

        // Calculate days difference to avoid overflow
        // DateTime difference is in milliseconds: 1 day = 86,400,000 milliseconds
        MillisecondsPerDay := 86400000;
        TimeDifference := CurrentDateTime - LatestCalc;
        DaysSinceCalc := TimeDifference div MillisecondsPerDay;

        exit(DaysSinceCalc > DaysThreshold);
    end;

    local procedure HasInconsistentClasses(ItemRec: Record Item): Boolean
    var
        Classes: array[7] of Integer;
    begin
        Classes[1] := ItemRec."GSO Class (Revenue)".AsInteger();
        Classes[2] := ItemRec."GSO Class (Gross Profit)".AsInteger();
        Classes[3] := ItemRec."GSO Class (COGS)".AsInteger();
        Classes[4] := ItemRec."GSO Class (Sales Qty)".AsInteger();
        Classes[5] := ItemRec."GSO Class (Usage Value)".AsInteger();
        Classes[6] := ItemRec."GSO Class (GMROII)".AsInteger();
        Classes[7] := ItemRec."GSO Class (Pick Frequency)".AsInteger();

        exit((Classes[1] <> Classes[2]) or (Classes[1] <> Classes[3]) or (Classes[1] <> Classes[4]) or
             (Classes[1] <> Classes[5]) or (Classes[1] <> Classes[6]) or (Classes[1] <> Classes[7]));
    end;

    local procedure IsHighInventoryLowClass(ItemRec: Record Item): Boolean
    var
        InventoryValue: Decimal;
    begin
        ItemRec.CalcFields(Inventory);
        InventoryValue := ItemRec.Inventory * ItemRec."Unit Cost";

        exit((InventoryValue > InventoryThreshold) and
             (ItemRec."GSO Class (Revenue)" = ItemRec."GSO Class (Revenue)"::C));
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