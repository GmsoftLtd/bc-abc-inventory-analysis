namespace GMSoft.ABCInventoryAnalysis;

page 73033677 "GSO ABC History"
{
    ContextSensitiveHelpPage = 'history';
    Caption = 'ABC History';
    PageType = List;
    SourceTable = "GSO ABC History Header";
    ApplicationArea = All;
    UsageCategory = History;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Headers)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique sequential number for this historical ABC analysis run.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ABC model used for this run.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Beginning date of the period analyzed in this ABC calculation.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ending date of the period analyzed in this ABC calculation.';
                }
                field("Items Count"; Rec."Items Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of items included in this run.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total model value of all items analyzed in this run.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who initiated this ABC analysis calculation.';
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when this ABC analysis was executed.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenCard)
            {
                Caption = 'Open';
                Image = View;
                ApplicationArea = All;
                ToolTip = 'Open the detailed card view for this historical ABC analysis run to view item-level classifications and statistics.';
                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"GSO ABC History Card", Rec);
                end;
            }
        }
    }
}