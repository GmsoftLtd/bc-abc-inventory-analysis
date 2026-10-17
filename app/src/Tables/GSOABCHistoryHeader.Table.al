namespace GMSoft.ABCInventoryAnalysis;

table 73033674 "GSO ABC History Header"
{
    Caption = 'ABC History';
    Description = 'Records historical ABC analysis runs with summary information including date range, model, and totals';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; AutoIncrement = true; }
        field(2; Model; Enum "GSO ABC Model") { Caption = 'Model'; }
        field(3; "Start Date"; Date) { Caption = 'Start Date'; }
        field(4; "End Date"; Date) { Caption = 'End Date'; }
        field(5; "Created By"; Code[50]) { Caption = 'Created By'; DataClassification = EndUserIdentifiableInformation; }
        field(6; "Created At"; DateTime) { Caption = 'Created At'; }
        field(7; "Total Amount"; Decimal) { Caption = 'Total Amount'; DecimalPlaces = 0 : 2; }
        field(8; "Items Count"; Integer) { Caption = 'Items Count'; }
    }
    keys { key(PK; "Entry No.") { Clustered = true; } }

    trigger OnDelete()
    var
        HistLine: Record "GSO ABC History Line";
    begin
        HistLine.SetRange("Entry No.", Rec."Entry No.");
        HistLine.DeleteAll();
    end;
}
