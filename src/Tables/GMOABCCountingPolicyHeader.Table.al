table 73030592 "GMO ABC Counting Policy Header"
{
    Caption = 'ABC Counting Policy';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; Code; Code[10]) { Caption = 'Code'; }
        field(10; Description; Text[100]) { Caption = 'Description'; }
    }
    keys { key(PK; Code) { Clustered = true; } }
}