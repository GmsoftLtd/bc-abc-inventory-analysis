codeunit 73030589 "GMO ABC Job Queue Helper"
{
    procedure CreateOrEnableJob()
    var
        JQ: Record "Job Queue Entry";
        Enqueue: Codeunit "Job Queue - Enqueue"; // CU exposes EnqueueJobQueueEntry(...)
        Created: Boolean;
        CodeunitId: Integer;
    begin
        CodeunitId := Codeunit::"GMO ABC Analysis Job";

        // Reuse any existing entry for this codeunit
        JQ.Reset();
        JQ.SetRange("Object Type to Run", JQ."Object Type to Run"::Codeunit);
        JQ.SetRange("Object ID to Run", CodeunitId);

        if not JQ.FindFirst() then begin
            // Create a new entry (do NOT set Status/On Hold manually)
            JQ.Init();
            JQ."ID" := Format(CreateGuid());                 // PK should be GUID-like
            JQ.Description := 'GMO ABC Analysis Recalculation';
            JQ."Object Type to Run" := JQ."Object Type to Run"::Codeunit;
            JQ."Object ID to Run" := CodeunitId;
            JQ."User ID" := UserId;

            // Recurrence & schedule
            JQ."Recurring Job" := true;                      // correct field name
            JQ."No. of Minutes between Runs" := 1440;        // daily
            JQ."Earliest Start Date/Time" := CurrentDateTime;

            JQ.Insert(true);
            Created := true;
        end else begin
            // Make sure recurrence/schedule are sensible; leave status to Enqueue
            if not JQ."Recurring Job" then
                JQ."Recurring Job" := true;
            if JQ."No. of Minutes between Runs" = 0 then
                JQ."No. of Minutes between Runs" := 1440;
            if JQ."Earliest Start Date/Time" = 0DT then
                JQ."Earliest Start Date/Time" := CurrentDateTime;
            JQ.Modify(true);
        end;

        // Correct way to queue it (sets Status/On Hold internally)
        Enqueue.Run(JQ);

        if Created then
            Message('Job Queue Entry created and scheduled (ID: %1).', JQ."ID")
        else
            Message('Job Queue Entry found and scheduled (ID: %1).', JQ."ID");
    end;
}