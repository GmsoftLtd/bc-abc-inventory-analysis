pageextension 73030576 "GMO Item List Ext." extends "Item List"
{
    layout
    {
        addlast(Control1)
        {
            field("GMO Class (Revenue)"; Rec."GMO Class (Revenue)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GMO Class (Revenue) field.';
            }
            field("GMO Class (Gross Profit)"; Rec."GMO Class (Gross Profit)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GMO Class (Gross Profit) field.';
            }
            field("GMO Class (COGS)"; Rec."GMO Class (COGS)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GMO Class (Value/COGS) field.';
            }
        }
    }
}