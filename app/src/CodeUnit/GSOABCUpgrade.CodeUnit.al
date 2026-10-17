namespace GMSoft.ABCInventoryAnalysis;

using System.Upgrade;

codeunit 73033677 "GSO ABC Upgrade"
{
    Subtype = Upgrade;

    var
        UpgradedTelemetryLbl: Label 'ABC Inventory Analysis upgraded to %1.', Comment = '%1 = app version', Locked = true;

    trigger OnUpgradePerCompany()
    var
        Setup: Record "GSO ABC Analysis Setup";
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        Tlm: Codeunit "GSO ABC Telemetry";
        ModInfo: ModuleInfo;
    begin
        Mgt.EnsureSetup(Setup);
        UpgradeDefaultPolicy(Setup);

        NavApp.GetCurrentModuleInfo(ModInfo);
        Setup."Last Upgraded To" := CopyStr(Format(ModInfo.AppVersion), 1, MaxStrLen(Setup."Last Upgraded To"));
        Setup.Modify();

        Tlm.LogInfo('GSO-UPGRADE', CopyStr(StrSubstNo(UpgradedTelemetryLbl, ModInfo.AppVersion), 1, 250));
    end;

    local procedure UpgradeDefaultPolicy(Setup: Record "GSO ABC Analysis Setup")
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTags: Codeunit "GSO ABC Upgrade Tags";
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetDefaultPolicyUpgradeTag()) then
            exit;

        Mgt.EnsurePolicyExists(Setup."Counting Code Mapping ID");
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetDefaultPolicyUpgradeTag());
    end;
}
