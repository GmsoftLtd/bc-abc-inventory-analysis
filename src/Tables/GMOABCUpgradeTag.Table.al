table 73030576 "GMO ABC Upgrade Tag"
{
    Caption = 'ABC Upgrade Tag';
    Description = 'Tracks applied data upgrade routines to ensure upgrade scripts run only once per company and version';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Tag"; Code[250]) { Caption = 'Tag'; }
        field(2; "Company Name"; Text[30]) { Caption = 'Company Name'; }
        field(3; "App ID"; Guid) { Caption = 'App ID'; }
        field(4; "Applied On"; DateTime) { Caption = 'Applied On'; }
    }

    keys
    {
        key(PK; "Tag", "Company Name", "App ID") { Clustered = true; }
    }
}