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
                field("GMO Class (Usage Value)"; Rec."GMO Class (Usage Value)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on usage value (consumption + sales quantity × unit cost): A (high usage), B (medium usage), C (low usage), or D (no usage).';
                }
                field("GMO Class (GMROII)"; Rec."GMO Class (GMROII)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on Gross Margin Return on Inventory Investment (GMROII = Margin / Avg Inventory Value): A (high return), B (medium return), C (low return), or D (negative return).';
                }
                field("GMO Class (Pick Frequency)"; Rec."GMO Class (Pick Frequency)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on number of picks/issues (not value): A (frequently picked), B (moderately picked), C (rarely picked), or D (never picked). Good for warehouse slotting.';
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
                field("GMO Last Calc (Usage Value)"; Rec."GMO Last Calc (Usage Value)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Usage Value-based ABC classification was last calculated for this item.';
                }
                field("GMO Last Calc (GMROII)"; Rec."GMO Last Calc (GMROII)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the GMROII-based ABC classification was last calculated for this item.';
                }
                field("GMO Last Calc (Pick Freq)"; Rec."GMO Last Calc (Pick Freq)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Pick Frequency-based ABC classification was last calculated for this item.';
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