table 73030582 "GSO ABC Stats"
{
    Caption = 'ABC Stats';
    Description = 'Temporary table for calculating and displaying statistical summaries of ABC classification distribution';
    DataClassification = CustomerContent;
    TableType = Temporary;
    InherentPermissions = X;
    InherentEntitlements = X;

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; Class; Enum "GSO ABC Class") { }
        field(3; "Item Count"; Integer) { }
        field(4; "Count %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(5; Amount; Decimal) { DecimalPlaces = 0 : 2; }
        field(6; "Amount %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(7; "Cum. Count %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(8; "Cum. Amount %"; Decimal) { DecimalPlaces = 0 : 5; }
    }
    keys { key(PK; "Line No.") { Clustered = true; } }
}