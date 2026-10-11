pageextension 73033673 "GSO SKU Card Ext." extends "Stockkeeping Unit Card"
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
                    ToolTip = 'Specifies the ABC class based on revenue: A (high), B (medium), C (low) or D (no activity).';
                }
                field("GSO Class (Gross Profit)"; Rec."GSO Class (Gross Profit)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ABC class based on gross profit: A (high), B (medium), C (low) or D (no activity).';
                }
                field("GSO Class (COGS)"; Rec."GSO Class (COGS)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ABC class based on cost of goods sold: A (high), B (medium), C (low) or D (no activity).';
                }
                field("GSO Class (Usage Value)"; Rec."GSO Class (Usage Value)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ABC class based on usage value: A (high), B (medium), C (low) or D (no activity).';
                }
                field("GSO Class (GMROII)"; Rec."GSO Class (GMROII)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ABC class based on gross margin return on inventory investment: A (high), B (medium), C (low) or D (no return).';
                }
                field("GSO Class (Pick Frequency)"; Rec."GSO Class (Pick Frequency)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ABC class based on the number of picks: A (frequent), B (moderate), C (rare) or D (never picked).';
                }
                field("GSO Last Calc (Revenue)"; Rec."GSO Last Calc (Revenue)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the Revenue class was last applied to this stockkeeping unit.';
                }
                field("GSO Last Calc (GP)"; Rec."GSO Last Calc (GP)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the Gross Profit class was last applied to this stockkeeping unit.';
                }
                field("GSO Last Calc (COGS)"; Rec."GSO Last Calc (COGS)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the COGS class was last applied to this stockkeeping unit.';
                }
            }
        }
    }
}
