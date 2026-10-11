pageextension 73033670 "GSO Item Card Ext." extends "Item Card"
{
    layout
    {
        addafter(Planning)
        {
            group("GSO ABC Classification")
            {
                Caption = 'ABC Classification';
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
                field("GSO Class (Usage Value)"; Rec."GSO Class (Usage Value)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on usage value (consumption + sales quantity × unit cost): A (high usage), B (medium usage), C (low usage), or D (no usage).';
                }
                field("GSO Class (GMROII)"; Rec."GSO Class (GMROII)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on Gross Margin Return on Inventory Investment (GMROII = Margin / Avg Inventory Value): A (high return), B (medium return), C (low return), or D (negative return).';
                }
                field("GSO Class (Pick Frequency)"; Rec."GSO Class (Pick Frequency)")
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification based on number of picks/issues (not value): A (frequently picked), B (moderately picked), C (rarely picked), or D (never picked). Good for warehouse slotting.';
                }
                field("GSO Last Calc (Revenue)"; Rec."GSO Last Calc (Revenue)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Revenue-based ABC classification was last calculated for this item.';
                }
                field("GSO Last Calc (GP)"; Rec."GSO Last Calc (GP)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Gross Profit-based ABC classification was last calculated for this item.';
                }
                field("GSO Last Calc (COGS)"; Rec."GSO Last Calc (COGS)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the COGS-based ABC classification was last calculated for this item.';
                }
                field("GSO Last Calc (Usage Value)"; Rec."GSO Last Calc (Usage Value)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Usage Value-based ABC classification was last calculated for this item.';
                }
                field("GSO Last Calc (GMROII)"; Rec."GSO Last Calc (GMROII)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the GMROII-based ABC classification was last calculated for this item.';
                }
                field("GSO Last Calc (Pick Freq)"; Rec."GSO Last Calc (Pick Freq)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Pick Frequency-based ABC classification was last calculated for this item.';
                }
                field("GSO Manual Override"; Rec."GSO Manual Override")
                {
                    ApplicationArea = All;
                    ToolTip = 'Prevent automatic ABC classification updates for this item. Enable to manually control the ABC class assignments.';
                }
                field("GSO Exclude"; Rec."GSO Exclude")
                {
                    ApplicationArea = All;
                    ToolTip = 'Exclude this item from all ABC analysis calculations. Useful for special items, kits, or non-standard inventory.';
                }
            }
        }
    }
}