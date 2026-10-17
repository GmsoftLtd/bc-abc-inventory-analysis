namespace GMSoft.ABCInventoryAnalysis;

using Microsoft.Inventory.Item;

pageextension 73033671 "GSO Item List Ext." extends "Item List"
{
    layout
    {
        addlast(Control1)
        {
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
                Visible = false;
                ToolTip = 'Specifies the ABC class based on gross margin return on inventory investment: A (high), B (medium), C (low) or D (no return).';
            }
            field("GSO Class (Pick Frequency)"; Rec."GSO Class (Pick Frequency)")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the ABC class based on the number of picks: A (frequent), B (moderate), C (rare) or D (never picked).';
            }
        }
    }
}
