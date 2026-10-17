namespace GMSoft.ABCInventoryAnalysis;

using Microsoft.Inventory.Item;

tableextension 73033670 "GSO ABC Item Ext." extends Item
{
    fields
    {
        // Per-model ABC classification fields
        field(73033672; "GSO Class (Revenue)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Revenue)'; DataClassification = CustomerContent; Editable = false; }
        field(73033673; "GSO Class (Gross Profit)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Gross Profit)'; DataClassification = CustomerContent; Editable = false; }
        field(73033674; "GSO Class (COGS)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Value/COGS)'; DataClassification = CustomerContent; Editable = false; }
        field(73033678; "GSO Class (Usage Value)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Usage Value)'; DataClassification = CustomerContent; Editable = false; }
        field(73033680; "GSO Class (GMROII)"; Enum "GSO ABC Class") { Caption = 'ABC Class (GMROII)'; DataClassification = CustomerContent; Editable = false; }
        field(73033682; "GSO Class (Pick Frequency)"; Enum "GSO ABC Class") { Caption = 'ABC Class (Pick Frequency)'; DataClassification = CustomerContent; Editable = false; }

        // Last calculation timestamp fields
        field(73033675; "GSO Last Calc (Revenue)"; DateTime) { Caption = 'ABC Last Calculated (Revenue)'; Editable = false; DataClassification = SystemMetadata; }
        field(73033676; "GSO Last Calc (GP)"; DateTime) { Caption = 'ABC Last Calculated (Gross Profit)'; Editable = false; DataClassification = SystemMetadata; }
        field(73033677; "GSO Last Calc (COGS)"; DateTime) { Caption = 'ABC Last Calculated (COGS)'; Editable = false; DataClassification = SystemMetadata; }
        field(73033679; "GSO Last Calc (Usage Value)"; DateTime) { Caption = 'ABC Last Calculated (Usage Value)'; Editable = false; DataClassification = SystemMetadata; }
        field(73033681; "GSO Last Calc (GMROII)"; DateTime) { Caption = 'ABC Last Calculated (GMROII)'; Editable = false; DataClassification = SystemMetadata; }
        field(73033683; "GSO Last Calc (Pick Freq)"; DateTime) { Caption = 'ABC Last Calculated (Pick Frequency)'; Editable = false; DataClassification = SystemMetadata; }

        // Optional control fields
        field(73033670; "GSO Manual Override"; Boolean) { Caption = 'ABC Manual Override'; DataClassification = SystemMetadata; }
        field(73033671; "GSO Exclude"; Boolean) { Caption = 'Exclude from ABC'; DataClassification = SystemMetadata; }
    }
}
