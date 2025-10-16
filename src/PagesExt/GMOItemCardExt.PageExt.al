pageextension 73030575 "GMO Item Card Ext." extends "Item Card"
{
    layout
    {
        addafter(Planning)
        {
            group("GMO ABC Classification")
            {
                Caption = 'ABC Classification';
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
                field("GMO Class (Sales Qty)"; Rec."GMO Class (Sales Qty)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on sales quantity: A (high volume), B (medium volume), C (low volume), or D (no sales).';
                }
                field("GMO Class (Usage Value)"; Rec."GMO Class (Usage Value)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on usage value (consumption + sales quantity × unit cost): A (high usage), B (medium usage), C (low usage), or D (no usage).';
                }
                field("GMO Last Calc (Revenue)"; Rec."GMO Last Calc (Revenue)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Revenue-based ABC classification was last calculated for this item.';
                }
                field("GMO Last Calc (GP)"; Rec."GMO Last Calc (GP)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Gross Profit-based ABC classification was last calculated for this item.';
                }
                field("GMO Last Calc (COGS)"; Rec."GMO Last Calc (COGS)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the COGS-based ABC classification was last calculated for this item.';
                }
                field("GMO Last Calc (Sales Qty)"; Rec."GMO Last Calc (Sales Qty)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Sales Quantity-based ABC classification was last calculated for this item.';
                }
                field("GMO Last Calc (Usage Value)"; Rec."GMO Last Calc (Usage Value)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Usage Value-based ABC classification was last calculated for this item.';
                }
                field("GMO Manual Override"; Rec."GMO Manual Override")
                {
                    ApplicationArea = All;
                    ToolTip = 'Prevent automatic ABC classification updates for this item. Enable to manually control the ABC class assignments.';
                }
                field("GMO Exclude"; Rec."GMO Exclude")
                {
                    ApplicationArea = All;
                    ToolTip = 'Exclude this item from all ABC analysis calculations. Useful for special items, kits, or non-standard inventory.';
                }
            }
        }
    }
}