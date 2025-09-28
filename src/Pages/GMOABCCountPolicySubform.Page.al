page 73030595 "GMO ABC Count Policy Subform"
{
    Caption = 'ABC Counting Policy Lines';
    PageType = ListPart;
    SourceTable = "GMO ABC Counting Policy Line";
    ApplicationArea = All;

    // These two properties make child inserts smooth in subpages
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC model: Revenue, Gross Profit, or COGS.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC Class A/B/C.';
                }
                field("Counting Period Code"; Rec."Counting Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Warehouse Physical Inventory Counting Period Code to assign for this (Model, Class).';
                }
            }
        }
    }

    // Correct way to stamp the parent key on new lines in a subpage
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ParentHdr: Code[20];
    begin
        // SubPageLink applies a filter on "Header Code" — read it and set FK
        ParentHdr := Rec.GetRangeMin("Header Code");
        if ParentHdr <> '' then
            Rec.Validate("Header Code", ParentHdr)
        else
            // Fallback when user inserts below an existing line
            Rec.Validate("Header Code", xRec."Header Code");
    end;
}
