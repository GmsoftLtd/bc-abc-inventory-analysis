table 73030577 "GMO ABC Analysis Setup"
{
    Caption = 'ABC Analysis Setup';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; }
        field(10; Enabled; Boolean) { Caption = 'Enabled'; }

        field(20; "A Threshold %"; Decimal) { Caption = 'A Threshold % (Cumulative)'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 80; }
        field(21; "B Threshold %"; Decimal) { Caption = 'B Threshold % (Cumulative)'; DecimalPlaces = 0 : 2; MinValue = 0; MaxValue = 100; InitValue = 95; }

        field(30; "Lookback (Days)"; Integer) { Caption = 'Lookback (Days)'; MinValue = 1; InitValue = 365; }
        field(31; "Include Transfers"; Boolean) { Caption = 'Include Transfers as Outbound'; }
        field(32; "Zero Consumption as D"; Boolean) { Caption = 'Class Zero Consumption as D'; }
        field(33; "Exclude Non-Inventory"; Boolean) { Caption = 'Exclude Non-Inventory Items'; InitValue = true; }
        field(40; "Auto Update On Posting"; Boolean) { Caption = 'Mark Items for Recalc on Posting'; InitValue = true; }
        field(50; "Commit Batch Size"; Integer) { Caption = 'Commit Batch Size'; MinValue = 1; InitValue = 500; }
        field(60; "Last Run"; DateTime) { Caption = 'Last Run'; }
        field(70; "Last Upgraded To"; Text[30]) { Caption = 'Last Upgraded To Version'; }

        // Per-model thresholds and periods
        field(100; "Rev A %"; Decimal) { Caption = 'Revenue A Threshold %'; DecimalPlaces = 0 : 2; InitValue = 80; }
        field(101; "Rev B %"; Decimal) { Caption = 'Revenue B Threshold %'; DecimalPlaces = 0 : 2; InitValue = 95; }
        field(102; "Rev Period (Days)"; Integer) { Caption = 'Revenue Period (Days)'; InitValue = 365; MinValue = 1; }

        field(110; "GP A %"; Decimal) { Caption = 'Gross Profit A Threshold %'; DecimalPlaces = 0 : 2; InitValue = 80; }
        field(111; "GP B %"; Decimal) { Caption = 'Gross Profit B Threshold %'; DecimalPlaces = 0 : 2; InitValue = 95; }
        field(112; "GP Period (Days)"; Integer) { Caption = 'Gross Profit Period (Days)'; InitValue = 365; MinValue = 1; }

        field(120; "COGS A %"; Decimal) { Caption = 'COGS A Threshold %'; DecimalPlaces = 0 : 2; InitValue = 80; }
        field(121; "COGS B %"; Decimal) { Caption = 'COGS B Threshold %'; DecimalPlaces = 0 : 2; InitValue = 95; }
        field(122; "COGS Period (Days)"; Integer) { Caption = 'COGS Period (Days)'; InitValue = 365; MinValue = 1; }

        // Counting policy
        field(130; "Update Counting Codes"; Boolean) { Caption = 'Update Warehouse Counting Codes'; }
        field(131; "Update SKU"; Boolean) { Caption = 'Update SKU as well'; }
        field(132; "Counting Code Mapping ID"; Code[10]) { Caption = 'Counting Policy Mapping ID'; TableRelation = "GMO ABC Counting Policy Header".Code; }
    }
    keys { key(PK; "Primary Key") { Clustered = true; } }
}