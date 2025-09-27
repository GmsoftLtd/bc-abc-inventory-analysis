page 73030637 "GMO ABC Worksheet"
{
    PageType = Worksheet;
    SourceTable = "GMO ABC Preview Line";
    SourceTableTemporary = true;
    Caption = 'ABC Worksheet';
    ApplicationArea = All;
    UsageCategory = Tasks;

    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                ShowCaption = false;

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Item description.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC model used for this line.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Calculated value for the selected model and period.';
                }
                field("Value %"; Rec."Value %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Share of the item value against the total (%).';
                }
                field("Cum. %"; Rec."Cum. %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cumulative percentage used for class breakpoints.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'Proposed ABC class.';
                }
            }
        }
        area(factboxes)
        {
            part(Charts; "GMO ABC Charts FactBox")
            {
                ApplicationArea = All;
                Caption = 'Charts';
            }
            part(Stats; "GMO ABC Stats Part")
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
                ToolTip = 'Build the preview worksheet for a selected model and date range.';

                trigger OnAction()
                var
                    Mgt: Codeunit "GMO Analysis Mgt.";
                    StartDate: Date;
                    EndDate: Date;
                    Model: Enum "GMO ABC Model";
                    Lines: Integer;
                begin
                    if not GetParams(Model, StartDate, EndDate) then
                        exit;

                    // Clear ONLY the temp buffer
                    Rec.DeleteAll();

                    // Fill preview lines
                    Mgt.CalculatePreview(Model, StartDate, EndDate, Rec);

                    // Remember parameters for Apply
                    LastModel := Model;
                    LastStartDate := StartDate;
                    LastEndDate := EndDate;
                    HasLastParams := true;

                    // Refresh visuals
                    UpdateChartsAndStats();
                    CurrPage.Update(false);

                    Lines := GetTempCount();
                    Message('Preview calculated: %1 lines.', Lines);
                end;
            }

            action(ExportExcel)
            {
                Caption = 'Export to Excel';
                Image = Export;
                ApplicationArea = All;
                ToolTip = 'Export the current preview lines (and optional statistics) to Microsoft Excel.';

                trigger OnAction()
                var
                    Helper: Codeunit "GMO Worksheet Export";
                begin
                    if GetTempCount() = 0 then
                        Error('No preview lines to export. Run Calculate first.');

                    Helper.ExportPreviewAndStats(Rec);
                end;
            }

            action(Apply)
            {
                Caption = 'Apply to Item/SKU';
                Image = Post;
                ApplicationArea = All;
                ToolTip = 'Writes the previewed ABC classes to Items/SKUs and logs the run to history.';

                trigger OnAction()
                var
                    Mgt: Codeunit "GMO Analysis Mgt.";
                    Model: Enum "GMO ABC Model";
                    StartDate: Date;
                    EndDate: Date;
                    Lines: Integer;
                begin
                    Lines := GetTempCount();
                    if Lines = 0 then
                        Error('No preview lines. Run Calculate first.');

                    // Use last parameters from Calculate; if not available, ask once
                    if HasLastParams then begin
                        Model := LastModel;
                        StartDate := LastStartDate;
                        EndDate := LastEndDate;
                    end else begin
                        if not GetParams(Model, StartDate, EndDate) then
                            exit;
                        LastModel := Model;
                        LastStartDate := StartDate;
                        LastEndDate := EndDate;
                        HasLastParams := true;
                    end;

                    if not Confirm('Apply the %1 preview (%2..%3) to Item/SKU and write history?', false, Format(Model), StartDate, EndDate) then
                        exit;

                    // Apply directly from the current temp buffer
                    Mgt.ApplyPreview(Rec, Model, StartDate, EndDate);

                    Message('Applied successfully: %1 items updated.', Lines);
                end;
            }
        }
    }

    var
        // Temp statistics buffer used to feed the Stats part
        TempStats: Record "GMO ABC Stats" temporary;

        // Last-used parameters to keep Apply consistent with Calculate
        LastModel: Enum "GMO ABC Model";
        LastStartDate: Date;
        LastEndDate: Date;
        HasLastParams: Boolean;

    // ===================== Helpers =====================

  local procedure GetParams(var Model: Enum "GMO ABC Model"; var StartDate: Date; var EndDate: Date): Boolean
var
    Dlg: Page "GMO Worksheet Params";
begin
    if Dlg.RunModal() = Action::OK then begin
        Dlg.GetParams(Model, StartDate, EndDate);
        exit(true);
    end;
    exit(false);
end;

local procedure UpdateChartsAndStats()
var
    ChartBuf: Record "Business Chart Buffer" temporary;

    StatsMgt: Codeunit "GMO Worksheet Stats";
begin
    // Build buffer and push to FactBox
  //  ChartsMgt.BuildChartBuffer(Rec, ChartBuf);
    CurrPage.Charts.Page.LoadChart(ChartBuf);     // initial bind
    CurrPage.Charts.Page.RefreshChart(ChartBuf);  // ensure refresh after recalculation

    // Stats (unchanged)
    TempStats.DeleteAll();
    StatsMgt.BuildStats(Rec, TempStats);
    CurrPage.Stats.Page.SetStats(TempStats);
end;

local procedure GetTempCount(): Integer
var
    Buf: Record "GMO ABC Preview Line" temporary;
begin
    // Count without disturbing page filters/state
    Buf.Copy(Rec, true);
    Buf.Reset();
    exit(Buf.Count());
end;
}