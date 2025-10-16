report 73030577 "GMO ABC Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'ABC Inventory - Analysis';
    RDLCLayout = './src/Reports/Layouts/GMOAnalysis.rdl';

    dataset
    {
        dataitem(Previewabc; "GMO ABC Preview Line")
        {
            UseTemporary = true;
            DataItemTableView = sorting(Value) order(Descending);

            column(LineNo; "Line No.") { }
            column(Item_No_; "Item No.") { }
            column(Description; Description) { }
            column(ModelColumn; Model) { }
            column(Value; Value) { }
            column(ValuePct; "Value %") { }
            column(CumPct; "Cum. %") { }
            column(Class; Class) { }

            trigger OnPreDataItem()
            var
                Mgt: Codeunit "GMO ABC Analysis Mgt.";
            begin
                Mgt.CalculatePreview(gModel, gStartDate, gEndDate, PreviewABC);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ModelField; gModel)
                    {
                        ApplicationArea = All;
                        Caption = 'Model';
                        ToolTip = 'Specifies the ABC classification model to use.';
                    }
                    field(StartDateField; gStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the start date for the analysis period. If not specified, the system will calculate it as today minus the lookback days from setup.';
                    }
                    field(EndDateField; gEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the end date for the analysis period. If not specified, the system will use today''s date.';
                    }
                }
                group(Note)
                {
                    Caption = 'Note';
                    InstructionalText = 'If dates are not specified, the system will use today as the end date and calculate the start date by subtracting the lookback days configured in ABC Analysis Setup.';
                }
            }
        }
    }

    var
        gEndDate: Date;
        gStartDate: Date;
        gModel: Enum "GMO ABC Model";

    trigger OnPreReport()
    begin
        // No license check needed
    end;
}
