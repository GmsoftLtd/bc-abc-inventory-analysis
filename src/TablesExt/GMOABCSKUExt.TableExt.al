tableextension 73030626 "GMO ABC SKU Ext." extends "Stockkeeping Unit"
{
    fields
    {
        field(73030627; "GMO Class (Revenue)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Revenue)'; DataClassification = CustomerContent; Editable = false; }
        field(73030628; "GMO Class (Gross Profit)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Gross Profit)'; DataClassification = CustomerContent; Editable = false; }
        field(73030629; "GMO Class (COGS)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Value/COGS)'; DataClassification = CustomerContent; Editable = false; }

        field(73030630; "GMO Last Calc (Revenue)"; DateTime) { Caption = 'ABC Last Calculated (Revenue)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030631; "GMO Last Calc (GP)"; DateTime) { Caption = 'ABC Last Calculated (Gross Profit)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030632; "GMO Last Calc (COGS)"; DateTime) { Caption = 'ABC Last Calculated (COGS)'; Editable = false; DataClassification = SystemMetadata; }
    }
}