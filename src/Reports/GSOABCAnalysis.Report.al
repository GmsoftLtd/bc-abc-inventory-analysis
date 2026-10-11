report 73030577 "GSO ABC Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'ABC Inventory Analysis';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOAnalysis.rdl';

    dataset
    {
        dataitem(PreviewABC; "GSO ABC Preview Line")
        {
            UseTemporary = true;
            DataItemTableView = sorting(Value) order(descending);

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(RunDate; Format(CurrentDateTime(), 0, '<Standard Format,9>')) { }
            column(RunByUser; UserId()) { }
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
                Mgt: Codeunit "GSO ABC Analysis Mgt.";
            begin
                Mgt.CalculatePreview(SelectedModel, StartDate, EndDate, PreviewABC);
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
                    field(ModelField; SelectedModel)
                    {
                        ApplicationArea = All;
                        Caption = 'Model';
                        ToolTip = 'Specifies the ABC model used to rank items.';
                    }
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the first posting date included. Leave blank to use the period configured for the model in ABC Analysis Setup.';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the last posting date included. Leave blank to use the work date.';
                    }
                }
            }
        }
    }

    var
        SelectedModel: Enum "GSO ABC Model";
        StartDate: Date;
        EndDate: Date;
        ReportTitleLbl: Label 'ABC Inventory Analysis';

    trigger OnPreReport()
    var
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        DefaultStart: Date;
        DefaultEnd: Date;
    begin
        Mgt.GetDefaultDates(SelectedModel, DefaultStart, DefaultEnd);
        if StartDate = 0D then
            StartDate := DefaultStart;
        if EndDate = 0D then
            EndDate := DefaultEnd;
    end;
}
