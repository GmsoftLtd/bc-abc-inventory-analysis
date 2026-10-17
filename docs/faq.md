# Questions and troubleshooting

## The worksheet shows no lines or very few

- Check the dates. The period must contain posted value entries of type Sale, Consumption or Negative Adjustment for the chosen model.
- *Exclude Non-Inventory Items* hides Service and Non-Inventory items.
- Items marked **Exclude from ABC** or **Blocked** never appear.
- With *Class Zero Consumption as D* off, items without activity are not listed at all.

## Everything is class C

The thresholds are cumulative percentages of value, not of items. If one item makes up 85 % of value with an A threshold of 80 %, that item is class B and everything after it is C. Lower the thresholds or review the data.

## GMROII gives zero for most items

GMROII divides margin by the item's current inventory value. Items with no stock on hand, or a zero unit cost, get zero. The model suits stocked items with a maintained unit cost.

## An item keeps its old class

- **ABC Manual Override** is on for the item.
- *Class Zero Consumption as D* is off and the item had no activity, so it was not in the preview.
- The item was not in the filter of the report you are looking at. Classes are only written by Apply or the job.

## Classes differ between models

That is expected and often useful. A cheap item picked all day is A for Pick Frequency and C for Revenue. Use the Comparison report to see the picture and choose one model for counting policies.

## The counting period code does not change

- **Update Phys. Invt. Counting Codes** must be on in setup.
- The policy line for that model and class must have a counting period.
- The counting period only changes when classes are applied, not when they are calculated.
- Stockkeeping units need **Update SKU Counting Codes** as well.

## Can I undo an Apply

Not automatically. Previous classes are in [ABC History](history). Recalculate with the earlier dates and apply again, or set **ABC Manual Override** and change the class by hand.

## The job does not run

- **Enabled** must be on in setup.
- Open **Job Queue Entries** and check the entry that runs codeunit 73033670. Its status must be Ready and the job queue must have an active scheduler for the company.
- The entry runs under the user who created it. That user needs the Administrator permission set and permission to modify items.

## Does the app send data outside my tenant

Business data stays in Business Central. The app sends operational telemetry, such as install events, to the publisher's Application Insights, with no customer business data. See the privacy statement linked in the app's details.

## Where do I get help

Open an issue at <https://github.com/GmsoftLtd/bc-abc-inventory-analysis/issues>. The app is free and provided without a support contract, but issues are read.
