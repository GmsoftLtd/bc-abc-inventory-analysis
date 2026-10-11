# Reports

All reports are found with **Tell me** by typing "ABC" and under **ABC Inventory - Reports** in the role centers. Where a report asks for a start and end date, leaving them blank uses the period configured for the model in setup, ending on the work date.

## ABC Inventory Analysis

The ranked list for one model and period, exactly what the worksheet shows: item, value, value %, cumulative % and class, highest value first. Nothing is written to items. Use it to print or save a classification without applying it.

Options: Model, Start Date, End Date.

## ABC Class Distribution

One row per class with the number of items, the model value, and each as a share of the total. Classes come from the items as they are today, the value is calculated for the period. Items that have never been classified for the model are left out of the totals.

Options: Model, Start Date, End Date, Item No. filter, Item Category filter.

## ABC Detail by Class

Item-level detail for one model: the class on the item, the value for the period, the item's share and cumulative share, and when the class was last applied. Shares are taken from a full ranking of all items, so they match the worksheet.

Options: Model, Class Filter (blank for all), Start Date, End Date, plus filters on item number, category and product posting group.

## ABC Multi-Model Comparison

All six classes and all six values side by side for every item, with a consistency indicator:

| Indicator | Meaning |
|---|---|
| Consistent | All calculated classes are the same. |
| Minor Variance | Classes differ by one step at most, for example A and B. |
| Inconsistent | Classes differ by two or more steps, for example A and C. |
| n/a | Fewer than two models have been applied to the item. |

Models never applied to the item are ignored. Items with zero value in all models are skipped.

Options: Start Date, End Date (used for all models), plus item filters.

## ABC Item Movement

Items whose class for a model is different from the class recorded in the last history entry applied on or before the comparison date. Shows the previous class, the current class and the current value. Items with no history before that date show a blank previous class.

Options: Model, Compare to Date (required), plus item filters.

## ABC Exception Report

Lists items that need attention, one reason per item, checked in this order:

| Exception | Condition |
|---|---|
| Never Calculated | No model has ever been applied to the item. |
| Outdated | The most recent classification is older than the threshold. |
| Inconsistent | Calculated classes differ by two or more steps between models. |
| Inventory Mismatch | Inventory value above the threshold and Revenue class C. |
| No Activity | No value entries in the Revenue period. |

Options: Outdated Threshold in days (default 90), Inventory Value Threshold (default 10,000), plus item filters.
