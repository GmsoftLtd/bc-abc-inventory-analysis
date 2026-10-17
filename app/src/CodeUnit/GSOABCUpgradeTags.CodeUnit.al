namespace GMSoft.ABCInventoryAnalysis;

using System.Upgrade;

codeunit 73033678 "GSO ABC Upgrade Tags"
{
    Access = Internal;
    InherentPermissions = X;

    procedure GetDefaultPolicyUpgradeTag(): Code[250]
    begin
        exit('GSO-ABC-DefaultCountingPolicy-20261017');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure RegisterPerCompanyTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(GetDefaultPolicyUpgradeTag());
    end;
}
