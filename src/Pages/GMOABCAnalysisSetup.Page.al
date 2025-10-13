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
            group(ModelThresholds)
            {
                Caption = 'Model Thresholds & Periods';
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
        CountingPolicyDescLbl: Label '%1 ABC → Counting Period mapping', Locked = true;

    trigger OnOpenPage()
    var
        Mgt: Codeunit "GMO ABC Analysis Mgt.";
    begin
        // (your existing setup seeding) ...
        Rec.Get('SETUP');

        if Rec."Counting Code Mapping ID" = '' then begin
            Rec.Validate("Counting Code Mapping ID", 'DEFAULT');
            Rec.Modify(true);
        end;

        Mgt.EnsurePolicyExists(Rec."Counting Code Mapping ID");
    end;
}