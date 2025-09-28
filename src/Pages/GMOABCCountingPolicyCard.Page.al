page 73030631 "GMO ABC Counting Policy Card"
{
    PageType = Card;
    SourceTable = "GMO ABC Counting Policy Header";
    Caption = 'GMO Counting Policy';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; Editable = false;ToolTip = 'Specifies the code of the counting policy.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Specifies the description of the counting policy.'; }
            }
            part(Lines;  "GMO ABC Counting Policy Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Header Code" = field(Code);
            }
        }
    }
}
