codeunit 73030578 "GSO ABC Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Helper: Codeunit "GSO ABC Upgrade Helper";
    begin
        Helper.ApplyInitialUpgrade();
    end;
}