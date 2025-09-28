codeunit 73030583 "GMO Analysis Job"
{
   

    trigger OnRun()
    var
        Mgt: Codeunit "GMO Analysis Mgt.";
    begin
        // Recalculate each model using its own Setup window and APPLY results
        Mgt.RecalculateAllDistinctWindows(true);
    end;

    // Kick off a recalculation when new Value Entries are posted (optional, guarded by Setup flag)
    [EventSubscriber(ObjectType::Table, Database::"Value Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure ValueEntry_OnAfterInsert(var Rec: Record "Value Entry"; RunTrigger: Boolean)
    var
        Mgt: Codeunit "GMO Analysis Mgt.";
    begin
        if not IsAutoRecalcEnabled() then
            exit;

        // NOTE: This runs synchronously. If you prefer to offload, use Job Queue to schedule this codeunit instead.
        Mgt.RecalculateAllDistinctWindows(true);
    end;

    // ---- helpers ----

    // Returns TRUE only if GMO Analysis Setup contains a Boolean field named 'Auto Update On Posting'
    // and it is set to TRUE. If the field does not exist, returns FALSE (safe, compile-proof).
    local procedure IsAutoRecalcEnabled(): Boolean
    var
        Setup: Record "GMO Analysis Setup";
        RRef: RecordRef;
        FRef: FieldRef;
        FNo: Integer;
    begin
        if not Setup.Get('SETUP') then
            exit(false);

        RRef.GetTable(Setup);
        FNo := FindFieldNoByName(RRef, 'Auto Update On Posting');
        if FNo = 0 then
            exit(false);

        FRef := RRef.Field(FNo);
        // Boolean prints as 'Yes'/'No' across locales via Format(); this simple check is robust enough
        exit(Format(FRef.Value) = 'Yes');
    end;

    local procedure FindFieldNoByName(var RecRef: RecordRef; FieldName: Text): Integer
    var
        i: Integer;
        FRef: FieldRef;
    begin
        for i := 1 to RecRef.FieldCount do begin
            FRef := RecRef.FieldIndex(i);
            if UpperCase(FRef.Name) = UpperCase(FieldName) then
                exit(FRef.Number);
        end;
        exit(0);
    end;
}
