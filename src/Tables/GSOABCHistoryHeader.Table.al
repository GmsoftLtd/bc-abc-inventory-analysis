table 73030580 "GSO ABC History Header"
{
    Caption = 'ABC History';
    Description = 'Records historical ABC analysis runs with summary information including date range, model, and totals';
    DataClassification = CustomerContent;
    InherentPermissions = X;
    InherentEntitlements = X;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; Model; Enum "GSO ABC Model") { }
        field(3; "Start Date"; Date) { }
        field(4; "End Date"; Date) { }
        field(5; "Created By"; Code[50]) { }
        field(6; "Created At"; DateTime) { }
        field(7; "Total Amount"; Decimal) { DecimalPlaces = 0 : 2; }
        field(8; "Items Count"; Integer) { }
    }
    keys { key(PK; "Entry No.") { Clustered = true; } }
}