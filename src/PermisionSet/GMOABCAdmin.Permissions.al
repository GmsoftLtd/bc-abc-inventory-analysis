permissionset 73030577 "GMO ABC ADMIN"
{
    Assignable = true;
    Caption = 'GMO ABC Administrator';

    Permissions =
        // Tables (metadata)
        table "GMO ABC Upgrade Tag" = X,
        table "GMO ABC Analysis Setup" = X,
        table "GMO ABC Counting Policy Header" = X,
        table "GMO ABC Counting Policy Line" = X,
        table "GMO ABC History Header" = X,
        table "GMO ABC History Line" = X,
        table "GMO ABC Stats" = X,
        table "GMO ABC Preview Line" = X,

        // Tables (data) - Full RIMD permissions
        tabledata "GMO ABC Upgrade Tag" = RIMD,
        tabledata "GMO ABC Analysis Setup" = RIMD,
        tabledata "GMO ABC Counting Policy Header" = RIMD,
        tabledata "GMO ABC Counting Policy Line" = RIMD,
        tabledata "GMO ABC History Header" = RIMD,
        tabledata "GMO ABC History Line" = RIMD,
        tabledata "GMO ABC Stats" = RIMD,
        tabledata "GMO ABC Preview Line" = RIMD,

        // Pages - Full access
        page "GMO ABC Analysis Setup" = X,
        page "GMO ABC Worksheet Params" = X,
        page "GMO ABC Stats Part" = X,
        page "GMO ABC Worksheet" = X,
        page "GMO ABC History" = X,
        page "GMO ABC History Lines" = X,
        page "GMO ABC History Card" = X,
        page "GMO ABC Counting Policy List" = X,
        page "GMO ABC Counting Policy Card" = X,
        page "GMO ABC Counting Policy Lines" = X,
        page "GMO ABC Count Policy Subform" = X,

        // Reports - Full access
        report "GMO ABC Analysis" = X,
        report "GMO ABC Distribution" = X,
        report "GMO ABC Item Movement" = X,
        report "GMO ABC Detail by Class" = X,
        report "GMO ABC Exceptions" = X,
        report "GMO ABC Comparison" = X,

        // Codeunits - Full access
        codeunit "GMO ABC Analysis Mgt." = X,
        codeunit "GMO ABC Analysis Job" = X,
        codeunit "GMO ABC Install" = X,
        codeunit "GMO ABC Upgrade Helper" = X,
        codeunit "GMO ABC Upgrade" = X,
        codeunit "GMO ABC Upgrade Helper v2" = X,
        codeunit "GMO ABC Upgrade v2" = X,
        codeunit "GMO ABC Job Queue Helper" = X,
        codeunit "GMO ABC Telemetry" = X,
        codeunit "GMO ABC Worksheet Stats" = X,
        codeunit "GMO ABC Worksheet Export" = X;
}
