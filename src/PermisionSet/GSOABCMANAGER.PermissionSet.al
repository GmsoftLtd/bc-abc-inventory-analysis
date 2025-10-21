permissionset 73030576 "GSO ABC MANAGER"
{
    Caption = 'ABC Inventory - Manager';
    Assignable = true;

    // Include Microsoft base role
    //IncludedPermissionSets = "D365 INV DOC, CREATE","D365 INV DOC, POST","D365 IC, SETUP"

    Permissions =
        // Tables (metadata)
        table "GSO ABC Preview Line" = X,
        table "GSO ABC Stats" = X,
        table "GSO ABC Counting Policy Header" = X,
        table "GSO ABC Counting Policy Line" = X,
        table "GSO ABC Analysis Setup" = X,
        table "GSO ABC History Header" = X,
        table "GSO ABC History Line" = X,

        // Tables (data)
        tabledata "GSO ABC Preview Line" = RIMD,
        tabledata "GSO ABC Stats" = RIMD,
        tabledata "GSO ABC Counting Policy Header" = RIMD,
        tabledata "GSO ABC Counting Policy Line" = RIMD,
        tabledata "GSO ABC Analysis Setup" = RIMD,
        tabledata "GSO ABC History Header" = RIMD,
        tabledata "GSO ABC History Line" = RIMD,

        // Pages
        page "GSO ABC Worksheet" = X,
        page "GSO ABC Worksheet Params" = X,
        page "GSO ABC Stats Part" = X,
        page "GSO ABC Analysis Setup" = X,
        page "GSO ABC Counting Policy Card" = X,
        page "GSO ABC Counting Policy List" = X,
        page "GSO ABC History" = X,
        page "GSO ABC Count Policy Subform" = X,
        page "GSO ABC Counting Policy Lines" = X,

        // Report
        report "GSO ABC Analysis" = X,

        // Codeunits
        codeunit "GSO ABC Analysis Mgt." = X,
        codeunit "GSO ABC Worksheet Stats" = X;
}
