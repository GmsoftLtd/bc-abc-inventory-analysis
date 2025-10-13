page 73030581 "GMO ABC Worksheet Params"
{
    PageType = StandardDialog;
    Caption = 'ABC Calculation Parameters';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Model; this.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the ABC analysis model: Revenue (sales value), Gross Profit (margin), or COGS (cost).';
                    Caption = 'ABC Model';
                }
                field(StartDate; this.StartDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Beginning date of the analysis period. Items will be analyzed based on transactions within this date range.';
                    Caption = 'Start Date';
                }
                field(EndDate; this.EndDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ending date of the analysis period. Typically set to today or end of fiscal period.';
                    Caption = 'Start Date';
                }
               
            }
        }
    }

    var
        EndDate: Date;
        StartDate: Date;
        Model: Enum "GMO ABC Model";

    procedure GetParams(var pModel: Enum "GMO ABC Model"; var pStartDate: Date; var pEndDate: Date)
    begin
        pModel := Model;
        pStartDate := StartDate;
        pEndDate := EndDate;
    end;
}