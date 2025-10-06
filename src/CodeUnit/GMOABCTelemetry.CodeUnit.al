codeunit 73030581 "GMO ABC Telemetry"
{
    procedure LogInfo(EventId: Text[50]; MessageTxt: Text[250])
    begin
        Session.LogMessage(EventId, MessageTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'GMO.ABC');
    end;

    procedure LogError(EventId: Text[50]; MessageTxt: Text[250])
    begin
        Session.LogMessage(EventId, MessageTxt, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'GMO.ABC');
    end;
}