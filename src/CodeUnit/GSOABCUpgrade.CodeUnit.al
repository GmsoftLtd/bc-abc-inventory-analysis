codeunit 73030578 "GSO ABC Upgrade"
{
    Subtype = Upgrade;
    InherentPermissions = X;
    InherentEntitlements = X;

    trigger OnUpgradePerCompany()
    var
        Helper: Codeunit "GSO ABC Upgrade Helper";
    begin
        Helper.ApplyInitialUpgrade();
    end;
}