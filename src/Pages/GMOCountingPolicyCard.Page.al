page 73030631 "GMO Counting Policy Card"
{
    PageType = Card;
    SourceTable = "GMO Counting Policy Header";
    Caption = 'GMO Counting Policy';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; Editable = false; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
            part(Lines;  "GMO Counting Policy Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Header Code" = field(Code);
            }
        }
    }
}
