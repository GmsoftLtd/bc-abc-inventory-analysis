page 73030584 "GMO ABC History Lines"
{
    Caption = 'ABC History Lines';
    PageType = ListPart;
    SourceTable = "GMO ABC History Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class field.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field("Value %"; Rec."Value %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value % field.';
                }
                field("Cum. %"; Rec."Cum. %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cum. % field.';
                }
            }
        }
    }
}