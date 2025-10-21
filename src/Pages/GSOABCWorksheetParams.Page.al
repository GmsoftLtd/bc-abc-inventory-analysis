page 73030581 "GSO ABC Worksheet Params"
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
        Model: Enum "GSO ABC Model";

    trigger OnOpenPage()
    var
        Setup: Record "GSO ABC Analysis Setup";
        LookbackDays: Integer;
        DateFormulaLbl: Label '<-%1D>', Locked = true;
    begin
        // Set default dates based on lookback days from setup
        if Setup.Get('SETUP') then begin
            // Get lookback days based on default model (Revenue)
            LookbackDays := Setup."Lookback (Days)";
            if LookbackDays <= 0 then
                LookbackDays := 365;

            EndDate := WorkDate();
            StartDate := CalcDate(StrSubstNo(DateFormulaLbl, LookbackDays), EndDate);
        end else begin
            // Fallback if setup doesn't exist
            EndDate := WorkDate();
            StartDate := CalcDate('<-1Y>', EndDate);
        end;

        // Default to Revenue model
        Model := Model::Revenue;
    end;

    procedure GetParams(var pModel: Enum "GSO ABC Model"; var pStartDate: Date; var pEndDate: Date)
    var
        Setup: Record "GSO ABC Analysis Setup";
        LookbackDays: Integer;
        DateFormulaLbl: Label '<-%1D>', Locked = true;
    begin
        pModel := Model;

        // If dates are not specified (0D), calculate from lookback days
        if (StartDate = 0D) or (EndDate = 0D) then begin
            if Setup.Get('SETUP') then begin
                LookbackDays := Setup."Lookback (Days)";
                if LookbackDays <= 0 then
                    LookbackDays := 365;

                EndDate := WorkDate();
                StartDate := CalcDate(StrSubstNo(DateFormulaLbl, LookbackDays), EndDate);
            end else begin
                EndDate := WorkDate();
                StartDate := CalcDate('<-1Y>', EndDate);
            end;
        end;

        pStartDate := StartDate;
        pEndDate := EndDate;
    end;
}