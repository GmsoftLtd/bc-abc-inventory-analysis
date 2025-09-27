codeunit 73030583 "GMO Analysis Job"
{
  

    trigger OnRun()
    var Mgt: Codeunit "GMO Analysis Mgt.";
    begin
        Mgt.RecalculateAll(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Value Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure ValueEntry_OnAfterInsert(var Rec: Record "Value Entry")
    var
        Setup: Record "GMO Analysis Setup";
        Item: Record Item;
    begin
        if not Setup.Get('SETUP') then exit;
        if not Setup."Auto Update On Posting" then exit;
        if Item.Get(Rec."Item No.") then begin
            // simple flag pattern; actual recalc via job
            Item."GMO Exclude" := Item."GMO Exclude"; // no-op to touch record if needed
        end;
    end;
}