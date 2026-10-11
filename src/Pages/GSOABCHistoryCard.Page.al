page 73030585 "GSO ABC History Card"
{
    Caption = 'ABC History';
    PageType = Card;
    SourceTable = "GSO ABC History Header";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique sequential number for this historical ABC analysis run.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the ABC model used for this run.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Beginning date of the period analyzed in this ABC calculation.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Ending date of the period analyzed in this ABC calculation.';
                }
                field("Items Count"; Rec."Items Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total number of items included in this ABC analysis run.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total model value of all items analyzed in this run.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'User who initiated this ABC analysis calculation.';
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when this ABC analysis was executed.';
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics (from lines)';
                field(AmtA; AmtA)
                {
                    Caption = 'A Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total value of all items classified as Class A in this analysis run.';
                }
                field(AmtB; AmtB)
                {
                    Caption = 'B Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total value of all items classified as Class B in this analysis run.';
                }
                field(AmtC; AmtC)
                {
                    Caption = 'C Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total value of all items classified as Class C in this analysis run.';
                }
                field(CntA; CntA)
                {
                    Caption = 'A Count';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Number of items classified as Class A (high value items) in this analysis run.';
                }
                field(CntB; CntB)
                {
                    Caption = 'B Count';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Number of items classified as Class B (medium value items) in this analysis run.';
                }
                field(CntC; CntC)
                {
                    Caption = 'C Count';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Number of items classified as Class C (lower value items) in this analysis run.';
                }
                field(ShareA; ShareA)
                {
                    Caption = 'A % of Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Percentage of total value contributed by Class A items. Typically around 80% per Pareto principle.';
                }
                field(ShareB; ShareB)
                {
                    Caption = 'B % of Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Percentage of total value contributed by Class B items. Typically around 15%.';
                }
                field(ShareC; ShareC)
                {
                    Caption = 'C % of Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Percentage of total value contributed by Class C items. Typically around 5%.';
                }
            }
            part(Lines; "GSO ABC History Lines")
            {
                SubPageLink = "Entry No." = field("Entry No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportToExcel)
            {
                Caption = 'Export Lines to Excel';
                Image = ExportToExcel;
                ApplicationArea = All;
                ToolTip = 'Export the history lines to Excel.';
                trigger OnAction()
                var
                    HistLine: Record "GSO ABC History Line";
                    TempExcelBuffer: Record "Excel Buffer" temporary;
                    SheetName: Text[250];
                begin
                    HistLine.SetRange("Entry No.", Rec."Entry No.");
                    if HistLine.IsEmpty() then
                        Error(NoLinesErr);

                    TempExcelBuffer.DeleteAll();
                    SheetName := CopyStr(StrSubstNo(SheetNameFormatLbl, Rec."Entry No."), 1, 31);

                    // Header row
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn('Line No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Item No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Class', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Value', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Value %', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Cum. %', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

                    // Data rows
                    if HistLine.FindSet() then
                        repeat
                            TempExcelBuffer.NewRow();
                            TempExcelBuffer.AddColumn(HistLine."Line No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(HistLine."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(Format(HistLine.Class), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(HistLine.Value, false, '', false, false, false, '#,##0.00', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(HistLine."Value %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(HistLine."Cum. %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
                        until HistLine.Next() = 0;

                    TempExcelBuffer.CreateNewBook(SheetName);
                    TempExcelBuffer.WriteSheet(SheetName, CompanyName(), UserId());
                    TempExcelBuffer.CloseBook();
                    TempExcelBuffer.OpenExcel();
                end;
            }
        }
    }

    var
        AmtA, AmtB, AmtC : Decimal;
        ShareA, ShareB, ShareC : Decimal;
        CntA, CntB, CntC : Integer;
        SheetNameFormatLbl: Label 'ABC History %1', Comment = '%1 = Entry No.';
        NoLinesErr: Label 'There are no lines to export.';

    trigger OnAfterGetRecord()
    var
        L: Record "GSO ABC History Line";
        TotAmt: Decimal;
    begin
        Clear(AmtA);
        Clear(AmtB);
        Clear(AmtC);
        Clear(CntA);
        Clear(CntB);
        Clear(CntC);
        Clear(ShareA);
        Clear(ShareB);
        Clear(ShareC);

        L.SetRange("Entry No.", Rec."Entry No.");
        if L.FindSet() then
            repeat
                case L.Class of
                    L.Class::A:
                        begin
                            AmtA += L.Value;
                            CntA += 1;
                        end;
                    L.Class::B:
                        begin
                            AmtB += L.Value;
                            CntB += 1;
                        end;
                    else begin
                        AmtC += L.Value;
                        CntC += 1;
                    end;
                end;
                TotAmt += L.Value;
            until L.Next() = 0;

        if TotAmt > 0 then begin
            ShareA := Round(AmtA / TotAmt * 100, 0.00001);
            ShareB := Round(AmtB / TotAmt * 100, 0.00001);
            ShareC := Round(AmtC / TotAmt * 100, 0.00001);
        end;
    end;
}