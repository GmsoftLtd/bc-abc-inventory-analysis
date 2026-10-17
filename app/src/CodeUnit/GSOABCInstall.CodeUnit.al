namespace GMSoft.ABCInventoryAnalysis;

using System.Upgrade;

codeunit 73033671 "GSO ABC Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "GSO ABC Analysis Setup";
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        Tlm: Codeunit "GSO ABC Telemetry";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTags: Codeunit "GSO ABC Upgrade Tags";
    begin
        Mgt.EnsureSetup(Setup);
        Mgt.EnsurePolicyExists(Setup."Counting Code Mapping ID");
        if not UpgradeTag.HasUpgradeTag(UpgradeTags.GetDefaultPolicyUpgradeTag()) then
            UpgradeTag.SetUpgradeTag(UpgradeTags.GetDefaultPolicyUpgradeTag());
        Tlm.LogInstalled();
    end;
}
