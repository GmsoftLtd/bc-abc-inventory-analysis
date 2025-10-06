codeunit 73030578 "GMO ABC Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Helper: Codeunit "GMO ABC Upgrade Helper";
    begin
        Helper.ApplyInitialUpgrade();
    end;
}