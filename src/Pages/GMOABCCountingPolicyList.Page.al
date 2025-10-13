page 73030576 "GMO ABC Counting Policy List"
{
    Caption = 'ABC Counting Policies';
    PageType = List;
    SourceTable = "GMO ABC Counting Policy Header";
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = "GMO ABC Counting Policy Card";

    layout
    {
        area(content)
        {
            repeater(Gen)
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
        }
    }
}
