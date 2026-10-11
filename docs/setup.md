# ABC Analysis Setup

Search for **ABC Analysis Setup**. The record is created automatically when the app is installed, with the defaults described below.

## General

| Field | Meaning |
|---|---|
| Enabled | Controls the scheduled job queue run only. When off, the daily recalculation does nothing. Calculations started from the worksheet always run. |
| Class Zero Consumption as D | On: items with no value in the period are included in the preview with class D and the class is written when you apply. Off: such items are left out and keep their previous class. Default on. |
| Exclude Non-Inventory Items | Skip items of type Service and Non-Inventory. Default on. |
| Last Run | When classes were last applied, by the worksheet or the job. |
| Installed Version | The app version that created or last upgraded the setup. |

Blocked items and items marked **Exclude from ABC** on the item card are always skipped.

## Model groups

There is one group per model: Revenue, Gross Profit, COGS, Usage Value, GMROII and Pick Frequency. Each has the same three fields.

| Field | Meaning |
|---|---|
| A Threshold % | Items are class A while the cumulative share of value is at or below this percentage. Default 80. |
| B Threshold % | Items are class B while the cumulative share is at or below this percentage. Above it they are class C. Default 95. |
| Period (Days) | How far back from the work date the model looks. Default 365. The worksheet, the job and the reports all propose this period. |

The description line at the top of each group explains what the model measures and which Business Central data it reads.

**Reset Thresholds to Defaults** sets all six models back to 80, 95 and 365.

## Counting Policy

| Field | Meaning |
|---|---|
| Update Phys. Invt. Counting Codes | When classes are applied, also set the **Phys Invt Counting Period Code** on the item according to the counting policy. Off by default. |
| Update SKU Counting Codes | Also set the counting period code on the item's stockkeeping units. Only used when the field above is on. |
| Counting Policy Code | The policy that maps model and class to a counting period. The default policy **DEFAULT** is created automatically. Typing a new code creates a new, empty policy. Use the assist edit button to open the policy. |

See [Counting policies](counting-policies) for details.

## Actions

| Action | What it does |
|---|---|
| ABC Worksheet | Opens the [worksheet](worksheet). |
| ABC History | Opens the [history](history) list. |
| Counting Policy | Opens the policy selected in Counting Policy Code. |
| ABC Analysis Report | Runs the ranked list report for one model. |
| Create/Enable Job Queue | Creates a job queue entry that runs the **GSO ABC Analysis Job** codeunit once a day and sets it to Ready. If the entry already exists it is set to Ready again. |
| Reset Thresholds to Defaults | Restores 80 / 95 / 365 for all models. |

## The daily job

The job queue entry recalculates all six models with their own periods and applies each result, exactly as if you had done it in the worksheet. Each run creates six history entries. If you only use some of the models, that is harmless, but you may prefer to delete old history entries from time to time, or disable the job and apply manually from the worksheet.

The job respects the **Enabled** field, **Manual Override** on items and the counting policy settings.
