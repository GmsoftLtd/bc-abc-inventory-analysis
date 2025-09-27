table 73030633 "GMO ABC Preview Line"
{
    Caption = 'GMO ABC Preview Line';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; "Item No."; Code[20]) { TableRelation = Item."No."; }
        field(3; Description; Text[100]) { }
        field(4; Model; Enum "GMO ABC Model") { }
        field(5; Value; Decimal) { Caption = 'Calc. Value'; DecimalPlaces = 0 : 2; }
        field(6; "Value %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(7; "Cum. %"; Decimal) { DecimalPlaces = 0 : 5; }
        field(8; Class; Enum "GMO Class") { }
    }
    keys { key(PK; "Line No.") { Clustered = true; } }
}