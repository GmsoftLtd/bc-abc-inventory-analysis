tableextension 73030626 "GMO SKU Ext." extends "Stockkeeping Unit"
{
    fields
    {
        field(73030627; "GMO Class (Revenue)"; Enum "GMO Class") { Caption = 'GMO Class (Revenue)'; DataClassification = CustomerContent; Editable = false; }
        field(73030628; "GMO Class (Gross Profit)"; Enum "GMO Class") { Caption = 'GMO Class (Gross Profit)'; DataClassification = CustomerContent; Editable = false; }
        field(73030629; "GMO Class (COGS)"; Enum "GMO Class") { Caption = 'GMO Class (Value/COGS)'; DataClassification = CustomerContent; Editable = false; }

        field(73030630; "GMO Last Calc (Revenue)"; DateTime) { Caption = 'GMO Last Calculated (Revenue)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030631; "GMO Last Calc (GP)"; DateTime) { Caption = 'GMO Last Calculated (Gross Profit)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030632; "GMO Last Calc (COGS)"; DateTime) { Caption = 'GMO Last Calculated (COGS)'; Editable = false; DataClassification = SystemMetadata; }
    }
}