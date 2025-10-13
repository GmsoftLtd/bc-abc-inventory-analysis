page 73030578 "GMO ABC Counting Policy Card"
{
    Caption = 'ABC Inventory Optimizer - Counting Policy';
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
                    ToolTip = 'Unique identifier for this counting policy template. Used to link the policy to ABC analysis setup.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Descriptive name for the counting policy. Example: "Standard ABC Counting Schedule" or "Quarterly Cycle Count".';
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
