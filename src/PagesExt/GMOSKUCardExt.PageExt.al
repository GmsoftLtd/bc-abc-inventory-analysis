pageextension 73030650 "GMO SKU Card Ext." extends "Stockkeeping Unit Card"
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
                field("GMO Last Calc (Revenue)"; Rec."GMO Last Calc (Revenue)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the GMO Last Calculated (Revenue) field.';
                }
                field("GMO Last Calc (GP)"; Rec."GMO Last Calc (GP)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the GMO Last Calculated (Gross Profit) field.';
                }
                field("GMO Last Calc (COGS)"; Rec."GMO Last Calc (COGS)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the GMO Last Calculated (COGS) field.';
                }
            }
        }
    }
}