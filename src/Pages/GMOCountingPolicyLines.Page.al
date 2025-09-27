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
                field("Period Code"; Rec."Period Code") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }
}