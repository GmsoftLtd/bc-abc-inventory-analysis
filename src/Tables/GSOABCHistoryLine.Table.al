table 73030581 "GSO ABC History Line"
{
    Caption = 'ABC History Line';
    Description = 'Stores detailed item-level ABC classification results from historical analysis runs';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; TableRelation = "GSO ABC History Header"."Entry No."; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; }
        field(3; "Item No."; Code[20]) { Caption = 'Item No.'; TableRelation = Item."No."; }
        field(4; Class; Enum "GSO ABC Class") { Caption = 'Class'; }
        field(5; Value; Decimal) { Caption = 'Value'; DecimalPlaces = 0 : 2; }
        field(6; "Value %"; Decimal) { Caption = 'Value %'; DecimalPlaces = 0 : 5; }
        field(7; "Cum. %"; Decimal) { Caption = 'Cumulative %'; DecimalPlaces = 0 : 5; }
    }
    keys
    {
        key(PK; "Entry No.", "Line No.") { Clustered = true; }
        key(ClassKey; Class) { }
        key(ItemKey; "Entry No.", "Item No.") { }
    }
}
