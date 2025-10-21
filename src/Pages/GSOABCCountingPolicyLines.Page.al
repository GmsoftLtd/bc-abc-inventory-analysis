page 73030579 "GSO ABC Counting Policy Lines"
{
    PageType = ListPart;
    SourceTable = "GSO ABC Counting Policy Line";
    Caption = 'Counting Policy Lines';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Model; Rec.Model) { ApplicationArea = All; ToolTip = 'ABC analysis model: Revenue, Gross Profit, or Cost of Goods Sold (COGS).'; }
                field(Class; Rec.Class) { ApplicationArea = All; ToolTip = 'ABC classification: A (highest value), B (medium value), C (lower value).'; }
                field("Counting Period Code"; Rec."Counting Period Code") { ApplicationArea = All; ToolTip = 'Physical inventory counting period code to assign to items with this model and class combination.'; }

            }
        }
    }

    trigger OnOpenPage()
    begin
        // Hide Class D rows from display
        Rec.SetFilter(Class, '<>%1', Rec.Class::D);
    end;
}