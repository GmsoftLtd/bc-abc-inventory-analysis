table 73030635 "GMO ABC History Line"
{
    Caption = 'GMO ABC History Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { TableRelation = "GMO ABC History Header"."Entry No."; }
        field(2; "Line No."; Integer) { }
        field(3; "Item No."; Code[20]) { TableRelation = Item."No."; }
        field(4; Class; Enum "GMO Class") { }
        field(5; Value; Decimal) { DecimalPlaces = 0:2; }
        field(6; "Value %"; Decimal) { DecimalPlaces = 0:5; }
        field(7; "Cum. %"; Decimal) { DecimalPlaces = 0:5; }
    }
    keys { key(PK; "Entry No.", "Line No.") { Clustered = true; } }
}