report 73030580 "GMO ABC Detail by Class"
{
    Caption = 'ABC Detail by Class Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GMOABCDetailByClass.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";
            DataItemTableView = sorting("No.");

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(Model; Format(Model))
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(StartDate; Format(StartDate))
            {
            }
            column(EndDate; Format(EndDate))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(ABCClass; Format(ABCClass))
            {
            }
            column(ItemValue; ItemValue)
            {
            }
            column(ValuePercent; ValuePercent)
            {
            }
            column(CumulativePercent; CumulativePercent)
            {
            }
            column(LastCalculated; Format(LastCalculated))
            {
            }
            column(ClassFilter; ClassFilterText)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ABCClass := GetItemClass(Item, Model);

                if ClassFilter <> ClassFilter::Unknown then
                    if ABCClass <> ClassFilter then
                        CurrReport.Skip();

                ItemValue := CalculateItemValue(Item."No.", Model, StartDate, EndDate);

                if ItemValue = 0 then
                    CurrReport.Skip();

                TotalValue += ItemValue;
            end;

            trigger OnPreDataItem()
            begin
                if StartDate = 0D then
                    StartDate := CalcDate('<-1Y>', WorkDate());
                if EndDate = 0D then
                    EndDate := WorkDate();

                TotalValue := 0;
            end;

            trigger OnPostDataItem()
            var
                TempItem: Record Item;
            begin
                // Second pass to calculate percentages
                TempItem.CopyFilters(Item);
                CumulativeValue := 0;

                if TempItem.FindSet() then
                    repeat
                        ABCClass := GetItemClass(TempItem, Model);
                        if ClassFilter <> ClassFilter::Unknown then
                            if ABCClass <> ClassFilter then
                                continue;

                        ItemValue := CalculateItemValue(TempItem."No.", Model, StartDate, EndDate);
                        if ItemValue > 0 then begin
                            if TotalValue <> 0 then begin
                                ValuePercent := (ItemValue / TotalValue) * 100;
                                CumulativeValue += ItemValue;
                                CumulativePercent := (CumulativeValue / TotalValue) * 100;
                            end;
                        end;
                    until TempItem.Next() = 0;
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
                    field(Model; Model)
                    {
                        ApplicationArea = All;
                        Caption = 'ABC Model';
                        ToolTip = 'Select the ABC model to analyze.';
                    }
                    field(ClassFilter; ClassFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Class Filter';
                        ToolTip = 'Filter by specific ABC class (leave blank for all).';
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Start date for value calculation.';
                    }
                    field(EndDate; EndDate)
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
        Model: Enum "GMO ABC Model";
        ClassFilter: Enum "GMO ABC Class";
        StartDate: Date;
        EndDate: Date;
        ABCClass: Enum "GMO ABC Class";
        ItemValue: Decimal;
        ValuePercent: Decimal;
        CumulativePercent: Decimal;
        TotalValue: Decimal;
        CumulativeValue: Decimal;
        LastCalculated: DateTime;
        ClassFilterText: Text[20];
        ReportTitleLbl: Label 'ABC Detail by Class Report';

    local procedure GetItemClass(ItemRec: Record Item; ModelType: Enum "GMO ABC Model"): Enum "GMO ABC Class"
    begin
        case ModelType of
            ModelType::Revenue:
                exit(ItemRec."GMO Class (Revenue)");
            ModelType::"Gross Profit":
                exit(ItemRec."GMO Class (Gross Profit)");
            ModelType::COGS:
                exit(ItemRec."GMO Class (COGS)");
        end;
    end;

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

    trigger OnPreReport()
    begin
        if ClassFilter = ClassFilter::Unknown then
            ClassFilterText := 'All'
        else
            ClassFilterText := Format(ClassFilter);
    end;
}