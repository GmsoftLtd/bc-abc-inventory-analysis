permissionset 73030578 "GSO ABC USER"
{
    Assignable = true;
    Caption = 'ABC Inventory - User';

    Permissions =
        table "GSO ABC Analysis Setup" = X,
        table "GSO ABC Counting Policy Header" = X,
        table "GSO ABC Counting Policy Line" = X,
        table "GSO ABC History Header" = X,
        table "GSO ABC History Line" = X,
        table "GSO ABC Stats" = X,
        table "GSO ABC Preview Line" = X,

        // Read setup and policies, write history when applying classes
        tabledata "GSO ABC Analysis Setup" = RM,
        tabledata "GSO ABC Counting Policy Header" = R,
        tabledata "GSO ABC Counting Policy Line" = R,
        tabledata "GSO ABC History Header" = RIM,
        tabledata "GSO ABC History Line" = RI,
        tabledata "GSO ABC Stats" = RIMD,
        tabledata "GSO ABC Preview Line" = RIMD,

        page "GSO ABC Analysis Setup" = X,
        page "GSO ABC Worksheet Params" = X,
        page "GSO ABC Stats Part" = X,
        page "GSO ABC Worksheet" = X,
        page "GSO ABC History" = X,
        page "GSO ABC History Lines" = X,
        page "GSO ABC History Card" = X,
        page "GSO ABC Counting Policy List" = X,
        page "GSO ABC Counting Policy Card" = X,
        page "GSO ABC Count Policy Subform" = X,

        report "GSO ABC Analysis" = X,
        report "GSO ABC Distribution" = X,
        report "GSO ABC Item Movement" = X,
        report "GSO ABC Detail by Class" = X,
        report "GSO ABC Exceptions" = X,
        report "GSO ABC Comparison" = X,

        codeunit "GSO ABC Analysis Mgt." = X,
        codeunit "GSO ABC Worksheet Stats" = X,
        codeunit "GSO ABC Worksheet Export" = X;
}
