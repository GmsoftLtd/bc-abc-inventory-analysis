page 73030577 "GSO ABC Count Policy Subform"
{
    Caption = 'ABC Counting Policy Lines';
    PageType = ListPart;
    SourceTable = "GSO ABC Counting Policy Line";
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
                    ToolTip = 'Specifies the ABC model this line applies to.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ABC class this line applies to.';
                }
                field("Counting Period Code"; Rec."Counting Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the physical inventory counting period assigned to items with this model and class.';
                }
            }
        }
    }

    // Correct way to stamp the parent key on new lines in a subpage
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ParentHdr: Code[10];
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
