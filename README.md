# ABC Inventory Analysis for Business Central

**Product page and documentation:** https://gmsoftdynamics.com/apps/free/abc-inventory-analysis/ | **All GMSOFT apps for Business Central:** https://gmsoftdynamics.com/apps/compare/

Free ABC classification for Microsoft Dynamics 365 Business Central. Rank items by revenue, gross profit, cost of goods sold, usage value, GMROII or pick frequency, preview the result, and write the class to items and stockkeeping units. Optionally drive physical inventory counting periods from the class.

- **Publisher:** GMSOFT LIMITED
- **App ID:** `fed0d995-8c8d-4fda-bd16-e10d112171fb`
- **Object range:** 73033660 to 73033689, prefix `GSO`
- **Platform:** Business Central 29 and later, cloud
- **Languages:** English, French, German, Greek, Italian, Spanish
- **Help:** https://gmsoftdynamics.com/apps/free/abc-inventory-analysis/docs/

## Features

| Area | What you get |
|---|---|
| Six models | Revenue, Gross Profit, Value / COGS, Usage Value, GMROII, Pick Frequency, each with its own A and B thresholds and lookback period |
| Worksheet | Calculate a preview for one model and period, see class statistics, export to Excel, then apply |
| Item and SKU fields | One class and one timestamp per model on the Item and Stockkeeping Unit, shown on the cards and the item list |
| Counting policies | Map each model and class to a physical inventory counting period and have the app set it when classes are applied |
| History | Every applied run is stored with its lines, so class changes can be traced and compared |
| Reports | Analysis, Class Distribution, Detail by Class, Multi-Model Comparison, Item Movement, Exceptions |
| Automation | One job queue entry recalculates and applies all models daily |
| Control fields | Exclude an item from the analysis, or protect its classes with Manual Override |

## Quick start

1. Install the app and assign the permission set **ABC Inventory - Administrator** to yourself.
2. Open **ABC Analysis Setup** and check the thresholds. The defaults are A up to 80 %, B up to 95 %, 365 days.
3. Open the **ABC Worksheet**, choose **Calculate**, pick a model and confirm the dates.
4. Review the preview and the statistics factbox, then choose **Apply to Items/SKUs**.
5. To keep classes current, choose **Create/Enable Job Queue** in setup.

The help pages are published at https://gmsoftdynamics.com/apps/free/abc-inventory-analysis/docs/.

## Repository layout

```
app/app.json                 App manifest
app/src/                     AL source (tables, pages, codeunits, reports, permission sets)
app/src/Reports/Layouts/     RDLC layouts
Translations/            de-DE, el-GR, es-ES, fr-FR and it-IT translation files (the .g.xlf is generated)
docs/                    Source of the user help published on gmsoftdynamics.com
APPSOURCE-LISTING.md     Marketing copy for the AppSource offer
CHANGELOG.md             Release notes
```

## Building

Open the folder in VS Code with the AL Language extension, download symbols for Business Central 29, and build with `Ctrl+Shift+B`. The project uses the CodeCop, UICop and AppSourceCop analyzers and builds without warnings. Sign the package with Azure Trusted Signing before submitting it to AppSource.

## Support

See the support page at https://gmsoftdynamics.com/apps/free/abc-inventory-analysis/support/ (email, telephone, contact form), or open an issue at https://github.com/GmsoftLtd/bc-abc-inventory-analysis/issues. The app is free of charge and provided without a support contract.

## Licence

MIT. See [LICENSE](LICENSE). Copyright (c) 2025-2026 GMSOFT Limited.
