table 73030582 "GMO ABC Stats"
{
    Caption = 'ABC Stats';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; Class; Enum "GMO ABC Class") { }
        field(3; "Item Count"; Integer) { }
        field(4; "Count %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(5; Amount; Decimal) { DecimalPlaces = 0 : 2; }
        field(6; "Amount %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(7; "Cum. Count %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(8; "Cum. Amount %"; Decimal) { DecimalPlaces = 0 : 5; }
    }
    keys { key(PK; "Line No.") { Clustered = true; } }
}