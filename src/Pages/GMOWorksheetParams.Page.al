page 73030638 "GMO Worksheet Params"
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
                field(Model; Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model field.';
                }
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the StartDate field.';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EndDate field.';
                }
            }
        }
    }

    var
        Model: Enum "GMO ABC Model";
        StartDate: Date;
        EndDate: Date;

    procedure GetParams(var pModel: Enum "GMO ABC Model"; var pStartDate: Date; var pEndDate: Date)
    begin
        pModel := Model;
        pStartDate := StartDate;
        pEndDate := EndDate;
    end;
}