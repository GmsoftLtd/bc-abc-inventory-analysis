report 73030579 "GMO ABC Comparison"
{
    Caption = 'ABC Multi-Model Comparison';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GMOABCComparison.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";

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
            column(RevenueClass; Format("GMO Class (Revenue)"))
            {
            }
            column(GrossProfitClass; Format("GMO Class (Gross Profit)"))
            {
            }
            column(COGSClass; Format("GMO Class (COGS)"))
            {
            }
            column(RevenueValue; RevenueValue)
            {
            }
            column(GrossProfitValue; GrossProfitValue)
            {
            }
            column(COGSValue; COGSValue)
            {
            }
            column(ConsistencyIndicator; ConsistencyIndicator)
            {
            }
            column(StartDate; Format(StartDate))
            {
            }
            column(EndDate; Format(EndDate))
            {
            }

            trigger OnAfterGetRecord()
            begin
                RevenueValue := CalculateItemValue(Item."No.", ModelEnum::Revenue, StartDate, EndDate);
                GrossProfitValue := CalculateItemValue(Item."No.", ModelEnum::"Gross Profit", StartDate, EndDate);
                COGSValue := CalculateItemValue(Item."No.", ModelEnum::COGS, StartDate, EndDate);

                ConsistencyIndicator := GetConsistencyIndicator(Item);

                // Skip items with no values
                if (RevenueValue = 0) and (GrossProfitValue = 0) and (COGSValue = 0) then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                if StartDate = 0D then
                    StartDate := CalcDate('<-1Y>', WorkDate());
                if EndDate = 0D then
                    EndDate := WorkDate();
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
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Start date for value calculation.';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'End date for value calculation.';
                    }
                }
            }
        }
    }

    var
        ModelEnum: Enum "GMO ABC Model";
        StartDate: Date;
        EndDate: Date;
        RevenueValue: Decimal;
        GrossProfitValue: Decimal;
        COGSValue: Decimal;
        ConsistencyIndicator: Text[20];
        ReportTitleLbl: Label 'ABC Multi-Model Comparison Report';

    local procedure CalculateItemValue(ItemNo: Code[20]; ModelType: Enum "GMO ABC Model"; FromDate: Date; ToDate: Date): Decimal
    var
        VE: Record "Value Entry";
        Total: Decimal;
    begin
        Total := 0;
        VE.SetRange("Item No.", ItemNo);
        VE.SetRange("Posting Date", FromDate, ToDate);
        if VE.FindSet() then
            repeat
                case ModelType of
                    ModelType::Revenue:
                        Total += VE."Sales Amount (Actual)";
                    ModelType::"Gross Profit":
                        Total += VE."Sales Amount (Actual)" + VE."Cost Amount (Actual)";
                    ModelType::COGS:
                        if VE."Cost Amount (Actual)" < 0 then
                            Total += -VE."Cost Amount (Actual)";
                end;
            until VE.Next() = 0;
        exit(Total);
    end;

    local procedure GetConsistencyIndicator(ItemRec: Record Item): Text[20]
    var
        RevClass: Integer;
        GPClass: Integer;
        COGSClass: Integer;
    begin
        RevClass := ItemRec."GMO Class (Revenue)".AsInteger();
        GPClass := ItemRec."GMO Class (Gross Profit)".AsInteger();
        COGSClass := ItemRec."GMO Class (COGS)".AsInteger();

        if (RevClass = GPClass) and (RevClass = COGSClass) then
            exit('✓ Consistent')
        else
            if (Abs(RevClass - GPClass) <= 1) and (Abs(RevClass - COGSClass) <= 1) then
                exit('≈ Minor Variance')
            else
                exit('⚠ Inconsistent');
    end;
}