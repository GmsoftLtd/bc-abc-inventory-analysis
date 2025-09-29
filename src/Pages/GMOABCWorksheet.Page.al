page 73030637 "GMO ABC Worksheet"
{
    PageType = Worksheet;
    SourceTable = "GMO ABC Preview Line";
    SourceTableTemporary = true;
    Caption = 'GMO ABC Worksheet';
    ApplicationArea = All;
    UsageCategory = Tasks;

    SourceTableView = sorting(Value) order(Descending);

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

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Item No."; Rec."Item No.") { ApplicationArea = All; ToolTip = 'Item number.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Item description.'; }
                field(Model; Rec.Model) { ApplicationArea = All; ToolTip = 'ABC model used for this line.'; }
                field(Value; Rec.Value) { ApplicationArea = All; ToolTip = 'Calculated value for the selected model and period.'; }
                field("Value %"; Rec."Value %") { ApplicationArea = All; ToolTip = 'Share of the item value against the total (%).'; }
                field("Cum. %"; Rec."Cum. %") { ApplicationArea = All; ToolTip = 'Cumulative percentage used for class breakpoints.'; }

                // Single visual Class column (emoji + bold)
                field(ClassDisplay; GetClassDisplayText())
                {
                    ApplicationArea = All;
                    Caption = 'Class';
                    ToolTip = 'ABC Class (colored and bold).';
                    Style = Strong;
                    StyleExpr = true;
                }
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
                    Mgt: Codeunit "GMO ABC Analysis Mgt.";
                    EndDate: Date;
                    StartDate: Date;
                    Model: Enum "GMO ABC Model";
                begin
                    if not GetParams(Model, StartDate, EndDate) then
                        exit;

                    Rec.DeleteAll();
                    Mgt.CalculatePreview(Model, StartDate, EndDate, Rec);

                    LastModel := Model;
                    LastStartDate := StartDate;
                    LastEndDate := EndDate;
                    HasLastParams := true;

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
                    Tmp: Record "GMO ABC Preview Line" temporary;
                    Mgt: Codeunit "GMO ABC Analysis Mgt.";
                    EndDate: Date;
                    StartDate: Date;
                    Lines: Integer;
                    Model: Enum "GMO ABC Model";
                begin
                    Lines := GetTempCount();
                    if Lines = 0 then
                        Error('No preview lines. Run Calculate first.');

                    // Reuse last used params; otherwise ask once
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

                    if not Confirm('Apply the %1 preview (%2..%3) to Item/SKU?', false, GetModelText(Model), StartDate, EndDate) then
                        exit;

                    // 🔒 IMPORTANT: Copy page temp buffer to local temp before calling codeunit
                    Tmp.Copy(Rec, true); // ShareTable = true keeps it lightweight, but temp → temp in same session
                    Mgt.ApplyPreview(Tmp, Model, StartDate, EndDate);

                    Message('Applied successfully: %1 items updated.', Lines);
                end;
            }
        }
    }

    var
        HasLastParams: Boolean;
        LastEndDate: Date;
        LastStartDate: Date;
        LastModel: Enum "GMO ABC Model";

    // ===================== Helpers =====================

    local procedure GetParams(var Model: Enum "GMO ABC Model"; var StartDate: Date; var EndDate: Date): Boolean
    var
        Dlg: Page "GMO ABC Worksheet Params";
    begin
        if Dlg.RunModal() = Action::OK then begin
            Dlg.GetParams(Model, StartDate, EndDate);
            exit(true);
        end;
        exit(false);
    end;

    local procedure GetModelText(Model: Enum "GMO ABC Model"): Text
    begin
        case Model of
            Model::Revenue:
                exit('Revenue');
            Model::"Gross Profit":
                exit('Gross Profit');
            Model::COGS:
                exit('COGS');
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

    local procedure GetClassDisplayText(): Text
    begin
        case Rec.Class of
            Rec.Class::A:
                exit('🟢 A');
            Rec.Class::B:
                exit('🟡 B');
            else
                exit('🔴 C');
        end;
    end;
}
