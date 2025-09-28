page 73030637 "GMO ABC Worksheet"
{
    PageType = Worksheet;
    SourceTable = "GMO ABC Preview Line";
    SourceTableTemporary = true;
    Caption = 'GMO ABC Worksheet';
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

                field("Item No."; Rec."Item No.") { ApplicationArea = All; ToolTip = 'Item number.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Item description.'; }
                field(Model; Rec.Model) { ApplicationArea = All; ToolTip = 'ABC model used for this line.'; }
                field(Value; Rec.Value) { ApplicationArea = All; ToolTip = 'Calculated value for the selected model and period.'; }
                field("Value %"; Rec."Value %") { ApplicationArea = All; ToolTip = 'Share of the item value against the total (%).'; }
                field("Cum. %"; Rec."Cum. %") { ApplicationArea = All; ToolTip = 'Cumulative percentage used for class breakpoints.'; }
                field(Class; Rec.Class) { ApplicationArea = All; ToolTip = 'Proposed ABC class.'; }
            }
        }
        area(FactBoxes)
        {
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
                    StatsMgt: Codeunit "GMO Worksheet Stats";
                    StartDate: Date;
                    EndDate: Date;
                    Model: Option Revenue,"Gross Profit",COGS;
                    TempStats: Record "GMO ABC Stats" temporary;
                begin
                    if not GetParams(Model, StartDate, EndDate) then
                        exit;

                    Rec.DeleteAll();
                    Mgt.CalculatePreview(Model, StartDate, EndDate, Rec);

                    // Remember parameters for Apply
                    LastModel := Model;  LastStartDate := StartDate;  LastEndDate := EndDate;  HasLastParams := true;

                    // Build & show stats
                    TempStats.DeleteAll();
                    StatsMgt.BuildStats(Rec, TempStats);
                    CurrPage.Stats.Page.SetStats(TempStats);

                    CurrPage.Update(false);
                    Message('Preview calculated: %1 lines.', GetTempCount());
                end;
            }

            action(Apply)
            {
                Caption = 'Apply to Item/SKU';
                Image = Post;
                ApplicationArea = All;
                ToolTip = 'Write the previewed ABC classes to Items/SKUs.';
                trigger OnAction()
                var
                    Mgt: Codeunit "GMO Analysis Mgt.";
                    Model: Option Revenue,"Gross Profit",COGS;
                    StartDate: Date;
                    EndDate: Date;
                    Lines: Integer;
                begin
                    Lines := GetTempCount();
                    if Lines = 0 then
                        Error('No preview lines. Run Calculate first.');

                    if HasLastParams then begin
                        Model := LastModel;  StartDate := LastStartDate;  EndDate := LastEndDate;
                    end else begin
                        if not GetParams(Model, StartDate, EndDate) then
                            exit;
                        LastModel := Model;  LastStartDate := StartDate;  LastEndDate := EndDate;  HasLastParams := true;
                    end;

                    if not Confirm('Apply the %1 preview (%2..%3) to Item/SKU?', false, GetModelText(Model), StartDate, EndDate) then
                        exit;

                    Mgt.ApplyPreview(Rec, Model, StartDate, EndDate);
                    Message('Applied successfully: %1 items updated.', Lines);
                end;
            }
        }
    }

    var
        LastModel: Option Revenue,"Gross Profit",COGS;
        LastStartDate: Date;
        LastEndDate: Date;
        HasLastParams: Boolean;

  local procedure GetParams(var Model: Option Revenue,"Gross Profit",COGS; var StartDate: Date; var EndDate: Date): Boolean
var
    Dlg: Page "GMO Worksheet Params";
begin
    if Dlg.RunModal() = Action::OK then begin
        Dlg.GetParams(Model, StartDate, EndDate);
        exit(true);
    end;
    exit(false);
end;

    local procedure GetModelText(Model: Option Revenue,"Gross Profit",COGS): Text
    begin
        case Model of
            Model::Revenue:        exit('Revenue');
            Model::"Gross Profit": exit('Gross Profit');
            Model::COGS:           exit('COGS');
        end;
        exit('');
    end;

    local procedure GetTempCount(): Integer
    var
        Buf: Record "GMO ABC Preview Line" temporary;
    begin
        Buf.Copy(Rec, true);
        Buf.Reset();
        exit(Buf.Count());
    end;
}
