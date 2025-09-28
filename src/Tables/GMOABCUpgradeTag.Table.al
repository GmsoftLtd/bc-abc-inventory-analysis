table 73030580 "GMO ABC Upgrade Tag"
{
    Caption = 'ABC Upgrade Tag';
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