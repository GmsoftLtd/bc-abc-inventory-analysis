namespace GMSoft.ABCInventoryAnalysis;

using Microsoft.Warehouse.RoleCenters;

pageextension 73033672 "GSO ABC Inventory Manager RC" extends "Whse. Basic Role Center"
{
    actions
    {
        addlast(sections)
        {
            group("GSO ABC Analysis")
            {
                Caption = 'ABC Inventory';
                Image = AnalysisView;

                action("GSO ABC Worksheet")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Worksheet';
                    ToolTip = 'Calculate and preview ABC classifications.';
                    RunObject = page "GSO ABC Worksheet";
                    Image = Worksheet;
                }

                action("GSO ABC Setup")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Setup';
                    ToolTip = 'Configure ABC analysis parameters and thresholds.';
                    RunObject = page "GSO ABC Analysis Setup";
                    Image = Setup;
                }

                action("GSO ABC History")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - History';
                    ToolTip = 'View historical ABC calculations.';
                    RunObject = page "GSO ABC History";
                    Image = History;
                }

                action("GSO ABC Counting Policy")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Counting Policies';
                    ToolTip = 'Configure physical inventory counting policies by ABC class.';
                    RunObject = page "GSO ABC Counting Policy List";
                    Image = Period;
                }
            }
        }

        addlast(reporting)
        {
            group("GSO ABC Reports")
            {
                Caption = 'ABC Inventory - Reports';
                Image = "Report";

                action("GSO ABC Analysis Report")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Analysis Report';
                    ToolTip = 'Print detailed ABC analysis report.';
                    RunObject = report "GSO ABC Analysis";
                    Image = Report;
                }

                action("GSO ABC Distribution Report")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Distribution Report';
                    ToolTip = 'View distribution of items across ABC classes.';
                    RunObject = report "GSO ABC Distribution";
                    Image = ShowChart;
                }

                action("GSO ABC Movement Report")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Movement Report';
                    ToolTip = 'Show items that changed ABC class between periods.';
                    RunObject = report "GSO ABC Item Movement";
                    Image = ItemTracking;
                }

                action("GSO ABC Detail Report")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Detail by Class';
                    ToolTip = 'Detailed report filtered by ABC class.';
                    RunObject = report "GSO ABC Detail by Class";
                    Image = ViewDetails;
                }

                action("GSO ABC Exceptions Report")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Exceptions Report';
                    ToolTip = 'Identify items with classification issues.';
                    RunObject = report "GSO ABC Exceptions";
                    Image = ErrorLog;
                }

                action("GSO ABC Comparison Report")
                {
                    ApplicationArea = All;
                    Caption = 'ABC Inventory - Multi-Model Comparison';
                    ToolTip = 'Compare ABC classifications across all models.';
                    RunObject = report "GSO ABC Comparison";
                    Image = CompareCOA;
                }
            }
        }
    }
}