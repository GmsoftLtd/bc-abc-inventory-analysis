table 73030578 "GMO ABC Counting Policy Line"
{
    Caption = 'Counting Policy Line';
    DataClassification = SystemMetadata;
    DataCaptionFields = Model, Class;

    fields
    {
        field(1; "Header Code"; Code[10]) { Caption = 'Header Code'; TableRelation = "GMO ABC Counting Policy Header".Code; }
        field(2; Model; Enum "GMO ABC Model") { Caption = 'Model'; }
        field(3; Class; Enum "GMO ABC Class") { Caption = 'Class'; }
        field(4; "Counting Period Code"; Code[10]) { TableRelation = "Phys. Invt. Counting Period".Code; } // <— REQUIRED NAME
        field(10; "Item Period Code"; Code[10]) { Caption = 'Item Counting Period Code'; TableRelation = "Phys. Invt. Counting Period".Code; }
        field(11; "SKU Period Code"; Code[10]) { Caption = 'SKU Counting Period Code'; TableRelation = "Phys. Invt. Counting Period".Code; }
    }
    keys { key(PK; "Header Code", Model, Class) { Clustered = true; } }
}