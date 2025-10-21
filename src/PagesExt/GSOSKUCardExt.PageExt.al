pageextension 73030578 "GSO SKU Card Ext." extends "Stockkeeping Unit Card"
{
    layout
    {
        addafter(Replenishment)
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
                field("GSO Last Calc (Revenue)"; Rec."GSO Last Calc (Revenue)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Revenue-based ABC classification was last calculated for this SKU.';
                }
                field("GSO Last Calc (GP)"; Rec."GSO Last Calc (GP)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the Gross Profit-based ABC classification was last calculated for this SKU.';
                }
                field("GSO Last Calc (COGS)"; Rec."GSO Last Calc (COGS)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the COGS-based ABC classification was last calculated for this SKU.';
                }
            }
        }
    }
}