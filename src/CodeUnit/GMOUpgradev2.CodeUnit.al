codeunit 73030647 "GMO Upgrade v2"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Helper: Codeunit "GMO Upgrade Helper v2";
    begin
        Helper.ApplyV2();
    end;
}
