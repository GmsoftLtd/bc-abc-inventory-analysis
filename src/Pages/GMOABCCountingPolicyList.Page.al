page 73030594 "GMO ABC Counting Policy List"
{
    Caption = 'ABC Counting Policies';
    PageType = List;
    SourceTable = "GMO ABC Counting Policy Header";
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = "GMO ABC Counting Policy Card";

    layout
    {
        area(content)
        {
            repeater(Gen)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
