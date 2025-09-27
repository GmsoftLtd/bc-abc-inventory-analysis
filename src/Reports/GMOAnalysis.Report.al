report 73030587 "GMO Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'ABC Analysis';
    RDLCLayout = './src/reports/GMOAnalysis.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("GMO Class (COGS)") order(ascending);
            RequestFilterFields = "No.", "GMO Class (Revenue)", "GMO Class (Gross Profit)", "GMO Class (COGS)";

            column(No_; "No.") { }
            column(Description; Description) { }
            column(ClassRevenue; "GMO Class (Revenue)") { }
            column(ClassGP; "GMO Class (Gross Profit)") { }
            column(ClassCOGS; "GMO Class (COGS)") { }
            column(LastRev; "GMO Last Calc (Revenue)") { }
            column(LastGP; "GMO Last Calc (GP)") { }
            column(LastCOGS; "GMO Last Calc (COGS)") { }
        }
    }
}