codeunit 73030585 "GMO ABC Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var Helper: Codeunit "GMO ABC Upgrade Helper";
    begin
        Helper.ApplyInitialUpgrade();
    end;
}