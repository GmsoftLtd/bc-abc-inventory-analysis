# AppSource listing copy

Text for the Partner Center offer. Character limits are the Partner Center limits at the time of writing.

## Offer setup

| Field | Value |
|---|---|
| Offer name | ABC Inventory Analysis |
| Publisher | GMSOFT LIMITED |
| App type | Add-on app |
| Pricing | Free |
| Supported countries | United Kingdom, Greece, Italy |
| Languages | English, Greek, Italian |
| Categories | Operations and Supply Chain; Analytics |
| Industries | Distribution; Manufacturing; Retail and Consumer Goods |
| Help link | https://gmsoftdynamics.com/apps/free/abc-inventory-analysis/docs/ |
| Privacy policy link | https://gmsoftdynamics.com/privacy-statement-eu/ |
| Support link | https://github.com/GMSOFT-LIMITED/ABC/issues |

## Summary (100 characters)

Classify items A, B, C or D by revenue, profit, cost, usage, GMROII or picks. Free, built in.

## Description (3,000 characters)

**Know which items matter.** ABC Inventory Analysis ranks your items and assigns each one a class, directly inside Business Central. Pick the model that fits your business, preview the result, and apply it to items and stockkeeping units in one step.

**Six ways to rank**

- Revenue, for sales-driven businesses
- Gross Profit, to find the items that actually earn money
- Value / COGS, for the cost of what leaves the warehouse
- Usage Value, for production and internal consumption
- GMROII, margin earned per unit of inventory investment
- Pick Frequency, for warehouse slotting

Each model has its own A and B thresholds and its own lookback period. Items with no activity become class D, so inactive items never keep a stale class.

**See before you commit.** The worksheet shows every item with its value, its share and the cumulative share that decides the class, next to a statistics factbox with counts and amounts per class. Export the preview to Excel, or apply it when you are satisfied.

**Classes where you work.** The class and the date it was calculated appear on the item card, the item list and the stockkeeping unit card, one set per model. Mark an item to exclude it from the analysis, or protect its classes with Manual Override.

**Count what matters more often.** Map each model and class to a physical inventory counting period and let the app set the counting period code on items and stockkeeping units whenever classes are applied.

**Keep it current.** One job queue entry recalculates and applies all models every day. Every run is kept in ABC History with its item lines.

**Six reports**, including class distribution, detail by class, a comparison across all models, class movement against any past date, and an exception list of items that were never classified, are outdated, disagree between models, or carry high stock in class C.

**Free, no limits.** No licence, no item limit, no trial period. English, Greek and Italian included.

## Search keywords

ABC analysis, ABC classification, inventory classification, Pareto, cycle counting, GMROII, pick frequency, inventory optimization

## Screenshots (1280 x 720) and captions

| # | Screen | Caption |
|---|---|---|
| 1 | ABC Worksheet after Calculate, statistics factbox visible | Preview every item with its value, share and cumulative share before you apply a single class |
| 2 | ABC Analysis Setup, Revenue group in view | Six models, each with its own A and B thresholds and lookback period |
| 3 | Item Card, ABC Classification group | One class and calculation date per model, directly on the item card |
| 4 | Counting Policy card with periods filled in | Map classes to physical inventory counting periods and let the app set them on items |
| 5 | ABC Detail by Class report | Detail by class ranks items by value and shows the cumulative share behind every class boundary |

Logo for the offer: images/abc-logo-216.png. Files abc1 to abc5 in images/ are 1280 x 720 captures of the current build.

## Release notes for the listing

See CHANGELOG.md.

## Notes for certification (paste on Review and submit, not saved between submissions)

ABC Inventory Analysis is a free add-on for Business Central 27 and later. It requires no external accounts, API keys, licence keys or test credentials. All processing happens inside Business Central.

Test setup: any demo company with posted sales, e.g. CRONUS. Assign the permission set "GSO ABC ADMIN" (ABC Inventory - Administrator) to the test user.

Key scenario (5 minutes):
1. Search "ABC Analysis Setup" - record exists with defaults (A 80 %, B 95 %, 365 days per model).
2. Search "ABC Worksheet" > Calculate > model Revenue, Start Date 01/01/2020 > OK. Lines are ranked by value with Value %, Cumulative % and class A/B/C; items without sales are class D. Statistics FactBox shows totals per class.
3. Apply to Items/SKUs > confirm. Message "Classes applied".
4. Open the Item Card of the first line (CRONUS UK: 1896-S), group ABC Classification: ABC Class (Revenue) = A with timestamp.
5. Search "ABC History" - one entry with lines.
6. Reports: ABC Inventory Analysis, ABC Class Distribution, ABC Detail by Class, ABC Multi-Model Comparison, ABC Item Movement (Compare to Date = today), ABC Exception Report - all preview without error.
7. Setup > Create/Enable Job Queue creates a daily job queue entry for codeunit "GSO ABC Analysis Job".

Optional: counting policy (ABC Counting Policies > DEFAULT, map Revenue A/B/C to Phys. Invt. Counting Periods, enable "Update Phys. Invt. Counting Codes" in setup, apply again - item gets the counting period code).

A step-by-step validation guide with expected results is attached under Supplemental content. Languages: en-US, el-GR, it-IT. Contact: gmavrogeorgis@gmsoft.co.uk.
