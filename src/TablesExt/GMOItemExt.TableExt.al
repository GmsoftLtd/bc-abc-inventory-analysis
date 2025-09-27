tableextension 73030579 "GMO Item Ext." extends Item
{
    fields
    {
        // Generic (legacy) fields remain optional if you kept them earlier. New per-model:
        field(73030620; "GMO Class (Revenue)"; Enum "GMO Class") { Caption = 'GMO Class (Revenue)'; DataClassification = CustomerContent; Editable = false; }
        field(73030621; "GMO Class (Gross Profit)"; Enum "GMO Class") { Caption = 'GMO Class (Gross Profit)'; DataClassification = CustomerContent; Editable = false; }
        field(73030622; "GMO Class (COGS)"; Enum "GMO Class") { Caption = 'GMO Class (Value/COGS)'; DataClassification = CustomerContent; Editable = false; }

        field(73030623; "GMO Last Calc (Revenue)"; DateTime) { Caption = 'GMO Last Calculated (Revenue)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030624; "GMO Last Calc (GP)"; DateTime) { Caption = 'GMO Last Calculated (Gross Profit)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030625; "GMO Last Calc (COGS)"; DateTime) { Caption = 'GMO Last Calculated (COGS)'; Editable = false; DataClassification = SystemMetadata; }

        // Optional control fields
        field(73030605; "GMO Manual Override"; Boolean) { Caption = 'GMO Manual Override'; DataClassification = SystemMetadata; }
        field(73030607; "GMO Exclude"; Boolean) { Caption = 'Exclude from GMO ABC'; DataClassification = SystemMetadata; }
    }
}