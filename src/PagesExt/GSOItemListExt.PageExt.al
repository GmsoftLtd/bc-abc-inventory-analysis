pageextension 73030576 "GSO Item List Ext." extends "Item List"
{
    layout
    {
        addlast(Control1)
        {
            field("GSO Class (Revenue)"; Rec."GSO Class (Revenue)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on revenue/sales value: A (high), B (medium), C (low), or D (inactive).';
            }
            field("GSO Class (Gross Profit)"; Rec."GSO Class (Gross Profit)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on gross profit margin contribution: A (high), B (medium), C (low), or D (inactive).';
            }
            field("GSO Class (COGS)"; Rec."GSO Class (COGS)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on cost of goods sold: A (high), B (medium), C (low), or D (inactive).';
            }
            field("GSO Class (Sales Qty)"; Rec."GSO Class (Sales Qty)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on sales quantity: A (high volume), B (medium volume), C (low volume), or D (no sales).';
            }
            field("GSO Class (Usage Value)"; Rec."GSO Class (Usage Value)")
            {
                ApplicationArea = All;
                ToolTip = 'ABC classification based on usage value (consumption + sales quantity × unit cost): A (high usage), B (medium usage), C (low usage), or D (no usage).';
            }
        }
    }
}