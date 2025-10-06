page 73030582 "GMO ABC Stats Part"
{
    Caption = 'ABC Statistics';
    PageType = ListPart;
    SourceTable = "GMO ABC Stats";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Stats)
            {
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class field.';
                }
                field("Item Count"; Rec."Item Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Count field.';
                }
                field("Count %"; Rec."Count %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Count % field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount %"; Rec."Amount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount % field.';
                }
                field("Cum. Count %"; Rec."Cum. Count %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cum. Count % field.';
                }
                field("Cum. Amount %"; Rec."Cum. Amount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cum. Amount % field.';
                }
            }
        }
    }

    var
        TempStats: Record "GMO ABC Stats" temporary;

    procedure SetStats(var NewTempStats: Record "GMO ABC Stats" temporary)
    begin
        TempStats.DeleteAll();
        Rec.DeleteAll();
        NewTempStats.Reset();
        if NewTempStats.FindSet() then
            repeat
                TempStats := NewTempStats;
                TempStats.Insert();
            until NewTempStats.Next() = 0;
        Rec.Copy(TempStats, true);
        CurrPage.Update(false);
    end;
}