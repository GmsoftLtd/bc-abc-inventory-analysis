page 73030575 "GMO ABC Analysis Setup"
{
    Caption = 'ABC Analysis Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "GMO ABC Analysis Setup";

    layout
    {
        area(Content)
        {
            group(LicenseInfo)
            {
                Caption = 'License Information';
                field(LicenseStatus; LicenseStatusText)
                {
                    ApplicationArea = All;
                    Caption = 'License Status';
                    Editable = false;
                    ToolTip = 'Shows the current license status for ABC Inventory Optimizer. Active license required to run analysis.';
                    StyleExpr = LicenseStatusStyle;
                }
            }
            group(General)
            {
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable or disable automatic ABC analysis calculations. When enabled, the system will track items for recalculation based on inventory movements.';
                }
                field("A Threshold %"; Rec."A Threshold %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cumulative percentage threshold for Class A items. Items contributing up to this percentage of total value are classified as A. Typical value: 80%.';
                }
                field("B Threshold %"; Rec."B Threshold %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cumulative percentage threshold for Class B items. Items between A and this threshold are Class B, remainder are Class C. Typical value: 95%.';
                }
                field("Lookback (Days)"; Rec."Lookback (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of days to look back when calculating item values and movements. Default is 365 days (one year).';
                }
                field("Include Transfers"; Rec."Include Transfers")
                {
                    ApplicationArea = All;
                    ToolTip = 'Include transfer orders as outbound movements when calculating item activity and consumption patterns.';
                }
                field("Zero Consumption as D"; Rec."Zero Consumption as D")
                {
                    ApplicationArea = All;
                    ToolTip = 'Automatically classify items with zero consumption during the lookback period as Class D (inactive/obsolete).';
                }
                field("Exclude Non-Inventory"; Rec."Exclude Non-Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Exclude non-inventory items (Service, Non-Inventory types) from ABC analysis calculations. Enabled by default.';
                }
                field("Auto Update On Posting"; Rec."Auto Update On Posting")
                {
                    ApplicationArea = All;
                    ToolTip = 'Automatically mark items for recalculation when inventory transactions are posted. Enables real-time ABC classification tracking.';
                }
                field("Commit Batch Size"; Rec."Commit Batch Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of items to process before committing database changes. Smaller values improve responsiveness; larger values improve performance. Default: 500.';
                }
                field("Last Run"; Rec."Last Run")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date and time when the ABC analysis was last executed. Read-only field.';
                }
                field("Last Upgraded To"; Rec."Last Upgraded To")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Version number of the last completed data upgrade. Used for upgrade tracking. Read-only field.';
                }
            }
            group(RevenueModel)
            {
                Caption = 'Revenue ABC Model';
                field(revenueLbl;this.RevenueLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Ranks items by sales amount (net revenue). Good when demand is driven by sales, not internal consumption.';
                }   
                field("Rev A %"; Rec."Rev A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class A threshold percentage for Revenue model. Items contributing up to this cumulative percentage of revenue are Class A. Default: 80%.';
                }
                field("Rev B %"; Rec."Rev B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class B threshold percentage for Revenue model. Items between A and this threshold are Class B. Default: 95%.';
                }
                field("Rev Period (Days)"; Rec."Rev Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of days to analyze when calculating revenue-based ABC classifications. Default: 365 days.';
                }
            }
            group(GrossProfitModel)
            {
                Caption = 'Gross Profit ABC Model';
                field(profitLbl;this.ProfitLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Ranks by gross margin (Sales − Cost) to spotlight profit drivers (A’s) vs low-margin tail (C’s).';
                }
                field("GP A %"; Rec."GP A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class A threshold percentage for Gross Profit model. Items contributing up to this cumulative percentage of profit are Class A. Default: 80%.';
                }
                field("GP B %"; Rec."GP B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class B threshold percentage for Gross Profit model. Items between A and this threshold are Class B. Default: 95%.';
                }
                field("GP Period (Days)"; Rec."GP Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of days to analyze when calculating profit-based ABC classifications. Default: 365 days.';
                }
            }
            group(COGSModel)
            {
                Caption = 'COGS ABC Model (Value / COGS)';

                field(grossLbl;this.GrossLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Ranks your items by their share of total Cost of Goods Sold for a chosen period, then assigns them to ABC categories based on their contribution to overall profitability.';
                }
                field("COGS A %"; Rec."COGS A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class A threshold percentage for Cost of Goods Sold model. Items contributing up to this cumulative percentage of COGS are Class A. Default: 80%.';
                }
                field("COGS B %"; Rec."COGS B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class B threshold percentage for COGS model. Items between A and this threshold are Class B. Default: 95%.';
                }
                field("COGS Period (Days)"; Rec."COGS Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of days to analyze when calculating COGS-based ABC classifications. Default: 365 days.';
                }
            }
            group(UsageValueModel)
            {
                Caption = 'Usage Value ABC Model (Qty × Cost)';

                field(UsageValueLbl;this.UsageValueLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Ranks by usage value (quantity × cost) to highlight high-consumption items that tie up inventory investment. Good for managing working capital and stock levels.';
                }
                field("Usage Value A %"; Rec."Usage Value A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class A threshold percentage for Usage Value model. Items contributing up to this cumulative percentage of usage value are Class A. Default: 80%.';
                }
                field("Usage Value B %"; Rec."Usage Value B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class B threshold percentage for Usage Value model. Items between A and this threshold are Class B. Default: 95%.';
                }
                field("Usage Value Period (Days)"; Rec."Usage Value Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of days to analyze when calculating usage value-based ABC classifications. Default: 365 days.';
                }
            }
            group(GMROIIModel)
            {
                Caption = 'GMROII ABC Model';

                field(GMROIILbl;this.GMROIILbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Ranks by Gross Margin Return on Inventory Investment (GMROII = Margin / Average Inventory Value) to spotlight items that generate the highest return on your inventory investment. Ideal when working capital is tight.';
                }
                field("GMROII A %"; Rec."GMROII A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class A threshold percentage for GMROII (Gross Margin Return on Inventory Investment) model. Items ranked by Margin / Average Inventory Value contributing up to this cumulative percentage are Class A. Ideal when working capital is tight. Default: 80%.';
                }
                field("GMROII B %"; Rec."GMROII B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class B threshold percentage for GMROII model. Items between A and this threshold are Class B. Default: 95%.';
                }
                field("GMROII Period (Days)"; Rec."GMROII Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of days to analyze when calculating GMROII-based ABC classifications. Period margin from Value Entries; average inventory value via Inventory Valuation / Item Ledger. Default: 365 days.';
                }
            }
            group(PickFrequencyModel)
            {
                Caption = 'Pick-Frequency ABC Model';
                field(pickFreqLbl;this.PickFreqLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Ranks by number of picks/issues (not value) to optimize warehouse slotting (fast pick lines near dispatch).';
                }   
                field("Pick Freq A %"; Rec."Pick Freq A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class A threshold percentage for Pick-Frequency model. Items ranked by number of picks/issues (not value) contributing up to this cumulative percentage are Class A. Great for warehouse slotting (fast pick lines near dispatch). Default: 80%.';
                }
                field("Pick Freq B %"; Rec."Pick Freq B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Class B threshold percentage for Pick-Frequency model. Items between A and this threshold are Class B. Default: 95%.';
                }
                field("Pick Freq Period (Days)"; Rec."Pick Freq Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of days to analyze when calculating pick frequency-based ABC classifications. Count issue/pick lines from Warehouse/Item Ledger (Sales & Consumption counts). Default: 365 days.';
                }
            }
            group(CountingPolicy)
            {
                Caption = 'Counting Policy';
                field("Update Counting Codes"; Rec."Update Counting Codes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Automatically update physical inventory counting period codes on items based on their ABC classification.';
                }
                field("Update SKU"; Rec."Update SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Apply counting period updates to Stock Keeping Units (SKU) in addition to items. Only applies when Update Counting Codes is enabled.';
                }
                field("Counting Code Mapping ID"; Rec."Counting Code Mapping ID")
                {
                    ApplicationArea = All;
                    Caption = 'Counting Code Mapping ID';
                    TableRelation = "GMO ABC Counting Policy Header".Code;
                    ToolTip = 'Select the counting policy that defines how ABC classifications map to physical inventory counting frequencies.';

                    trigger OnAssistEdit()
                    var
                        H: Record "GMO ABC Counting Policy Header";
                    begin
                        // Ensure a code is present
                        if Rec."Counting Code Mapping ID" = '' then begin
                            Rec.Validate("Counting Code Mapping ID", 'DEFAULT');
                            Rec.Modify(true);
                        end;

                        // Create header if missing (idempotent)
                        if not H.Get(Rec."Counting Code Mapping ID") then begin
                            H.Init();
                            H.Code := Rec."Counting Code Mapping ID";
                            H.Description := 'Default ABC → Counting Period mapping';
                            H.Insert(true);
                        end;

                        // Open the policy card
                        PAGE.RunModal(PAGE::"GMO ABC Counting Policy Card", H);
                    end;

                    // (Optional) Proper lookup to choose a different mapping
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        H: Record "GMO ABC Counting Policy Header";
                    begin
                        if PAGE.RunModal(PAGE::"GMO ABC Counting Policy Card", H) = ACTION::LookupOK then begin
                            Rec.Validate("Counting Code Mapping ID", H.Code);
                            Rec.Modify(true);
                            exit(true);
                        end;
                        exit(false);
                    end;

                    // (Optional) Auto-create when user types a new code and leaves the field
                    trigger OnValidate()
                    var
                        H: Record "GMO ABC Counting Policy Header";
                    begin
                        if Rec."Counting Code Mapping ID" = '' then
                            exit;

                        if not H.Get(Rec."Counting Code Mapping ID") then begin
                            H.Init();
                            H.Code := Rec."Counting Code Mapping ID";
                            H.Description := StrSubstNo(CountingPolicyDescLbl, H.Code);
                            H.Insert(true);
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FillDefaultThresholds)
            {
                Caption = 'Fill Default Thresholds';
                Image = SuggestField;
                ApplicationArea = All;
                ToolTip = 'Fill all model thresholds with default values (A: 80%, B: 95%) for all ABC models.';
                trigger OnAction()
                begin
                    FillAllThresholds();
                end;
            }
            action(OpenWorksheet)
            {
                Caption = 'Open ABC Worksheet';
                Image = Worksheet;
                ApplicationArea = All;
                ToolTip = 'Open the ABC Analysis Worksheet to calculate and preview classifications before committing results.';
                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"GMO ABC Worksheet");
                end;
            }
            action(OpenReport)
            {
                Caption = 'Run ABC Analysis Report';
                Image = Report;
                ApplicationArea = All;
                ToolTip = 'Generate a detailed report showing ABC classification results and statistical distribution.';
                trigger OnAction()
                begin
                    Report.RunModal(Report::"GMO ABC Analysis");
                end;
            }
            action(CreateJobQueue)
            {
                Caption = 'Create/Enable Job Queue';
                Image = Job;
                ApplicationArea = All;
                ToolTip = 'Create or enable the job queue entry for automated ABC analysis calculations on a scheduled basis.';
                trigger OnAction()
                var
                    Helper: Codeunit "GMO ABC Job Queue Helper";
                begin
                    Helper.CreateOrEnableJob();
                end;
            }
            action(OpenHistory)
            {
                Caption = 'Open ABC History';
                Image = History;
                ApplicationArea = All;
                ToolTip = 'View historical ABC analysis runs and their results to track classification changes over time.';
                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"GMO ABC History");
                end;
            }
            action(OpenCountingPolicy)
            {
                Caption = 'Open Counting Policy';
                ApplicationArea = All;
                Image = Setup;
                ToolTip = 'Opens the Counting Policy Card for the selected Counting Code Mapping ID.';
                trigger OnAction()
                var
                    H: Record "GMO ABC Counting Policy Header";
                begin
                    if Rec."Counting Code Mapping ID" = '' then
                        Error('Select a Counting Code Mapping ID first.');
                    H.Get(Rec."Counting Code Mapping ID");
                    Page.Run(Page::"GMO ABC Counting Policy Card", H);
                end;
            }
        }
    }

    var
        LicenseMgt: Codeunit "GMO ABC License Mgt.";
        LicenseStatusText: Text[50];
        LicenseStatusStyle: Text;
        CountingPolicyDescLbl: Label '%1 ABC → Counting Period mapping', Locked = true;
        RevenueLbl: Label 'Ranks items by sales amount (net revenue). Good when demand is driven by sales, not internal consumption. BC data: Value Entries or Sales Shipment/Invoice lines → Sales Amount (Actual).', Locked = true;
        ProfitLbl: Label 'Ranks by gross margin (Sales − Cost) to spotlight profit drivers (A''s) vs low-margin tail (C''s).BC data: Value Entries → Sales Amount (Actual) minus Cost Amount (Actual).', Locked = true;
        GrossLbl: Label 'Ranks your items by their share of total Cost of Goods Sold for a chosen period, then assigns them to ABC categories based on their contribution to overall profitability.', Locked = true;
        PickFreqLbl: Label 'Ranks by number of picks/issues (not value) to optimize warehouse slotting (fast pick lines near dispatch). BC data: Item Ledger or Warehouse Entries → count of issues/picks.', Locked = true;
        GMROIILbl: Label 'Ranks by Gross Margin Return on Inventory Investment (GMROII = Margin / Average Inventory Value) to spotlight items that generate the highest return on your inventory investment. Ideal when working capital is tight. BC data: Value Entries → Margin (Sales Amount (Actual) minus Cost Amount (Actual)); Average Inventory Value via Inventory Valuation / Item Ledger.', Locked = true;
        UsageValueLbl: Label 'Ranks by usage value (quantity × cost) to highlight high-consumption items that tie up inventory investment. Good for managing working capital and stock levels. BC data: Value Entries or Item Ledger → Quantity × Cost Amount (Actual).', Locked = true;

    local procedure FillAllThresholds()
    begin
        // Fill General thresholds
        Rec."A Threshold %" := 80;
        Rec."B Threshold %" := 95;

        // Fill Revenue model thresholds
        Rec."Rev A %" := 80;
        Rec."Rev B %" := 95;
        Rec."Rev Period (Days)" := 365;

        // Fill Gross Profit model thresholds
        Rec."GP A %" := 80;
        Rec."GP B %" := 95;
        Rec."GP Period (Days)" := 365;

        // Fill COGS model thresholds
        Rec."COGS A %" := 80;
        Rec."COGS B %" := 95;
        Rec."COGS Period (Days)" := 365;

        // Fill Usage Value model thresholds
        Rec."Usage Value A %" := 80;
        Rec."Usage Value B %" := 95;
        Rec."Usage Value Period (Days)" := 365;

        // Fill GMROII model thresholds
        Rec."GMROII A %" := 80;
        Rec."GMROII B %" := 95;
        Rec."GMROII Period (Days)" := 365;

        // Fill Pick Frequency model thresholds
        Rec."Pick Freq A %" := 80;
        Rec."Pick Freq B %" := 95;
        Rec."Pick Freq Period (Days)" := 365;

        Rec.Modify(true);
        Message('All threshold values have been filled with default values (A: 80%%, B: 95%%, Period: 365 days).');
    end;


    trigger OnOpenPage()
    var
        Mgt: Codeunit "GMO ABC Analysis Mgt.";
    begin
        // Update license status display
        UpdateLicenseStatus();

        // Note: No license check here - users should be able to view setup even without license
        // License is checked when running calculations or applying classifications

        // (your existing setup seeding) ...
        Rec.Get('SETUP');

        if Rec."Counting Code Mapping ID" = '' then begin
            Rec.Validate("Counting Code Mapping ID", 'DEFAULT');
            Rec.Modify(true);
        end;

        Mgt.EnsurePolicyExists(Rec."Counting Code Mapping ID");
    end;

    local procedure UpdateLicenseStatus()
    begin
        LicenseStatusText := LicenseMgt.GetLicenseStatusText();

        if LicenseMgt.HasValidLicense() then
            LicenseStatusStyle := 'Favorable'
        else
            LicenseStatusStyle := 'Unfavorable';
    end;
}