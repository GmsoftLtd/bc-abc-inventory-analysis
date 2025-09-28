page 73030596 "GMO ABC Counting Policy Card"
{
    Caption = 'GMO Counting Policy';
    PageType = Card;
    SourceTable = "GMO ABC Counting Policy Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
            part(Lines; "GMO ABC Count Policy Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Header Code" = FIELD(Code);
            }
        }
    }
}
