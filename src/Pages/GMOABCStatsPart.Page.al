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
                    ToolTip = 'ABC classification: A (high value), B (medium), C (low), or D (inactive).';
                }
                field("Item Count"; Rec."Item Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of items classified in this ABC class.';
                }
                field("Count %"; Rec."Count %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Percentage of total items in this ABC class. Typically: A=20%, B=30%, C=50%.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Total value (Revenue/Profit/COGS) of all items in this ABC class.';
                }
                field("Amount %"; Rec."Amount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Percentage of total value in this class. Typically: A=80%, B=15%, C=5% (Pareto principle).';
                }
                field("Cum. Count %"; Rec."Cum. Count %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cumulative percentage of items when classes are ordered A-B-C-D.';
                }
                field("Cum. Amount %"; Rec."Cum. Amount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cumulative percentage of value when classes are ordered A-B-C-D. Shows concentration of value in top classes.';
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