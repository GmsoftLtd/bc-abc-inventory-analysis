codeunit 73030579 "GMO ABC Upgrade Helper"
{


    procedure ApplyInitialUpgrade()
    var
        Setup: Record "GMO ABC Analysis Setup";
        TagTxt: Code[50];
    begin
        TagTxt := 'GMO-Init-1.0.0';
        if HasUpgradeTag(TagTxt) then exit;

        if not Setup.Get('SETUP') then begin
            Setup.Init();
            Setup."Primary Key" := 'SETUP';
            Setup.Enabled := true;
            Setup."A Threshold %" := 80;
            Setup."B Threshold %" := 95;
            Setup."Lookback (Days)" := 365;
            Setup."Zero Consumption as D" := true;
            Setup."Exclude Non-Inventory" := true;
            Setup."Auto Update On Posting" := true;
            Setup."Commit Batch Size" := 500;
            Setup."Last Upgraded To" := '1.0.0.0';
            Setup.Insert(true);
        end else begin
            Setup."Last Upgraded To" := '1.0.0.0';
            Setup.Modify(true);
        end;

        SetUpgradeTag(TagTxt);
    end;

    local procedure HasUpgradeTag(Tag: Code[50]): Boolean
    var
        T: Record "GMO ABC Upgrade Tag";
    begin
        exit(T.Get(Tag));
    end;

    local procedure SetUpgradeTag(Tag: Code[50])
    var
        T: Record "GMO ABC Upgrade Tag";
    begin
        if not T.Get(Tag) then begin
            T.Init();
            T.Tag := Tag;
            T."Applied On" := CurrentDateTime;
            T.Insert(true);
        end;
    end;
}