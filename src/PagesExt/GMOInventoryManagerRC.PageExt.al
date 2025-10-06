pageextension 73030577 "GMO ABC Inventory Manager RC" extends "Whse. Basic Role Center"
{
    actions
    {
        addlast(sections)
        {
            group("GMO ABC Analysis")
            {
                Caption = 'GMO ABC Analysis';
                Image = AnalysisView;

                action("GMO ABC Worksheet")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Worksheet';
                    ToolTip = 'Calculate and preview ABC classifications.';
                    RunObject = page "GMO ABC Worksheet";
                    Image = Worksheet;
                }

                action("GMO ABC Setup")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Setup';
                    ToolTip = 'Configure ABC analysis parameters and thresholds.';
                    RunObject = page "GMO ABC Analysis Setup";
                    Image = Setup;
                }

                action("GMO ABC History")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC History';
                    ToolTip = 'View historical ABC calculations.';
                    RunObject = page "GMO ABC History";
                    Image = History;
                }

                action("GMO ABC Counting Policy")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Counting Policies';
                    ToolTip = 'Configure physical inventory counting policies by ABC class.';
                    RunObject = page "GMO ABC Counting Policy List";
                    Image = CountingPeriod;
                }
            }
        }

        addlast(reporting)
        {
            group("GMO ABC Reports")
            {
                Caption = 'GMO ABC Reports';
                Image = "Report";

                action("GMO ABC Analysis Report")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Analysis Report';
                    ToolTip = 'Print detailed ABC analysis report.';
                    RunObject = report "GMO ABC Analysis";
                    Image = Report;
                }

                action("GMO ABC Distribution Report")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Distribution Report';
                    ToolTip = 'View distribution of items across ABC classes.';
                    RunObject = report "GMO ABC Distribution";
                    Image = DistributionChart;
                }

                action("GMO ABC Movement Report")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Movement Report';
                    ToolTip = 'Show items that changed ABC class between periods.';
                    RunObject = report "GMO ABC Item Movement";
                    Image = ItemTracking;
                }

                action("GMO ABC Detail Report")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Detail by Class';
                    ToolTip = 'Detailed report filtered by ABC class.';
                    RunObject = report "GMO ABC Detail by Class";
                    Image = ViewDetails;
                }

                action("GMO ABC Exceptions Report")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Exceptions Report';
                    ToolTip = 'Identify items with classification issues.';
                    RunObject = report "GMO ABC Exceptions";
                    Image = ErrorLog;
                }

                action("GMO ABC Comparison Report")
                {
                    ApplicationArea = All;
                    Caption = 'GMO ABC Multi-Model Comparison';
                    ToolTip = 'Compare ABC classifications across all models.';
                    RunObject = report "GMO ABC Comparison";
                    Image = CompareCOA;
                }
            }
        }
    }
}