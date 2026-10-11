codeunit 73033671 "GSO ABC Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "GSO ABC Analysis Setup";
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        Tlm: Codeunit "GSO ABC Telemetry";
    begin
        Mgt.EnsureSetup(Setup);
        Mgt.EnsurePolicyExists(Setup."Counting Code Mapping ID");
        Tlm.LogInfo('GSO-INSTALL', 'ABC Inventory Analysis installed with default setup.');
    end;
}
