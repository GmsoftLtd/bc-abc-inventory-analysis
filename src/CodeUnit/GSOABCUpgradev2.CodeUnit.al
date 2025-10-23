codeunit 73030585 "GSO ABC Upgrade v2"
{
    Subtype = Upgrade;
    InherentPermissions = X;
    InherentEntitlements = X;

    trigger OnUpgradePerCompany()
    var
        Helper: Codeunit "GSO ABC Upgrade Helper v2";
    begin
        Helper.ApplyV2();
    end;
}
