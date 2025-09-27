table 73030593 "GMO Counting Policy Line"
{
    Caption = 'GMO Counting Policy Line';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Header Code"; Code[10]) { Caption = 'Header Code'; TableRelation = "GMO Counting Policy Header".Code; }
        field(2; Model; Enum "GMO ABC Model") { Caption = 'Model'; }
        field(3; Class; Enum "GMO Class") { Caption = 'Class'; }
        field(10; "Item Period Code"; Code[10]) { Caption = 'Item Counting Period Code'; TableRelation = "Phys. Invt. Counting Period".Code; }
        field(11; "SKU Period Code"; Code[10])  { Caption = 'SKU Counting Period Code';  TableRelation = "Phys. Invt. Counting Period".Code; }
    }
    keys { key(PK; "Header Code", Model, Class) { Clustered = true; } }
}