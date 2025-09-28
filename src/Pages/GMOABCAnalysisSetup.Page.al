page 73030578 "GMO ABC Analysis Setup"
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
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
                field("A Threshold %"; Rec."A Threshold %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the A Threshold % (Cumulative) field.';
                }
                field("B Threshold %"; Rec."B Threshold %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the B Threshold % (Cumulative) field.';
                }
                field("Lookback (Days)"; Rec."Lookback (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lookback (Days) field.';
                }
                field("Include Transfers"; Rec."Include Transfers")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Include Transfers as Outbound field.';
                }
                field("Zero Consumption as D"; Rec."Zero Consumption as D")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class Zero Consumption as D field.';
                }
                field("Exclude Non-Inventory"; Rec."Exclude Non-Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exclude Non-Inventory Items field.';
                }
                field("Auto Update On Posting"; Rec."Auto Update On Posting")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mark Items for Recalc on Posting field.';
                }
                field("Commit Batch Size"; Rec."Commit Batch Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Commit Batch Size field.';
                }
                field("Last Run"; Rec."Last Run")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Run field.';
                }
                field("Last Upgraded To"; Rec."Last Upgraded To")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Upgraded To Version field.';
                }
            }
            group(ModelThresholds)
            {
                Caption = 'Model Thresholds & Periods';
                field("Rev A %"; Rec."Rev A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Revenue A Threshold % field.';
                }
                field("Rev B %"; Rec."Rev B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Revenue B Threshold % field.';
                }
                field("Rev Period (Days)"; Rec."Rev Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Revenue Period (Days) field.';
                }
                field("GP A %"; Rec."GP A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gross Profit A Threshold % field.';
                }
                field("GP B %"; Rec."GP B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gross Profit B Threshold % field.';
                }
                field("GP Period (Days)"; Rec."GP Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gross Profit Period (Days) field.';
                }
                field("COGS A %"; Rec."COGS A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the COGS A Threshold % field.';
                }
                field("COGS B %"; Rec."COGS B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the COGS B Threshold % field.';
                }
                field("COGS Period (Days)"; Rec."COGS Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the COGS Period (Days) field.';
                }
            }
            group(CountingPolicy)
            {
                Caption = 'Counting Policy';
                field("Update Counting Codes"; Rec."Update Counting Codes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Update Warehouse Counting Codes field.';
                }
                field("Update SKU"; Rec."Update SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Update SKU as well field.';
                }
                field("Counting Code Mapping ID"; Rec."Counting Code Mapping ID")
                {
                    ApplicationArea = All;
                    Caption = 'Counting Code Mapping ID';
                    TableRelation = "GMO ABC Counting Policy Header".Code;
                    ToolTip = 'Specifies the value of the Counting Code Mapping ID field.';

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
                            H.Description := StrSubstNo('%1 ABC → Counting Period mapping', H.Code);
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
                ToolTip = 'Executes the Open ABC Worksheet action.';
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
                ToolTip = 'Executes the Run ABC Analysis Report action.';
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
                ToolTip = 'Executes the Create/Enable Job Queue action.';
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
                ToolTip = 'Executes the Open ABC History action.';
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

    trigger OnOpenPage()
    var
        Mgt: Codeunit "GMO ABC Analysis Mgt.";
    begin
        if not Rec.Get('SETUP') then begin
            // (your existing setup seeding) ...
        end;

        if Rec."Counting Code Mapping ID" = '' then begin
            Rec.Validate("Counting Code Mapping ID", 'DEFAULT');
            Rec.Modify(true);
        end;

        Mgt.EnsurePolicyExists(Rec."Counting Code Mapping ID");
    end;
}