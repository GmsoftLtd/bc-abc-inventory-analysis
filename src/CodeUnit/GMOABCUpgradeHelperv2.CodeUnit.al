codeunit 73030586 "GMO ABC Upgrade Helper v2"
{


    procedure ApplyV2()
    begin
        // Ensure base setup record exists first (no tagging)
        EnsureSetupExists();

        // 1) Initialize/extend setup fields (idempotent)
        if not HasTag(Tag_InitSetup()) then
            if Try_InitNewSetupFields() then
                SetTag(Tag_InitSetup());

        // 2) Ensure default counting policy + lines (idempotent)
        if not HasTag(Tag_CountingPolicy()) then
            if Try_EnsureDefaultCountingPolicy() then
                SetTag(Tag_CountingPolicy());

        // 3) Backfill Item model classes (idempotent by field state)
        if not HasTag(Tag_BackfillItem()) then
            if Try_BackfillItemModelClasses() then
                SetTag(Tag_BackfillItem());

        // 4) Backfill SKU model classes (idempotent by field state)
        if not HasTag(Tag_BackfillSKU()) then
            if Try_BackfillSkuModelClasses() then
                SetTag(Tag_BackfillSKU());

        // 5) Version stamp (best-effort)
        Try_UpdateSetupVersion('1.1.0.0');

        // 6) Final wave tag only if all steps succeeded
        if not HasTag(Tag_Complete()) then
            if HasTag(Tag_InitSetup()) and HasTag(Tag_CountingPolicy()) and
               HasTag(Tag_BackfillItem()) and HasTag(Tag_BackfillSKU()) then
                SetTag(Tag_Complete());
    end;

    // ----------------- SETUP GUARANTEE -----------------

    local procedure EnsureSetupExists()
    var
        Setup: Record "GMO ABC Analysis Setup";
    begin
        if Setup.Get('SETUP') then
            exit;

        Setup.Init();
        Setup."Primary Key" := 'SETUP';
        // sensible defaults (customer can change later)
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
        Setup."Last Upgraded To" := '';
        Setup.Insert(true);
    end;

    // ----------------- TRYFUNCTION WORK UNITS -----------------

    [TryFunction]
    local procedure Try_InitNewSetupFields()
    var
        Setup: Record "GMO ABC Analysis Setup";
    begin
        if not Setup.Get('SETUP') then
            exit; // EnsureSetupExists already attempted

        if Setup."Rev A %" = 0 then Setup."Rev A %" := 80;
        if Setup."Rev B %" = 0 then Setup."Rev B %" := 95;
        if Setup."Rev Period (Days)" = 0 then Setup."Rev Period (Days)" := 365;

        if Setup."GP A %" = 0 then Setup."GP A %" := 80;
        if Setup."GP B %" = 0 then Setup."GP B %" := 95;
        if Setup."GP Period (Days)" = 0 then Setup."GP Period (Days)" := 365;

        if Setup."COGS A %" = 0 then Setup."COGS A %" := 80;
        if Setup."COGS B %" = 0 then Setup."COGS B %" := 95;
        if Setup."COGS Period (Days)" = 0 then Setup."COGS Period (Days)" := 365;

        if Setup."Counting Code Mapping ID" = '' then
            Setup."Counting Code Mapping ID" := 'DEFAULT';

        Setup.Modify(true);
    end;

    [TryFunction]
    local procedure Try_EnsureDefaultCountingPolicy()
    var
        Setup: Record "GMO ABC Analysis Setup";
        Mgt: Codeunit "GMO ABC Analysis Mgt.";
        HeaderCode: Code[10];
    begin
        if not Setup.Get('SETUP') then
            exit;

        if Setup."Counting Code Mapping ID" = '' then begin
            Setup."Counting Code Mapping ID" := 'DEFAULT';
            Setup.Modify(true);
        end;

        HeaderCode := Setup."Counting Code Mapping ID";
        // Create header + lines if missing
        Mgt.EnsurePolicyExists(HeaderCode);
    end;

    local procedure EnsureGrossProfitLines(HeaderCode: Code[10])
    var
        L: Record "GMO ABC Counting Policy Line";
    begin
        if not L.Get(HeaderCode, L.Model::"Gross Profit", L.Class::A) then begin
            L.Init();
            L."Header Code" := HeaderCode;
            L.Model := L.Model::"Gross Profit";
            L.Class := L.Class::A;
            L.Insert(true);
        end;
        if not L.Get(HeaderCode, L.Model::"Gross Profit", L.Class::B) then begin
            L.Init();
            L."Header Code" := HeaderCode;
            L.Model := L.Model::"Gross Profit";
            L.Class := L.Class::B;
            L.Insert(true);
        end;
        if not L.Get(HeaderCode, L.Model::"Gross Profit", L.Class::C) then begin
            L.Init();
            L."Header Code" := HeaderCode;
            L.Model := L.Model::"Gross Profit";
            L.Class := L.Class::C;
            L.Insert(true);
        end;
    end;

    local procedure EnsureCOGSLines(HeaderCode: Code[10])
    var
        L: Record "GMO ABC Counting Policy Line";
    begin
        if not L.Get(HeaderCode, L.Model::COGS, L.Class::A) then begin
            L.Init();
            L."Header Code" := HeaderCode;
            L.Model := L.Model::COGS;
            L.Class := L.Class::A;
            L.Insert(true);
        end;
        if not L.Get(HeaderCode, L.Model::COGS, L.Class::B) then begin
            L.Init();
            L."Header Code" := HeaderCode;
            L.Model := L.Model::COGS;
            L.Class := L.Class::B;
            L.Insert(true);
        end;
        if not L.Get(HeaderCode, L.Model::COGS, L.Class::C) then begin
            L.Init();
            L."Header Code" := HeaderCode;
            L.Model := L.Model::COGS;
            L.Class := L.Class::C;
            L.Insert(true);
        end;
    end;

    [TryFunction]
    local procedure Try_BackfillItemModelClasses()
    var
        Item: Record Item;
        Modified: Boolean;
        NowDT: DateTime;
    begin
        NowDT := CurrentDateTime;

        Item.Reset();
        Item.SetRange(Blocked, false);
        if Item.FindSet(true) then
            repeat
                Modified := false;

                if (Item."GMO Class (Revenue)" = Item."GMO Class (Revenue)"::Unknown) and (not Item."GMO Manual Override") then begin
                    Item."GMO Class (Revenue)" := Item."GMO Class (Revenue)";
                    Item."GMO Last Calc (Revenue)" := NowDT;
                    Modified := true;
                end;

                if (Item."GMO Class (Gross Profit)" = Item."GMO Class (Gross Profit)"::Unknown) and (not Item."GMO Manual Override") then begin
                    Item."GMO Class (Gross Profit)" := Item."GMO Class (Gross Profit)";
                    Item."GMO Last Calc (GP)" := NowDT;
                    Modified := true;
                end;

                if (Item."GMO Class (COGS)" = Item."GMO Class (COGS)"::Unknown) and (not Item."GMO Manual Override") then begin
                    Item."GMO Class (COGS)" := Item."GMO Class (COGS)";
                    Item."GMO Last Calc (COGS)" := NowDT;
                    Modified := true;
                end;

                if Modified then
                    Item.Modify(true);
            until Item.Next() = 0;
    end;

    [TryFunction]
    local procedure Try_BackfillSkuModelClasses()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        Modified: Boolean;
        NowDT: DateTime;
    begin
        NowDT := CurrentDateTime;

        SKU.Reset();
        if SKU.FindSet(true) then
            repeat
                Modified := false;

                if Item.Get(SKU."Item No.") then begin
                    if (SKU."GMO Class (Revenue)" = SKU."GMO Class (Revenue)"::Unknown) and (not Item."GMO Manual Override") then begin
                        SKU."GMO Class (Revenue)" := Item."GMO Class (Revenue)";
                        SKU."GMO Last Calc (Revenue)" := NowDT;
                        Modified := true;
                    end;

                    if (SKU."GMO Class (Gross Profit)" = SKU."GMO Class (Gross Profit)"::Unknown) and (not Item."GMO Manual Override") then begin
                        SKU."GMO Class (Gross Profit)" := Item."GMO Class (Gross Profit)";
                        SKU."GMO Last Calc (GP)" := NowDT;
                        Modified := true;
                    end;

                    if (SKU."GMO Class (COGS)" = SKU."GMO Class (COGS)"::Unknown) and (not Item."GMO Manual Override") then begin
                        SKU."GMO Class (COGS)" := Item."GMO Class (COGS)";
                        SKU."GMO Last Calc (COGS)" := NowDT;
                        Modified := true;
                    end;
                end;

                if Modified then
                    SKU.Modify(true);
            until SKU.Next() = 0;
    end;

    [TryFunction]
    local procedure Try_UpdateSetupVersion(NewVersion: Text[30])
    var
        Setup: Record "GMO ABC Analysis Setup";
    begin
        if Setup.Get('SETUP') then
            if Setup."Last Upgraded To" <> NewVersion then begin
                Setup."Last Upgraded To" := NewVersion;
                Setup.Modify(true);
            end;
    end;

    // ----------------- TAG STORE (custom table) -----------------

    local procedure HasTag(Tag: Code[250]): Boolean
    var
        T: Record "GMO ABC Upgrade Tag";
        ModInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModInfo);
        T.Reset();
        T.SetRange("Tag", Tag);
        T.SetRange("Company Name", CompanyName);
        T.SetRange("App ID", ModInfo.Id);
        exit(T.FindFirst());
    end;

    local procedure SetTag(Tag: Code[250])
    var
        T: Record "GMO ABC Upgrade Tag";
        ModInfo: ModuleInfo;
    begin
        if HasTag(Tag) then
            exit;
        NavApp.GetCurrentModuleInfo(ModInfo);
        T.Init();
        T."Tag" := Tag;
        T."Company Name" := CompanyName;
        T."App ID" := ModInfo.Id;
        T."Applied On" := CurrentDateTime;
        T.Insert(true);
    end;

    // ----------------- TAG CONSTANTS -----------------

    local procedure Tag_InitSetup(): Code[250]
    begin
        exit('GMO/V2/InitSetup');
    end;

    local procedure Tag_CountingPolicy(): Code[250]
    begin
        exit('GMO/V2/CountingPolicy');
    end;

    local procedure Tag_BackfillItem(): Code[250]
    begin
        exit('GMO/V2/BackfillItem');
    end;

    local procedure Tag_BackfillSKU(): Code[250]
    begin
        exit('GMO/V2/BackfillSKU');
    end;

    local procedure Tag_Complete(): Code[250]
    begin
        exit('GMO/V2/Complete');
    end;
}
