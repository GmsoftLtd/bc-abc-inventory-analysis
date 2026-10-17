namespace GMSoft.ABCInventoryAnalysis;

page 73033674 "GSO ABC Worksheet"
{
    PageType = Worksheet;
    SourceTable = "GSO ABC Preview Line";
    SourceTableTemporary = true;
    SourceTableView = sorting(Value) order(descending);
    ContextSensitiveHelpPage = 'worksheet';
    Caption = 'ABC Inventory - Worksheet';
    ApplicationArea = All;
    UsageCategory = Tasks;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Parameters)
            {
                Caption = 'Last Calculation';
                Visible = HasLastParams;
                field(LastModelField; LastModel)
                {
                    ApplicationArea = All;
                    Caption = 'Model';
                    Editable = false;
                    ToolTip = 'Specifies the model used for the current preview.';
                }
                field(LastStartDateField; LastStartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'Specifies the first posting date included in the current preview.';
                }
                field(LastEndDateField; LastEndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'Specifies the last posting date included in the current preview.';
                }
            }
            repeater(Lines)
            {
                ShowCaption = false;

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item description.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated value for the selected model and period.';
                }
                field("Value %"; Rec."Value %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the share of this item in the total value.';
                }
                field("Cum. %"; Rec."Cum. %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative share used to decide the class.';
                }
                field(ClassDisplay; GetClassDisplayText())
                {
                    ApplicationArea = All;
                    Caption = 'Class';
                    ToolTip = 'Specifies the ABC class that will be applied to the item.';
                    Style = Strong;
                }
            }
        }
        area(FactBoxes)
        {
            part(StatsPart; "GSO ABC Stats Part")
            {
                ApplicationArea = All;
                Caption = 'Statistics';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Calc)
            {
                Caption = 'Calculate…';
                Image = Calculate;
                ApplicationArea = All;
                ToolTip = 'Build the preview for a model and date range. Nothing is written to items until you choose Apply.';
                trigger OnAction()
                var
                    Mgt: Codeunit "GSO ABC Analysis Mgt.";
                    Model: Enum "GSO ABC Model";
                    StartDate: Date;
                    EndDate: Date;
                begin
                    if not GetParams(Model, StartDate, EndDate) then
                        exit;

                    Mgt.CalculatePreview(Model, StartDate, EndDate, Rec);
                    Rec.SetCurrentKey(Value);
                    Rec.Ascending(false);

                    LastModel := Model;
                    LastStartDate := StartDate;
                    LastEndDate := EndDate;
                    HasLastParams := true;

                    RefreshStats();
                    CurrPage.Update(false);
                    Message(PreviewCalculatedMsg, GetTempCount());
                end;
            }
            action(Apply)
            {
                Caption = 'Apply to Items/SKUs';
                Image = Post;
                ApplicationArea = All;
                ToolTip = 'Write the previewed classes to items and stockkeeping units and record the run in ABC History.';
                trigger OnAction()
                var
                    TempPreviewLine: Record "GSO ABC Preview Line" temporary;
                    Mgt: Codeunit "GSO ABC Analysis Mgt.";
                    Updated: Integer;
                begin
                    if GetTempCount() = 0 then
                        Error(NoLinesErr);
                    if not HasLastParams then
                        Error(NoLinesErr);

                    if not Confirm(ApplyQst, false, Format(LastModel), LastStartDate, LastEndDate) then
                        exit;

                    TempPreviewLine.Copy(Rec, true);
                    Updated := Mgt.ApplyPreview(TempPreviewLine, LastModel, LastStartDate, LastEndDate);
                    Message(AppliedMsg, Updated);
                end;
            }
            action(ExportExcel)
            {
                Caption = 'Export to Excel';
                Image = ExportToExcel;
                ApplicationArea = All;
                ToolTip = 'Export the preview lines and the class statistics to an Excel workbook.';
                trigger OnAction()
                var
                    TempBuf: Record "GSO ABC Preview Line" temporary;
                    TempStats: Record "GSO ABC Stats" temporary;
                    Stats: Codeunit "GSO ABC Worksheet Stats";
                    Export: Codeunit "GSO ABC Worksheet Export";
                begin
                    if GetTempCount() = 0 then
                        Error(NoLinesErr);
                    TempBuf.Copy(Rec, true);
                    Stats.BuildStats(TempBuf, TempStats);
                    TempBuf.Reset();
                    TempBuf.SetCurrentKey(Value);
                    TempBuf.Ascending(false);
                    Export.ExportPreviewAndStats(TempBuf, TempStats);
                end;
            }
            action(OpenSetup)
            {
                Caption = 'Setup';
                Image = Setup;
                ApplicationArea = All;
                ToolTip = 'Open the ABC Analysis Setup to change thresholds and periods.';
                RunObject = page "GSO ABC Analysis Setup";
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(Calc_Promoted; Calc) { }
                actionref(Apply_Promoted; Apply) { }
                actionref(ExportExcel_Promoted; ExportExcel) { }
            }
        }
    }

    var
        HasLastParams: Boolean;
        LastEndDate: Date;
        LastStartDate: Date;
        LastModel: Enum "GSO ABC Model";
        NoLinesErr: Label 'There are no preview lines. Choose Calculate first.';
        PreviewCalculatedMsg: Label 'Preview calculated: %1 lines.', Comment = '%1 = number of lines';
        AppliedMsg: Label 'Classes applied: %1 items updated.', Comment = '%1 = number of items';
        ApplyQst: Label 'Apply the %1 preview (%2 to %3) to items and stockkeeping units?', Comment = '%1 = model, %2 = start date, %3 = end date';

    local procedure GetParams(var ModelParam: Enum "GSO ABC Model"; var StartDate: Date; var EndDate: Date): Boolean
    var
        Dlg: Page "GSO ABC Worksheet Params";
    begin
        if Dlg.RunModal() <> Action::OK then
            exit(false);
        Dlg.GetParams(ModelParam, StartDate, EndDate);
        exit(true);
    end;

    local procedure RefreshStats()
    var
        TempBuf: Record "GSO ABC Preview Line" temporary;
        TempStats: Record "GSO ABC Stats" temporary;
        Stats: Codeunit "GSO ABC Worksheet Stats";
    begin
        TempBuf.Copy(Rec, true);
        Stats.BuildStats(TempBuf, TempStats);
        CurrPage.StatsPart.Page.SetStats(TempStats);
    end;

    local procedure GetTempCount(): Integer
    var
        TempBuf: Record "GSO ABC Preview Line" temporary;
    begin
        TempBuf.Copy(Rec, true);
        TempBuf.Reset();
        exit(TempBuf.Count());
    end;

    local procedure GetClassDisplayText(): Text
    begin
        case Rec.Class of
            Rec.Class::A:
                exit('🟢 A');
            Rec.Class::B:
                exit('🟡 B');
            Rec.Class::C:
                exit('🔴 C');
            Rec.Class::D:
                exit('⚪ D');
        end;
        exit('');
    end;
}
