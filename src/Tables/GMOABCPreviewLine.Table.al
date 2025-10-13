table 73030579 "GMO ABC Preview Line"
{
    Caption = 'ABC Inventory Optimizer - Preview Line';
    Description = 'Temporary table for displaying preview results of ABC analysis calculations before committing to history';
    DataClassification = CustomerContent;
    DataCaptionFields = Description;

    fields
    {
        field(1; "Line No."; Integer) { Caption = 'Line No.'; }
        field(10; "Item No."; Code[20]) { Caption = 'Item No.'; TableRelation = Item."No."; }
        field(11; Description; Text[100]) { Caption = 'Description'; }
        field(12; Model; Enum "GMO ABC Model") { Caption = 'Model'; }
        field(13; Value; Decimal) { Caption = 'Value'; }
        field(14; "Value %"; Decimal) { Caption = 'Value %'; }
        field(15; "Cum. %"; Decimal) { Caption = 'Cumulative %'; }
        field(16; Class; Enum "GMO ABC Class") { Caption = 'Class'; }
    }

    keys
    {
        key(PK; "Line No.") { Clustered = true; }
        key(ValueKey; Value) { } // used for value-desc cumulative calculations
    }
}
