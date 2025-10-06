# ABC Analysis Extension - AI Coding Guide

## Architecture Overview

This is a **Business Central AL extension** (ID: `8cea7497-4829-495d-8928-f065a0a5669a`) for advanced ABC inventory classification with XYZ demand variability analysis. The extension uses ID range `73030575-73031574` for all objects.

### Core Domain Model
- **Three ABC Models**: Revenue, Gross Profit, and COGS (Value) - each with separate thresholds and calculation periods
- **ABC Classes**: A (high-value), B (medium), C (low), D (zero/no consumption) - defined in `GMOABCClass.Enum.al`
- **Multi-model support**: Items track separate classifications per model via table extensions (`GMOABCItemExt.TableExt.al`, `GMOABCSKUExt.TableExt.al`)

### Key Data Flow
1. **Setup** → `GMOABCAnalysisSetup.Table.al` - Single record with ID 'SETUP' containing thresholds, periods, and flags
2. **Calculation** → `GMOABCAnalysisMgt.CodeUnit.al` - Main business logic for preview generation and application
3. **Worksheet** → Temporary `GMOABCPreviewLine.Table.al` records displayed in `GMOABCWorksheet.Page.al`
4. **Application** → Updates Item/SKU records with classification and timestamp per model

## Essential Patterns

### Object Naming Convention
- **Prefix**: All objects start with `GMO` (company prefix) + `ABC` (module)
- **Examples**: `GMOABCAnalysisMgt.CodeUnit.al`, `GMOABCWorksheet.Page.al`
- **Table Extensions**: End with `Ext` (e.g., `GMOABCItemExt.TableExt.al`)

### ID Range Management
- **Base**: `73030575` - First enum/permission set
- **Tables**: `73030577+` (Setup), `73030580+` (Upgrade tracking)
- **Pages**: `73030637+` (Worksheet), `73030638+` (Params dialog)
- **Codeunits**: `73030583+` (Job), `73030590+` (Telemetry)
- **Field Extensions**: `73030620+` in Item table

### Multi-Model Architecture Pattern
```al
// Per-model fields in table extensions
field(73030620; "GMO Class (Revenue)"; Enum "GMO ABC Class")
field(73030621; "GMO Class (Gross Profit)"; Enum "GMO ABC Class")  
field(73030622; "GMO Class (COGS)"; Enum "GMO ABC Class")
```

### Upgrade Pattern
- **Upgrade Tags**: `GMOABCUpgradeTag.Table.al` tracks applied upgrades
- **Version Helpers**: Separate codeunits (`GMOABCUpgradeHelperv2.CodeUnit.al`) handle schema changes
- **Safe Migration**: Uses reflection (`RecordRef`/`FieldRef`) to avoid compilation errors on missing fields

## Critical Development Workflows

### Adding New Features
1. **Check ID availability** in the `73030575-73031574` range
2. **Follow naming convention**: `GMO` + `ABC` + descriptive name
3. **Update permissions**: Add to `GMOABCANALYSIS.Permissions.al`
4. **Consider upgrade path**: May need upgrade codeunit for schema changes

### Testing Calculations
- Use `GMOABCWorksheet.Page.al` with "Calculate Preview" action
- Models run independently - each has separate thresholds in Setup
- Worksheet sorts by Value descending, applies cumulative percentage thresholds

### Debugging Job Queue Integration
- `GMOABCJobQueueHelper.CodeUnit.al` manages background scheduling
- Auto-recalc triggers on Value Entry posting (configurable via Setup)
- Telemetry via `GMOABCTelemetry.CodeUnit.al` logs to Application Insights

### Working with Extensions
- **Item extensions** add ABC fields without breaking base functionality
- **SKU extensions** mirror Item fields for location-specific analysis
- Use `EnsureFieldExists()` pattern in upgrade helpers for safe field access

## Business Logic Specifics

### Classification Thresholds
- **Cumulative percentage-based**: Items sorted by value, A/B/C thresholds applied to running total
- **Per-model configuration**: Each model (Revenue/GP/COGS) has independent thresholds and periods
- **Zero handling**: "Zero Consumption as D" flag controls D-class assignment

### Data Sources
- **Revenue**: Customer Ledger Entries within date range
- **Gross Profit**: Item Ledger Entries with cost calculations  
- **COGS**: Value Entries for consumption/sales

### Integration Points
- **Value Entry subscriptions**: Auto-recalc on posting if enabled
- **Counting Policy**: Optional integration with warehouse cycle counting codes
- **Job Queue**: Background processing for large datasets

## Common Gotchas

- **Setup record**: Always use ID 'SETUP' - single record pattern
- **Temporary tables**: Worksheet uses `SourceTableTemporary = true` pattern
- **Date ranges**: Setup contains default periods, but worksheet allows override
- **Field reflection**: Upgrade code uses `FindFieldNoByName()` for safe field access without compilation dependencies

When adding new ABC models or classification logic, follow the existing three-model pattern and ensure upgrade compatibility.