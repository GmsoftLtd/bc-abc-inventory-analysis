codeunit 73030588  "GMO ABC License Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "GMO ABC License Setup";
    begin
        if not Setup.Get(1) then begin
            Setup.Init();
            Setup.Insert();
        end;
    end;
}
