permissionset 73030578 "GMO ABC USER"
{
    Assignable = true;
    Caption = 'ABC Inventory Optimizer - User';

    Permissions =
        // Tables (metadata)
        table "GMO ABC Analysis Setup" = X,
        table "GMO ABC Counting Policy Header" = X,
        table "GMO ABC Counting Policy Line" = X,
        table "GMO ABC History Header" = X,
        table "GMO ABC History Line" = X,
        table "GMO ABC Stats" = X,
        table "GMO ABC Preview Line" = X,

        // Tables (data) - Read only for setup and history, modify for working tables
        tabledata "GMO ABC Analysis Setup" = R,
        tabledata "GMO ABC Counting Policy Header" = R,
        tabledata "GMO ABC Counting Policy Line" = R,
        tabledata "GMO ABC History Header" = R,
        tabledata "GMO ABC History Line" = R,
        tabledata "GMO ABC Stats" = RIMD,
        tabledata "GMO ABC Preview Line" = RIMD,

        // Pages - Limited access
        page "GMO ABC Analysis Setup" = X,
        page "GMO ABC Worksheet Params" = X,
        page "GMO ABC Stats Part" = X,
        page "GMO ABC Worksheet" = X,
        page "GMO ABC History" = X,
        page "GMO ABC History Lines" = X,
        page "GMO ABC History Card" = X,
        page "GMO ABC Counting Policy List" = X,
        page "GMO ABC Counting Policy Card" = X,
        page "GMO ABC Count Policy Subform" = X,

        // Reports - Read access only
        report "GMO ABC Analysis" = X,
        report "GMO ABC Distribution" = X,
        report "GMO ABC Item Movement" = X,
        report "GMO ABC Detail by Class" = X,
        report "GMO ABC Exceptions" = X,
        report "GMO ABC Comparison" = X,

        // Codeunits - Limited access
        codeunit "GMO ABC Analysis Mgt." = X,
        codeunit "GMO ABC Worksheet Stats" = X,
        codeunit "GMO ABC Worksheet Export" = X;
}
