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
                    ToolTip = 'Specifies the value of the Model field.';
                    Caption = 'ABC Model';
                }
                field(StartDate; this.StartDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the StartDate field.';
                    Caption = 'Start Date';
                }
                field(EndDate; this.EndDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EndDate field.';
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