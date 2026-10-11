# ABC Inventory Analysis - AI coding guide

Business Central AL extension (app ID `fed0d995-8c8d-4fda-bd16-e10d112171fb`, publisher GMSOFT LIMITED). Object range 73033660 to 73033689, mandatory prefix `GSO ` on object names and `GSO ` on extension fields. Platform 27, runtime 16, target Cloud. Free app: no licence or entitlement code anywhere.

## Architecture

- **Setup** `GSO ABC Analysis Setup` (table 73030575): one record with key `SETUP`. Per-model A %, B % and period in days for six models, plus Zero Consumption as D, Exclude Non-Inventory, counting policy flags.
- **Models** enum `GSO ABC Model`: Revenue, Gross Profit, COGS, Usage Value, GMROII, Pick Frequency. **Classes** enum `GSO ABC Class`: Unknown, A, B, C, D. Both are `Extensible = false` because the code has a case branch per value.
- **Engine** codeunit `GSO ABC Analysis Mgt.` (73030582). Public surface:
  - `CalculatePreview(Model, StartDate, EndDate, var TempPreview)` ranks items into the temporary `GSO ABC Preview Line` buffer.
  - `ApplyPreview(var TempPreview, Model, StartDate, EndDate): Integer` writes classes to Item and Stockkeeping Unit, writes `GSO ABC History Header/Line`, optionally sets counting period codes. Honours `GSO Manual Override`.
  - `CalcItemValue(Model, StartDate, EndDate, ItemNo): Decimal` is the single value calculation. Reports call it; do not duplicate it.
  - `GetDefaultDates(Model, var Start, var End)` returns work date minus the model period.
  - `RecalculateAllModels(Apply)` loops the enum ordinals; used by the job.
  - `EnsureSetup`, `GetSetup` (no insert), `EnsurePolicyExists`.
- **Worksheet** page `GSO ABC Worksheet` (temporary source) with `GSO ABC Worksheet Params` dialog, `GSO ABC Stats Part` factbox fed by codeunit `GSO ABC Worksheet Stats`, Excel export by `GSO ABC Worksheet Export`.
- **Automation** codeunit `GSO ABC Analysis Job` is the job queue target; `GSO ABC Job Queue Helper` creates the entry. There is deliberately no posting event subscriber.
- **Reports** 73030575 to 73030580, RDLC layouts in `src/Reports/Layouts`. Dataset column names are referenced by the layouts; renaming a column requires editing the RDL.
- **Permission sets** `GSO ABC ADMIN` and `GSO ABC USER`. Add every new object to both.

## Conventions

- Item and SKU class fields are set directly and saved with `Modify(false)`; only the counting period code goes through `Validate` and `Modify(true)`.
- All user-facing strings are labels. Format strings and codes use `Locked = true`.
- Every page field and action has a ToolTip starting with "Specifies" where it describes a field.
- Pages and reports carry `ContextSensitiveHelpPage` matching a file in `docs/` (setup, worksheet, history, counting-policies, reports).
- Translations live in `Translations/` as `ABC Inventory Analysis.<lang>.xlf`. After caption changes, rebuild, refresh both files with NAB AL Tools and translate the new units.
- Build with CodeCop, UICop and AppSourceCop; the project is warning-free and must stay that way.
