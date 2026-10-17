namespace GMSoft.ABCInventoryAnalysis;

using Microsoft.Sales.RoleCenters;

pageextension 73033675 "GSO ABC Order Processor RC" extends "Order Processor Role Center"
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
            }
        }
    }
}
