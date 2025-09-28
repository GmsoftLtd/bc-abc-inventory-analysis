page 73030632 "GMO Counting Policy Lines"
{
    PageType = ListPart;
    SourceTable = "GMO Counting Policy Line";
    Caption = 'Lines';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Model; Rec.Model) { ApplicationArea = All; }
                field(Class; Rec.Class) { ApplicationArea = All; }
                field("Counting Period Code"; Rec."Counting Period Code") { ApplicationArea = All; } // <— bind this

            }
        }
    }
}