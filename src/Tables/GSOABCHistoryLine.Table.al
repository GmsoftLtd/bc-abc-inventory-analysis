table 73030581 "GSO ABC History Line"
{
    Caption = 'ABC History Line';
    Description = 'Stores detailed item-level ABC classification results from historical analysis runs';
    DataClassification = CustomerContent;
    InherentPermissions = X;
    InherentEntitlements = X;

    fields
    {
        field(1; "Entry No."; Integer) { TableRelation = "GSO ABC History Header"."Entry No."; }
        field(2; "Line No."; Integer) { }
        field(3; "Item No."; Code[20]) { TableRelation = Item."No."; }
        field(4; Class; Enum "GSO ABC Class") { }
        field(5; Value; Decimal) { DecimalPlaces = 0 : 2; }
        field(6; "Value %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(7; "Cum. %"; Decimal) { DecimalPlaces = 0 : 5; }
    }
    keys
    {
        key(PK; "Entry No.", "Line No.") { Clustered = true; }
        key(ClassKey; Class) { }
    }
}