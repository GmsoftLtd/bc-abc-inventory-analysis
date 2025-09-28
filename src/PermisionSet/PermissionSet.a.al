permissionset 73030590 "GMO ABC MANAGER"
{
    Caption = 'GMO ABC Manager';
    Assignable = true;

    // Include Microsoft base role
    //IncludedPermissionSets = "D365 INV DOC, CREATE","D365 INV DOC, POST","D365 IC, SETUP"

    Permissions =
        // Tables (metadata)
        table "GMO ABC Preview Line" = X,
        table "GMO ABC Stats" = X,
        table "GMO ABC Counting Policy Header" = X,
        table "GMO ABC Counting Policy Line" = X,
        table "GMO ABC Analysis Setup" = X,

        // Tables (data)
        tabledata "GMO ABC Preview Line" = RIMD,
        tabledata "GMO ABC Stats" = RIMD,
        tabledata "GMO ABC Counting Policy Header" = RIMD,
        tabledata "GMO ABC Counting Policy Line" = RIMD,
        tabledata "GMO ABC Analysis Setup" = RIMD,

        // Pages
        page "GMO ABC Worksheet" = X,
        page "GMO ABC Worksheet Params" = X,
        page "GMO ABC Stats Part" = X,
        page "GMO ABC Analysis Setup" = X,
        page "GMO ABC Counting Policy Card" = X,
        page "GMO ABC Counting Policy List" = X,

        // Report
        report "GMO ABC Analysis" = X,

        // Codeunits
        codeunit "GMO ABC Analysis Mgt." = X,
        codeunit "GMO ABC Worksheet Stats" = X;
}
