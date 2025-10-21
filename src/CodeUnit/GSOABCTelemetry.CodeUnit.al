codeunit 73030581 "GSO ABC Telemetry"
{
    procedure LogInfo(EventId: Text[50]; MessageTxt: Text[250])
    begin
        Session.LogMessage(EventId, MessageTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'GSO.ABC');
    end;

    procedure LogError(EventId: Text[50]; MessageTxt: Text[250])
    begin
        Session.LogMessage(EventId, MessageTxt, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'GSO.ABC');
    end;
}