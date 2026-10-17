namespace GMSoft.ABCInventoryAnalysis;

using System.Threading;

codeunit 73033672 "GSO ABC Job Queue Helper"
{
    var
        JobDescriptionLbl: Label 'ABC Inventory Analysis - Recalculation';
        CreatedMsg: Label 'A job queue entry was created and scheduled to run daily (ID: %1).', Comment = '%1 = Job Queue Entry ID';
        FoundMsg: Label 'The existing job queue entry was scheduled (ID: %1).', Comment = '%1 = Job Queue Entry ID';

    procedure CreateOrEnableJob()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueEnqueue: Codeunit "Job Queue - Enqueue";
        Created: Boolean;
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"GSO ABC Analysis Job");

        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Init();
            JobQueueEntry.ID := CreateGuid();
            JobQueueEntry.Description := CopyStr(JobDescriptionLbl, 1, MaxStrLen(JobQueueEntry.Description));
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Object ID to Run" := Codeunit::"GSO ABC Analysis Job";
            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."No. of Minutes between Runs" := 1440;
            JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime();
            JobQueueEntry.Insert(true);
            Created := true;
        end else begin
            if not JobQueueEntry."Recurring Job" then
                JobQueueEntry."Recurring Job" := true;
            if JobQueueEntry."No. of Minutes between Runs" = 0 then
                JobQueueEntry."No. of Minutes between Runs" := 1440;
            if JobQueueEntry."Earliest Start Date/Time" = 0DT then
                JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime();
            JobQueueEntry.Modify(true);
        end;

        // Sets status to Ready and validates the entry
        JobQueueEnqueue.Run(JobQueueEntry);

        if Created then
            Message(CreatedMsg, JobQueueEntry.ID)
        else
            Message(FoundMsg, JobQueueEntry.ID);
    end;
}
