namespace GMSoft.ABCInventoryAnalysis;

/// <summary>
/// Central telemetry emitter for ABC Inventory Analysis. All signals use the ExtensionPublisher scope so
/// they reach the publisher's Application Insights, not the customer's.
/// Event IDs: ABC-00xx (unique across GMSOFT apps, which share one Application Insights resource).
/// Custom dimensions carry counts, codes, versions and flags only.
/// </summary>
codeunit 73033673 "GSO ABC Telemetry"
{
    Access = Public;

    var
        CategoryLbl: Label 'GSO.ABC', Locked = true;
        InstalledTxt: Label 'ABC: installed with default setup.', Locked = true;
        UpgradedTxt: Label 'ABC: upgraded to %1.', Locked = true;
        ClassesAppliedTxt: Label 'ABC: classes applied for model %1 - %2 preview line(s), %3 item(s) updated, counting codes %4.', Locked = true;
        ApplyFailedTxt: Label 'ABC: apply stopped for model %1 - no preview lines.', Locked = true;
        ScheduledRunTxt: Label 'ABC: scheduled recalculation finished - %1 model(s) processed, apply changes %2.', Locked = true;
        ScheduledSkippedTxt: Label 'ABC: scheduled recalculation skipped - analysis disabled in setup.', Locked = true;

    /// <summary>Emits a signal when the app is installed in a company.</summary>
    procedure LogInstalled()
    var
        Dimensions: Dictionary of [Text, Text];
    begin
        Dimensions.Add('Category', CategoryLbl);
        Session.LogMessage('ABC-0001', InstalledTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, Dimensions);
    end;

    /// <summary>Emits a signal when a company is upgraded to a new app version.</summary>
    procedure LogUpgraded(AppVersion: Version)
    var
        Dimensions: Dictionary of [Text, Text];
    begin
        Dimensions.Add('Category', CategoryLbl);
        Dimensions.Add('appVersion', Format(AppVersion));
        Session.LogMessage('ABC-0002', StrSubstNo(UpgradedTxt, AppVersion), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, Dimensions);
    end;

    [Obsolete('Use the specific Log procedures (LogInstalled, LogUpgraded, LogClassesApplied ...); free-text events are not allowed.', '29.1')]
    procedure LogInfo(EventId: Text[50]; MessageTxt: Text[250])
    begin
        Session.LogMessage(EventId, MessageTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', CategoryLbl);
    end;

    [Obsolete('Use the specific Log procedures (LogApplyFailed ...); free-text events are not allowed.', '29.1')]
    procedure LogError(EventId: Text[50]; MessageTxt: Text[250])
    begin
        Session.LogMessage(EventId, MessageTxt, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', CategoryLbl);
    end;

    /// <summary>Emits a signal after preview classes are written to items and SKUs.</summary>
    procedure LogClassesApplied(Model: Enum "GSO ABC Model"; PreviewLines: Integer; ItemsUpdated: Integer; UpdateCountingCodes: Boolean)
    var
        Dimensions: Dictionary of [Text, Text];
        ModelName: Text;
    begin
        ModelName := GetModelName(Model);
        Dimensions.Add('Category', CategoryLbl);
        Dimensions.Add('model', ModelName);
        Dimensions.Add('previewLines', Format(PreviewLines));
        Dimensions.Add('itemsUpdated', Format(ItemsUpdated));
        Dimensions.Add('updateCountingCodes', Format(UpdateCountingCodes, 0, 9));
        Session.LogMessage(
            'ABC-0010',
            StrSubstNo(ClassesAppliedTxt, ModelName, PreviewLines, ItemsUpdated, Format(UpdateCountingCodes, 0, 9)),
            Verbosity::Normal,
            DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher,
            Dimensions);
    end;

    /// <summary>Emits an error signal when an apply is attempted without preview lines.</summary>
    procedure LogApplyFailed(Model: Enum "GSO ABC Model")
    var
        Dimensions: Dictionary of [Text, Text];
        ModelName: Text;
    begin
        ModelName := GetModelName(Model);
        Dimensions.Add('Category', CategoryLbl);
        Dimensions.Add('model', ModelName);
        Session.LogMessage(
            'ABC-0011',
            StrSubstNo(ApplyFailedTxt, ModelName),
            Verbosity::Error,
            DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher,
            Dimensions);
    end;

    /// <summary>Emits a signal after the job queue recalculation of all models.</summary>
    procedure LogScheduledRun(ModelsProcessed: Integer; ApplyChanges: Boolean)
    var
        Dimensions: Dictionary of [Text, Text];
    begin
        Dimensions.Add('Category', CategoryLbl);
        Dimensions.Add('modelsProcessed', Format(ModelsProcessed));
        Dimensions.Add('applyChanges', Format(ApplyChanges, 0, 9));
        Session.LogMessage(
            'ABC-0020',
            StrSubstNo(ScheduledRunTxt, ModelsProcessed, Format(ApplyChanges, 0, 9)),
            Verbosity::Normal,
            DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher,
            Dimensions);
    end;

    /// <summary>Emits a signal when the scheduled job runs while the analysis is disabled in setup.</summary>
    procedure LogScheduledSkipped()
    var
        Dimensions: Dictionary of [Text, Text];
    begin
        Dimensions.Add('Category', CategoryLbl);
        Session.LogMessage(
            'ABC-0021',
            ScheduledSkippedTxt,
            Verbosity::Normal,
            DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher,
            Dimensions);
    end;

    local procedure GetModelName(Model: Enum "GSO ABC Model"): Text
    begin
        exit(Model.Names().Get(Model.Ordinals().IndexOf(Model.AsInteger())));
    end;
}
