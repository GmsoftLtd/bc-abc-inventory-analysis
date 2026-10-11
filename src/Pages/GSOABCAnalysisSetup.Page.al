page 73033670 "GSO ABC Analysis Setup"
{
    ContextSensitiveHelpPage = 'setup';
    Caption = 'ABC Analysis Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "GSO ABC Analysis Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the scheduled job queue recalculation runs. Calculations started from the worksheet are always available.';
                }
                field("Zero Consumption as D"; Rec."Zero Consumption as D")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that items without any value in the analysis period are classified as D instead of being left out. This keeps the class of inactive items up to date.';
                }
                field("Exclude Non-Inventory"; Rec."Exclude Non-Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that items of type Service and Non-Inventory are skipped by the analysis.';
                }
                field("Last Run"; Rec."Last Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when classes were last applied to items.';
                }
                field("Last Upgraded To"; Rec."Last Upgraded To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the version of the app that created or last upgraded this setup.';
                }
            }
            group(RevenueModel)
            {
                Caption = 'Revenue ABC Model';
                field(RevenueDescription; RevenueLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how the Revenue model ranks items.';
                }
                field("Rev A %"; Rec."Rev A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative revenue share up to which items are class A. Default: 80%.';
                }
                field("Rev B %"; Rec."Rev B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative revenue share up to which items are class B. Items above it are class C. Default: 95%.';
                }
                field("Rev Period (Days)"; Rec."Rev Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days back from the work date the Revenue model analyzes. Default: 365.';
                }
            }
            group(GrossProfitModel)
            {
                Caption = 'Gross Profit ABC Model';
                field(ProfitDescription; ProfitLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how the Gross Profit model ranks items.';
                }
                field("GP A %"; Rec."GP A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative gross profit share up to which items are class A. Default: 80%.';
                }
                field("GP B %"; Rec."GP B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative gross profit share up to which items are class B. Items above it are class C. Default: 95%.';
                }
                field("GP Period (Days)"; Rec."GP Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days back from the work date the Gross Profit model analyzes. Default: 365.';
                }
            }
            group(COGSModel)
            {
                Caption = 'COGS ABC Model (Value / COGS)';
                field(COGSDescription; COGSLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how the COGS model ranks items.';
                }
                field("COGS A %"; Rec."COGS A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative cost of goods sold share up to which items are class A. Default: 80%.';
                }
                field("COGS B %"; Rec."COGS B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative cost of goods sold share up to which items are class B. Items above it are class C. Default: 95%.';
                }
                field("COGS Period (Days)"; Rec."COGS Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days back from the work date the COGS model analyzes. Default: 365.';
                }
            }
            group(UsageValueModel)
            {
                Caption = 'Usage Value ABC Model (Qty × Cost)';
                field(UsageValueDescription; UsageValueLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how the Usage Value model ranks items.';
                }
                field("Usage Value A %"; Rec."Usage Value A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative usage value share up to which items are class A. Default: 80%.';
                }
                field("Usage Value B %"; Rec."Usage Value B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative usage value share up to which items are class B. Items above it are class C. Default: 95%.';
                }
                field("Usage Value Period (Days)"; Rec."Usage Value Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days back from the work date the Usage Value model analyzes. Default: 365.';
                }
            }
            group(GMROIIModel)
            {
                Caption = 'GMROII ABC Model';
                field(GMROIIDescription; GMROIILbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how the GMROII model ranks items.';
                }
                field("GMROII A %"; Rec."GMROII A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative GMROII share up to which items are class A. Default: 80%.';
                }
                field("GMROII B %"; Rec."GMROII B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative GMROII share up to which items are class B. Items above it are class C. Default: 95%.';
                }
                field("GMROII Period (Days)"; Rec."GMROII Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days back from the work date the GMROII model analyzes. Default: 365.';
                }
            }
            group(PickFrequencyModel)
            {
                Caption = 'Pick-Frequency ABC Model';
                field(PickFreqDescription; PickFreqLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how the Pick Frequency model ranks items.';
                }
                field("Pick Freq A %"; Rec."Pick Freq A %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative pick count share up to which items are class A. Default: 80%.';
                }
                field("Pick Freq B %"; Rec."Pick Freq B %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative pick count share up to which items are class B. Items above it are class C. Default: 95%.';
                }
                field("Pick Freq Period (Days)"; Rec."Pick Freq Period (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days back from the work date the Pick Frequency model analyzes. Default: 365.';
                }
            }
            group(CountingPolicy)
            {
                Caption = 'Counting Policy';
                field("Update Counting Codes"; Rec."Update Counting Codes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that applying classes also sets the physical inventory counting period code on items, according to the selected counting policy.';
                }
                field("Update SKU"; Rec."Update SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the counting period code is also set on stockkeeping units. Only applies when Update Phys. Invt. Counting Codes is enabled.';
                }
                field("Counting Code Mapping ID"; Rec."Counting Code Mapping ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the counting policy that maps each model and class to a physical inventory counting period. Typing a new code creates the policy.';

                    trigger OnAssistEdit()
                    var
                        PolicyHeader: Record "GSO ABC Counting Policy Header";
                    begin
                        if Rec."Counting Code Mapping ID" = '' then begin
                            Rec.Validate("Counting Code Mapping ID", DefaultPolicyTok);
                            Rec.Modify(true);
                        end;
                        Mgt.EnsurePolicyExists(Rec."Counting Code Mapping ID");
                        PolicyHeader.Get(Rec."Counting Code Mapping ID");
                        Page.RunModal(Page::"GSO ABC Counting Policy Card", PolicyHeader);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PolicyHeader: Record "GSO ABC Counting Policy Header";
                        PolicyList: Page "GSO ABC Counting Policy List";
                    begin
                        PolicyList.LookupMode(true);
                        if PolicyList.RunModal() <> Action::LookupOK then
                            exit(false);
                        PolicyList.GetRecord(PolicyHeader);
                        Text := PolicyHeader.Code;
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        Mgt.EnsurePolicyExists(Rec."Counting Code Mapping ID");
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
                Caption = 'ABC Worksheet';
                Image = Worksheet;
                ApplicationArea = All;
                ToolTip = 'Open the worksheet to calculate and preview classes before applying them.';
                RunObject = page "GSO ABC Worksheet";
            }
            action(OpenHistory)
            {
                Caption = 'ABC History';
                Image = History;
                ApplicationArea = All;
                ToolTip = 'View previous runs and their item-level results.';
                RunObject = page "GSO ABC History";
            }
            action(OpenCountingPolicy)
            {
                Caption = 'Counting Policy';
                ApplicationArea = All;
                Image = Setup;
                ToolTip = 'Open the counting policy selected in Counting Policy Code.';
                trigger OnAction()
                var
                    PolicyHeader: Record "GSO ABC Counting Policy Header";
                begin
                    if Rec."Counting Code Mapping ID" = '' then
                        Error(SelectPolicyErr);
                    Mgt.EnsurePolicyExists(Rec."Counting Code Mapping ID");
                    PolicyHeader.Get(Rec."Counting Code Mapping ID");
                    Page.Run(Page::"GSO ABC Counting Policy Card", PolicyHeader);
                end;
            }
            action(OpenReport)
            {
                Caption = 'ABC Analysis Report';
                Image = Report;
                ApplicationArea = All;
                ToolTip = 'Print the ranked item list for one model and period.';
                RunObject = report "GSO ABC Analysis";
            }
            action(CreateJobQueue)
            {
                Caption = 'Create/Enable Job Queue';
                Image = Job;
                ApplicationArea = All;
                ToolTip = 'Create or enable a daily job queue entry that recalculates and applies all models.';
                trigger OnAction()
                var
                    Helper: Codeunit "GSO ABC Job Queue Helper";
                begin
                    Helper.CreateOrEnableJob();
                end;
            }
            action(FillDefaultThresholds)
            {
                Caption = 'Reset Thresholds to Defaults';
                Image = SuggestField;
                ApplicationArea = All;
                ToolTip = 'Set every model to A: 80%, B: 95% and a 365 day period.';
                trigger OnAction()
                begin
                    FillAllThresholds();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(OpenWorksheet_Promoted; OpenWorksheet) { }
                actionref(OpenHistory_Promoted; OpenHistory) { }
                actionref(OpenCountingPolicy_Promoted; OpenCountingPolicy) { }
                actionref(CreateJobQueue_Promoted; CreateJobQueue) { }
            }
        }
    }

    var
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        DefaultPolicyTok: Label 'DEFAULT', Locked = true;
        SelectPolicyErr: Label 'Select a Counting Policy Code first.';
        DefaultsFilledMsg: Label 'All thresholds were reset to the defaults (A: 80%, B: 95%, period: 365 days).';
        RevenueLbl: Label 'Ranks items by net sales amount. Good when demand is driven by sales rather than internal consumption. Source: Value Entries, Sales Amount (Actual).';
        ProfitLbl: Label 'Ranks items by gross margin (sales minus cost) to spotlight profit drivers. Source: Value Entries, Sales Amount (Actual) plus Cost Amount (Actual) on sales.';
        COGSLbl: Label 'Ranks items by their share of cost of goods sold in the period. Source: Value Entries, outbound Cost Amount (Actual) on sales, consumption and negative adjustments.';
        UsageValueLbl: Label 'Ranks items by usage value (quantity consumed times cost) to highlight the items that tie up the most working capital. Source: Value Entries, Cost Amount (Actual).';
        GMROIILbl: Label 'Ranks items by Gross Margin Return on Inventory Investment: period margin divided by current inventory value. Useful when working capital is tight.';
        PickFreqLbl: Label 'Ranks items by the number of pick and issue transactions, not value. Useful for warehouse slotting. Source: Item Ledger Entries of type Sale and Consumption.';

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if Rec.WritePermission() then begin
            Mgt.EnsureSetup(Rec);
            if Rec."Counting Code Mapping ID" = '' then begin
                Rec."Counting Code Mapping ID" := DefaultPolicyTok;
                Rec.Modify(true);
            end;
            Mgt.EnsurePolicyExists(Rec."Counting Code Mapping ID");
        end else
            Mgt.GetSetup(Rec);
    end;

    local procedure FillAllThresholds()
    begin
        Rec."Rev A %" := 80;
        Rec."Rev B %" := 95;
        Rec."Rev Period (Days)" := 365;
        Rec."GP A %" := 80;
        Rec."GP B %" := 95;
        Rec."GP Period (Days)" := 365;
        Rec."COGS A %" := 80;
        Rec."COGS B %" := 95;
        Rec."COGS Period (Days)" := 365;
        Rec."Usage Value A %" := 80;
        Rec."Usage Value B %" := 95;
        Rec."Usage Value Period (Days)" := 365;
        Rec."GMROII A %" := 80;
        Rec."GMROII B %" := 95;
        Rec."GMROII Period (Days)" := 365;
        Rec."Pick Freq A %" := 80;
        Rec."Pick Freq B %" := 95;
        Rec."Pick Freq Period (Days)" := 365;
        Rec.Modify(true);
        Message(DefaultsFilledMsg);
    end;
}
