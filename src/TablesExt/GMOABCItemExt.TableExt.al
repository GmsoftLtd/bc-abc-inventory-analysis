tableextension 73030575 "GMO ABC Item Ext." extends Item
{
    fields
    {
        // Per-model ABC classification fields
        field(73030620; "GMO Class (Revenue)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Revenue)'; DataClassification = CustomerContent; Editable = false; }
        field(73030621; "GMO Class (Gross Profit)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Gross Profit)'; DataClassification = CustomerContent; Editable = false; }
        field(73030622; "GMO Class (COGS)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Value/COGS)'; DataClassification = CustomerContent; Editable = false; }
        field(73030626; "GMO Class (Sales Qty)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Sales Qty)'; DataClassification = CustomerContent; Editable = false; }
        field(73030628; "GMO Class (Usage Value)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Usage Value)'; DataClassification = CustomerContent; Editable = false; }
        field(73030630; "GMO Class (GMROII)"; Enum "GMO ABC Class") { Caption = 'ABC Class (GMROII)'; DataClassification = CustomerContent; Editable = false; }
        field(73030632; "GMO Class (Pick Frequency)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Pick Frequency)'; DataClassification = CustomerContent; Editable = false; }

        // Last calculation timestamp fields
        field(73030623; "GMO Last Calc (Revenue)"; DateTime) { Caption = 'ABC Last Calculated (Revenue)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030624; "GMO Last Calc (GP)"; DateTime) { Caption = 'ABC Last Calculated (Gross Profit)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030625; "GMO Last Calc (COGS)"; DateTime) { Caption = 'ABC Last Calculated (COGS)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030627; "GMO Last Calc (Sales Qty)"; DateTime) { Caption = 'ABC Last Calculated (Sales Qty)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030629; "GMO Last Calc (Usage Value)"; DateTime) { Caption = 'ABC Last Calculated (Usage Value)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030631; "GMO Last Calc (GMROII)"; DateTime) { Caption = 'ABC Last Calculated (GMROII)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030633; "GMO Last Calc (Pick Freq)"; DateTime) { Caption = 'ABC Last Calculated (Pick Frequency)'; Editable = false; DataClassification = SystemMetadata; }

        // Optional control fields
        field(73030605; "GMO Manual Override"; Boolean) { Caption = 'ABC Manual Override'; DataClassification = SystemMetadata; }
        field(73030607; "GMO Exclude"; Boolean) { Caption = 'Exclude from ABC'; DataClassification = SystemMetadata; }
    }
}