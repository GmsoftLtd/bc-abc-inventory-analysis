namespace GMSoft.ABCInventoryAnalysis;

table 73033670 "GSO ABC Analysis Setup"
{
    Caption = 'ABC Analysis Setup';
    Description = 'Stores configuration settings for ABC inventory classification analysis including thresholds, lookback periods, and model-specific parameters';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; }
        field(10; Enabled; Boolean) { Caption = 'Enabled'; InitValue = true; }

        field(32; "Zero Consumption as D"; Boolean) { Caption = 'Class Zero Consumption as D'; InitValue = true; }
        field(33; "Exclude Non-Inventory"; Boolean) { Caption = 'Exclude Non-Inventory Items'; InitValue = true; }
        field(60; "Last Run"; DateTime) { Caption = 'Last Run'; Editable = false; }
        field(70; "Last Upgraded To"; Text[30]) { Caption = 'Installed Version'; Editable = false; }

        // Per-model thresholds and periods
        field(100; "Rev A %"; Decimal) { Caption = 'Revenue A Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 80; }
        field(101; "Rev B %"; Decimal) { Caption = 'Revenue B Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 95; }
        field(102; "Rev Period (Days)"; Integer) { Caption = 'Revenue Period (Days)'; InitValue = 365; MinValue = 1; }

        field(110; "GP A %"; Decimal) { Caption = 'Gross Profit A Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 80; }
        field(111; "GP B %"; Decimal) { Caption = 'Gross Profit B Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 95; }
        field(112; "GP Period (Days)"; Integer) { Caption = 'Gross Profit Period (Days)'; InitValue = 365; MinValue = 1; }

        field(120; "COGS A %"; Decimal) { Caption = 'COGS A Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 80; }
        field(121; "COGS B %"; Decimal) { Caption = 'COGS B Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 95; }
        field(122; "COGS Period (Days)"; Integer) { Caption = 'COGS Period (Days)'; InitValue = 365; MinValue = 1; }

        field(128; "Usage Value A %"; Decimal) { Caption = 'Usage Value A Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 80; }
        field(129; "Usage Value B %"; Decimal) { Caption = 'Usage Value B Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 95; }
        field(135; "Usage Value Period (Days)"; Integer) { Caption = 'Usage Value Period (Days)'; InitValue = 365; MinValue = 1; }

        field(136; "GMROII A %"; Decimal) { Caption = 'GMROII A Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 80; }
        field(137; "GMROII B %"; Decimal) { Caption = 'GMROII B Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 95; }
        field(138; "GMROII Period (Days)"; Integer) { Caption = 'GMROII Period (Days)'; InitValue = 365; MinValue = 1; }

        field(139; "Pick Freq A %"; Decimal) { Caption = 'Pick Frequency A Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 80; }
        field(140; "Pick Freq B %"; Decimal) { Caption = 'Pick Frequency B Threshold %'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 95; }
        field(141; "Pick Freq Period (Days)"; Integer) { Caption = 'Pick Frequency Period (Days)'; InitValue = 365; MinValue = 1; }

        // Counting policy
        field(130; "Update Counting Codes"; Boolean) { Caption = 'Update Phys. Invt. Counting Codes'; }
        field(131; "Update SKU"; Boolean) { Caption = 'Update SKU Counting Codes'; }
        field(132; "Counting Code Mapping ID"; Code[10])
        {
            Caption = 'Counting Policy Code';
            TableRelation = "GSO ABC Counting Policy Header".Code;
            ValidateTableRelation = false;
        }
    }
    keys { key(PK; "Primary Key") { Clustered = true; } }
}
