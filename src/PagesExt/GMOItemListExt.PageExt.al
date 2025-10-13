pageextension 73030576 "GMO Item List Ext." extends "Item List"
{
    layout
    {
        addlast(Control1)
        {
            field("GMO Class (Revenue)"; Rec."GMO Class (Revenue)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on revenue/sales value: A (high), B (medium), C (low), or D (inactive).';
            }
            field("GMO Class (Gross Profit)"; Rec."GMO Class (Gross Profit)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on gross profit margin contribution: A (high), B (medium), C (low), or D (inactive).';
            }
            field("GMO Class (COGS)"; Rec."GMO Class (COGS)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on cost of goods sold: A (high), B (medium), C (low), or D (inactive).';
            }
        }
    }
}