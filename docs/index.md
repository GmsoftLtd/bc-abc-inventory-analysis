# ABC Inventory Analysis

ABC Inventory Analysis ranks the items in Microsoft Dynamics 365 Business Central and assigns each one a class: **A** for the items that matter most, **B** for the middle group, **C** for the long tail, and **D** for items with no activity. You choose what "matters" means by picking a model, you preview the result, and you apply it to items and stockkeeping units.

The app is free and has no item limit.

## Topics

| Topic | What it covers |
|---|---|
| [Setup](setup) | Thresholds and periods per model, class D, counting policy options, job queue |
| [Worksheet](worksheet) | Calculate a preview, read the statistics, export, apply |
| [Counting policies](counting-policies) | Drive physical inventory counting periods from the class |
| [History](history) | Every applied run with its item lines |
| [Reports](reports) | The six reports and their options |
| [Questions and troubleshooting](faq) | Common questions |

## How the classification works

1. For every item the app calculates one **value** for the chosen model and period. For the Revenue model that is the sales amount, for Pick Frequency it is the number of outbound transactions, and so on.
2. Items are sorted by value, highest first.
3. Walking down the list, the app adds up each item's share of the total. This running total is the **cumulative %**.
4. While the cumulative % is at or below the **A threshold** the item is class A. Up to the **B threshold** it is class B. Above that it is class C.
5. Items whose value is zero become class **D** when *Class Zero Consumption as D* is on in setup. Otherwise they are left out and keep whatever class they had.

With the default thresholds of 80 % and 95 %, the items that together make up the first 80 % of value are A, the next 15 % are B and the last 5 % are C. This is the classic Pareto split.

## The six models

| Model | Value per item | Typical use |
|---|---|---|
| Revenue | Sales amount (actual) from value entries | Sales-driven businesses |
| Gross Profit | Sales amount plus cost amount on sales entries, so sales minus cost | Find the items that earn money |
| Value / COGS | Outbound cost on sales, consumption and negative adjustments | Cost of what leaves stock |
| Usage Value | Cost of consumed and sold quantity | Production and internal consumption |
| GMROII | Gross margin in the period divided by current inventory value, as a percentage | Return on inventory investment |
| Pick Frequency | Number of item ledger entries of type Sale and Consumption | Warehouse slotting |

Each model has its own thresholds and its own lookback period, and each writes to its own class field on the item. You can use one model or all six.

## Quick start

1. Assign the permission set **ABC Inventory - Administrator** to yourself.
2. Search for **ABC Analysis Setup** and review the thresholds. The defaults work for most companies.
3. Search for **ABC Worksheet**, choose **Calculate**, pick a model and accept the dates.
4. Look at the preview and the **Statistics** factbox. Choose **Export to Excel** if you want to share it.
5. Choose **Apply to Items/SKUs**. The classes are now on the item card, the item list and the stockkeeping unit card.
6. Back in setup, choose **Create/Enable Job Queue** so the classes refresh every day.

## Where to find things

All pages and reports can be found with **Tell me** (Alt+Q) by typing "ABC". They are also grouped under **ABC Inventory** in the Business Manager, Order Processor and Warehouse Basic role centers.

## Permissions

| Permission set | Intended for | Can |
|---|---|---|
| ABC Inventory - Administrator | The person who owns the setup | Everything, including setup, counting policies, deleting history and creating the job queue entry |
| ABC Inventory - User | Planners and warehouse staff | Run the worksheet, apply classes, run reports, view history |

Users also need their normal permissions on items, stockkeeping units, value entries and item ledger entries.

## Support

Report problems or ask questions at <https://github.com/GmsoftLtd/bc-abc-inventory-analysis/issues>.
