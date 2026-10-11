page 73033675 "GSO ABC Worksheet Params"
{
    PageType = StandardDialog;
    ContextSensitiveHelpPage = 'worksheet';
    Caption = 'ABC Calculation Parameters';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Model; Model)
                {
                    ApplicationArea = All;
                    Caption = 'ABC Model';
                    ToolTip = 'Specifies the model used to rank items. The dates below default to the period configured for the model in ABC Analysis Setup.';

                    trigger OnValidate()
                    begin
                        SetDefaultDates();
                    end;
                }
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the first posting date included in the analysis.';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the last posting date included in the analysis.';
                }
            }
        }
    }

    var
        Model: Enum "GSO ABC Model";
        StartDate: Date;
        EndDate: Date;
        DateOrderErr: Label 'Start Date must not be after End Date.';

    trigger OnOpenPage()
    begin
        Model := Model::Revenue;
        SetDefaultDates();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction <> Action::OK then
            exit(true);
        if (StartDate = 0D) or (EndDate = 0D) then
            SetDefaultDates();
        if StartDate > EndDate then
            Error(DateOrderErr);
        exit(true);
    end;

    procedure GetParams(var pModel: Enum "GSO ABC Model"; var pStartDate: Date; var pEndDate: Date)
    begin
        pModel := Model;
        pStartDate := StartDate;
        pEndDate := EndDate;
    end;

    local procedure SetDefaultDates()
    var
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
    begin
        Mgt.GetDefaultDates(Model, StartDate, EndDate);
    end;
}
