# Changelog

## 1.29.1.1

First release of **ABC Inventory Analysis** as a free app, replacing the paid ABC Inventory Optimizer listing. New app ID, so it installs side by side with the old app and does not migrate its data.

### Added

- Statistics factbox and Excel export on the ABC Worksheet
- French, German, Greek, Italian and Spanish translations
- Context-sensitive help for all pages and reports
- Class D for items without activity in the analysis period, controlled by the setup
- ABC History entries can be deleted from the list

### Changed

- Licence checks and entitlements removed; two permission sets remain, Administrator and User
- Reports take their default period from the model settings in setup
- Detail by Class shows value share and cumulative share from the full ranking
- Item and stockkeeping unit updates no longer bump Last Date Modified on every run
- Setup page reduced to the settings that have an effect

### Fixed

- A value entry posting could trigger a full recalculation of all models
- Class Distribution report showed each class under the wrong label
- Exceptions and Comparison reports flagged almost every item as inconsistent
- Items without activity kept their previous class forever
- Exclude from ABC, Manual Override, Exclude Non-Inventory, Update Counting Codes and Update SKU were shown but ignored
- Excel export wrote to the permanent Excel Buffer table
- End Date caption on the parameters dialog, and the model name in the Apply confirmation

### Removed

- Legacy upgrade codeunits and upgrade tag table
- Unused Sales Qty class fields
