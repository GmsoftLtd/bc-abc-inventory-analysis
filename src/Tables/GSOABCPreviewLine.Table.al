table 73030579 "GSO ABC Preview Line"
{
    Caption = 'ABC Inventory - Preview Line';
    Description = 'Temporary table for displaying preview results of ABC analysis calculations before committing to history';
    DataClassification = CustomerContent;
    DataCaptionFields = Description;
    InherentPermissions = X;
    InherentEntitlements = X;

    fields
    {
        field(1; "Line No."; Integer) { Caption = 'Line No.'; }
        field(10; "Item No."; Code[20]) { Caption = 'Item No.'; TableRelation = Item."No."; }
        field(11; Description; Text[100]) { Caption = 'Description'; }
        field(12; Model; Enum "GSO ABC Model") { Caption = 'Model'; }
        field(13; Value; Decimal) { Caption = 'Value'; }
        field(14; "Value %"; Decimal) { Caption = 'Value %'; }
        field(15; "Cum. %"; Decimal) { Caption = 'Cumulative %'; }
        field(16; Class; Enum "GSO ABC Class") { Caption = 'Class'; }
    }

    keys
    {
        key(PK; "Line No.") { Clustered = true; }
        key(ValueKey; Value) { } // used for value-desc cumulative calculations
        key(ClassValue; Class, Value) { } // used for displaying by class then value
    }
}
