table 73030610 "GMO ABC Preview Line"
{
    Caption = 'GMO ABC Preview Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer) { Caption = 'Line No.'; }
        field(10; "Item No."; Code[20]) { Caption = 'Item No.'; TableRelation = Item."No."; }
        field(11; Description; Text[100]) { Caption = 'Description'; }
        field(12; Model; Option) { Caption = 'Model'; OptionMembers = Revenue,"Gross Profit",COGS; }
        field(13; Value; Decimal) { Caption = 'Value'; }
        field(14; "Value %"; Decimal) { Caption = 'Value %'; }
        field(15; "Cum. %"; Decimal) { Caption = 'Cumulative %'; }
        field(16; Class; Option) { Caption = 'Class'; OptionMembers = A,B,C; }
    }

    keys
    {
        key(PK; "Line No.") { Clustered = true; }
        key(ValueKey; Value) { } // for descending sort during cum%
    }
}
