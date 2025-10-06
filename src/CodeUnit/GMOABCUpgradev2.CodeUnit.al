codeunit 73030585 "GMO ABC Upgrade v2"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Helper: Codeunit "GMO ABC Upgrade Helper v2";
    begin
        Helper.ApplyV2();
    end;
}
