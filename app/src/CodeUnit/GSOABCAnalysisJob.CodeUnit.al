namespace GMSoft.ABCInventoryAnalysis;

codeunit 73033670 "GSO ABC Analysis Job"
{
    // Scheduled recalculation. Run this codeunit from a Job Queue Entry (see "Create/Enable Job Queue" on the setup page).

    trigger OnRun()
    var
        Setup: Record "GSO ABC Analysis Setup";
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        Telemetry: Codeunit "GSO ABC Telemetry";
    begin
        if Setup.Get('SETUP') then
            if not Setup.Enabled then begin
                Telemetry.LogScheduledSkipped();
                exit;
            end;

        Mgt.RecalculateAllModels(true);
    end;
}
