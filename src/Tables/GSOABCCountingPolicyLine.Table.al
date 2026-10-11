table 73030578 "GSO ABC Counting Policy Line"
{
    Caption = 'Counting Policy Line';
    Description = 'Specifies counting period assignments for each ABC class and model combination within a counting policy';
    DataClassification = SystemMetadata;
    DataCaptionFields = Model, Class;

    fields
    {
        field(1; "Header Code"; Code[10]) { Caption = 'Header Code'; TableRelation = "GSO ABC Counting Policy Header".Code; }
        field(2; Model; Enum "GSO ABC Model") { Caption = 'Model'; }
        field(3; Class; Enum "GSO ABC Class") { Caption = 'Class'; }
        field(4; "Counting Period Code"; Code[10]) { Caption = 'Counting Period Code'; TableRelation = "Phys. Invt. Counting Period".Code; }
    }
    keys { key(PK; "Header Code", Model, Class) { Clustered = true; } }
}
