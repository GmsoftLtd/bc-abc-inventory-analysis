codeunit 73030584 "GMO ABC Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "GMO ABC Analysis Setup";
        Tlm: Codeunit "GMO ABC Telemetry";
    begin
        if not Setup.Get('SETUP') then begin
            Setup.Init();
            Setup."Primary Key" := 'SETUP';
            Setup.Enabled := true;
            Setup."A Threshold %" := 80;
            Setup."B Threshold %" := 95;
            Setup."Lookback (Days)" := 365;
            Setup."Include Transfers" := false;
            Setup."Zero Consumption as D" := true;
            Setup."Exclude Non-Inventory" := true;
            Setup."Auto Update On Posting" := true;
            Setup."Commit Batch Size" := 500;
            Setup."Rev A %" := 80;
            Setup."Rev B %" := 95;
            Setup."Rev Period (Days)" := 365;
            Setup."GP A %" := 80;
            Setup."GP B %" := 95;
            Setup."GP Period (Days)" := 365;
            Setup."COGS A %" := 80;
            Setup."COGS B %" := 95;
            Setup."COGS Period (Days)" := 365;
            Setup."Counting Code Mapping ID" := 'DEFAULT';
            Setup."Last Upgraded To" := '1.1.0.0';
            Setup.Insert(true);
        end;
        Tlm.LogInfo('GMO-INSTALL', 'GMO ABC Analysis installed or reinstalled.');
    end;
}