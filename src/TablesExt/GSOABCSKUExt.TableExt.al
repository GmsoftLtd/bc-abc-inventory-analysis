tableextension 73030576 "GSO ABC SKU Ext." extends "Stockkeeping Unit"
{
    fields
    {
        // Per-model ABC classification fields
        field(73030627; "GSO Class (Revenue)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Revenue)'; DataClassification = CustomerContent; Editable = false; }
        field(73030628; "GSO Class (Gross Profit)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Gross Profit)'; DataClassification = CustomerContent; Editable = false; }
        field(73030629; "GSO Class (COGS)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Value/COGS)'; DataClassification = CustomerContent; Editable = false; }
        field(73030633; "GSO Class (Sales Qty)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Sales Qty)'; DataClassification = CustomerContent; Editable = false; }
        field(73030635; "GSO Class (Usage Value)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Usage Value)'; DataClassification = CustomerContent; Editable = false; }
        field(73030637; "GSO Class (GMROII)"; Enum "GSO ABC Class") { Caption = 'ABC Class (GMROII)'; DataClassification = CustomerContent; Editable = false; }
        field(73030639; "GSO Class (Pick Frequency)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Pick Frequency)'; DataClassification = CustomerContent; Editable = false; }

        // Last calculation timestamp fields
        field(73030630; "GSO Last Calc (Revenue)"; DateTime) { Caption = 'ABC Last Calculated (Revenue)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030631; "GSO Last Calc (GP)"; DateTime) { Caption = 'ABC Last Calculated (Gross Profit)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030632; "GSO Last Calc (COGS)"; DateTime) { Caption = 'ABC Last Calculated (COGS)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030634; "GSO Last Calc (Sales Qty)"; DateTime) { Caption = 'ABC Last Calculated (Sales Qty)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030636; "GSO Last Calc (Usage Value)"; DateTime) { Caption = 'ABC Last Calculated (Usage Value)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030638; "GSO Last Calc (GMROII)"; DateTime) { Caption = 'ABC Last Calculated (GMROII)'; Editable = false; DataClassification = SystemMetadata; }
        field(73030640; "GSO Last Calc (Pick Freq)"; DateTime) { Caption = 'ABC Last Calculated (Pick Frequency)'; Editable = false; DataClassification = SystemMetadata; }
    }
}