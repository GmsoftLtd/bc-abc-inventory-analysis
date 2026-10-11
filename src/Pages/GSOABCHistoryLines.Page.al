page 73030584 "GSO ABC History Lines"
{
    ContextSensitiveHelpPage = 'history';
    Caption = 'ABC History Lines';
    PageType = ListPart;
    SourceTable = "GSO ABC History Line";
    SourceTableView = sorting(Class);
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
 

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sequential line number within this historical ABC analysis run.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item number for this ABC classification result.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'ABC classification assigned to this item: A (high value), B (medium), C (low), or D (inactive).';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value calculated for this item by the model of the run.';
                }
                field("Value %"; Rec."Value %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Percentage of total value contributed by this single item.';
                }
                field("Cum. %"; Rec."Cum. %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cumulative percentage when items are sorted by value descending. Used to determine ABC class boundaries.';
                }
            }
        }
    }
}