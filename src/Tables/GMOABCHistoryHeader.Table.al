table 73030580 "GMO ABC History Header"
{
    Caption = 'ABC History';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; Model; Enum "GMO ABC Model") { }
        field(3; "Start Date"; Date) { }
        field(4; "End Date"; Date) { }
        field(5; "Created By"; Code[50]) { }
        field(6; "Created At"; DateTime) { }
        field(7; "Total Amount"; Decimal) { DecimalPlaces = 0 : 2; }
        field(8; "Items Count"; Integer) { }
    }
    keys { key(PK; "Entry No.") { Clustered = true; } }
}