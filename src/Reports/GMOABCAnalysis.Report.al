report 73030640 "GMO ABC Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'GMO ABC Analysis';

    // Point to the RDLC layout shipped below (add the .rdl file to your project)
    RDLCLayout = 'Layouts/GMO_ABC_Analysis.rdl';

    dataset
    {
        dataitem(Previewabc; "GMO ABC Preview Line")
        {
            UseTemporary = true;
            DataItemTableView = sorting(Value) order(Descending);

            column(LineNo; "Line No.") { }
            column(Item_No_; "Item No.") { }
            column(Description; Description) { }
            column(Model; Model) { }
            column(Value; Value) { }
            column(ValuePct; "Value %") { }
            column(CumPct; "Cum. %") { }
            column(Class; Class) { }

            trigger OnPreDataItem()
            var
                Mgt: Codeunit "GMO ABC Analysis Mgt.";
            begin
                // Build the temp dataset according to the request page parameters
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
                    field(Model; gModel)
                    {
                        ApplicationArea = All;
                        Caption = 'Model';
                        ToolTip = 'Specifies the value of the Model field.';
                    }
                    field(StartDate; gStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the value of the Start Date field.';
                    }
                    field(EndDate; gEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the value of the End Date field.';
                    }
                }
            }
        }
    }

    var
        gModel: Option Revenue,"Gross Profit",COGS;
        gStartDate: Date;
        gEndDate: Date;
}
