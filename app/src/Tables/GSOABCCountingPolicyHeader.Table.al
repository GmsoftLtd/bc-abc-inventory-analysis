namespace GMSoft.ABCInventoryAnalysis;

table 73033671 "GSO ABC Counting Policy Header"
{
    Caption = 'ABC Counting Policy';
    Description = 'Defines counting policy templates that map ABC classifications to physical inventory counting frequencies';
    DataClassification = SystemMetadata;
    DataCaptionFields = Code, Description;

    fields
    {
        field(1; Code; Code[10]) { Caption = 'Code'; }
        field(10; Description; Text[100]) { Caption = 'Description'; }
    }
    keys { key(PK; Code) { Clustered = true; } }
}