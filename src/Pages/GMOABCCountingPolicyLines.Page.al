page 73030632 "GMO ABC Counting Policy Lines"
{
    PageType = ListPart;
    SourceTable = "GMO ABC Counting Policy Line";
    Caption = 'Counting Policy Lines';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Model; Rec.Model) { ApplicationArea = All;ToolTip = 'Specifies the value of the Model field.'; }
                field(Class; Rec.Class) { ApplicationArea = All;ToolTip = 'Specifies the value of the Class field.'; }
                field("Counting Period Code"; Rec."Counting Period Code") { ApplicationArea = All;ToolTip = 'Specifies the value of the Counting Period Code field.'; }

            }
        }
    }
}