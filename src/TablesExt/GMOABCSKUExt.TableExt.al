tableextension 73030576 "GMO ABC SKU Ext." extends "Stockkeeping Unit"
{
    fields
    {
        // Per-model ABC classification fields
        field(73030627; "GMO Class (Revenue)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Revenue)'; DataClassification = CustomerContent; Editable = false; }
        field(73030628; "GMO Class (Gross Profit)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Gross Profit)'; DataClassification = CustomerContent; Editable = false; }
        field(73030629; "GMO Class (COGS)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Value/COGS)'; DataClassification = CustomerContent; Editable = false; }
        field(73030633; "GMO Class (Sales Qty)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Sales Qty)'; DataClassification = CustomerContent; Editable = false; }
        field(73030635; "GMO Class (Usage Value)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Usage Value)'; DataClassification = CustomerContent; Editable = false; }
        field(73030637; "GMO Class (GMROII)"; Enum "GMO ABC Class") { Caption = 'ABC Class (GMROII)'; DataClassification = CustomerContent; Editable = false; }
        field(73030639; "GMO Class (Pick Frequency)"; Enum "GMO ABC Class") { Caption = 'ABC Class (Pick Frequency)'; DataClassification = CustomerContent; Editable = false; }

        // Last calculation timestamp fields
        field(73030630; "GMO Last Calc (Revenue)"; DateTime) { Caption = 'ABC Last Calculated (Revenue)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030631; "GMO Last Calc (GP)"; DateTime) { Caption = 'ABC Last Calculated (Gross Profit)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030632; "GMO Last Calc (COGS)"; DateTime) { Caption = 'ABC Last Calculated (COGS)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030634; "GMO Last Calc (Sales Qty)"; DateTime) { Caption = 'ABC Last Calculated (Sales Qty)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030636; "GMO Last Calc (Usage Value)"; DateTime) { Caption = 'ABC Last Calculated (Usage Value)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030638; "GMO Last Calc (GMROII)"; DateTime) { Caption = 'ABC Last Calculated (GMROII)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030640; "GMO Last Calc (Pick Freq)"; DateTime) { Caption = 'ABC Last Calculated (Pick Frequency)'; Editable = false; DataClassification = SystemMetadata; }
    }
}