pageextension 73030578 "GMO SKU Card Ext." extends "Stockkeeping Unit Card"
{
    layout
    {
        addafter(Replenishment)
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
                field("GMO Last Calc (Revenue)"; Rec."GMO Last Calc (Revenue)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Revenue-based ABC classification was last calculated for this SKU.';
                }
                field("GMO Last Calc (GP)"; Rec."GMO Last Calc (GP)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Gross Profit-based ABC classification was last calculated for this SKU.';
                }
                field("GMO Last Calc (COGS)"; Rec."GMO Last Calc (COGS)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the COGS-based ABC classification was last calculated for this SKU.';
                }
            }
        }
    }
}