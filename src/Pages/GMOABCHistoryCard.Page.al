page 73030585 "GMO ABC History Card"
{
    Caption = 'ABC History';
    PageType = Card;
    SourceTable = "GMO ABC History Header";
    ApplicationArea = All;

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
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Model field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Items Count"; Rec."Items Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Items Count field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created At field.';
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
                    ToolTip = 'Specifies the value of the A Amount field.';
                }
                field(AmtB; AmtB)
                {
                    Caption = 'B Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the B Amount field.';
                }
                field(AmtC; AmtC)
                {
                    Caption = 'C Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the C Amount field.';
                }
                field(CntA; CntA)
                {
                    Caption = 'A Count';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the A Count field.';
                }
                field(CntB; CntB)
                {
                    Caption = 'B Count';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the B Count field.';
                }
                field(CntC; CntC)
                {
                    Caption = 'C Count';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the C Count field.';
                }
                field(ShareA; ShareA)
                {
                    Caption = 'A % of Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the A % of Amount field.';
                }
                field(ShareB; ShareB)
                {
                    Caption = 'B % of Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the B % of Amount field.';
                }
                field(ShareC; ShareC)
                {
                    Caption = 'C % of Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the C % of Amount field.';
                }
            }
            part(Lines; "GMO ABC History Lines")
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
                    HistLine: Record "GMO ABC History Line";
                    TempExcelBuffer: Record "Excel Buffer" temporary;
                    SheetName: Text[250];
                begin
                    HistLine.SetRange("Entry No.", Rec."Entry No.");
                    if HistLine.IsEmpty() then
                        Error('No lines to export.');

                    TempExcelBuffer.DeleteAll();
                    SheetName := CopyStr(StrSubstNo('ABC %1 %2', Rec.Model, Rec."Entry No."), 1, 250);

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
                    TempExcelBuffer.WriteSheet(SheetName, '', '');
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

    trigger OnAfterGetRecord()
    var
        L: Record "GMO ABC History Line";
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