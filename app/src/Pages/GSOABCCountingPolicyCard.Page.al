namespace GMSoft.ABCInventoryAnalysis;

page 73033673 "GSO ABC Counting Policy Card"
{
    ContextSensitiveHelpPage = 'counting-policies';
    Caption = 'ABC Inventory - Counting Policy';
    PageType = Card;
    SourceTable = "GSO ABC Counting Policy Header";
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
            part(Lines; "GSO ABC Count Policy Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Header Code" = FIELD(Code);
            }
        }
    }
}
