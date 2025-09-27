codeunit 73030585 "GMO Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var Helper: Codeunit "GMO Upgrade Helper";
    begin
        Helper.ApplyInitialUpgrade();
    end;
}