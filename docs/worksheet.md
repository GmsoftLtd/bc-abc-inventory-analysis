# ABC Worksheet

Search for **ABC Worksheet**. The worksheet is where you calculate a classification, review it and apply it. Nothing is written to items until you choose **Apply**.

## Calculate

Choose **Calculate**. A dialog asks for:

| Field | Meaning |
|---|---|
| ABC Model | Which model to rank by. Changing the model resets the dates below to that model's period from setup. |
| Start Date | First posting date included. |
| End Date | Last posting date included. Defaults to the work date. |

The worksheet then shows one line per item, sorted by value with the highest first. The group at the top shows which model and dates the lines belong to.

| Column | Meaning |
|---|---|
| Item No., Description | The item. |
| Value | The item's value for the model and period, for example its sales amount. |
| Value % | The item's share of the total value. |
| Cum. % | Running total of Value % down the list. This number decides the class. |
| Class | The class that will be applied: A, B, C or D. |

Items are listed only if they are not blocked, not marked **Exclude from ABC**, and, when *Exclude Non-Inventory Items* is on, of type Inventory. Items with no value appear as class D when *Class Zero Consumption as D* is on, otherwise they do not appear.

## Statistics

The **Statistics** factbox summarises the preview by class: number of items, share of items, total value, share of value, and the cumulative shares. A healthy Pareto distribution shows class A with a small share of items and a large share of value.

## Export to Excel

Creates a workbook with two sheets, **Preview** with all lines and **Statistics** with the factbox figures, and opens it in Excel Online or downloads it.

## Apply to Items/SKUs

After confirming, the app does the following for every line:

1. Writes the class to the item's class field for the model, for example **ABC Class (Revenue)**, and stamps **ABC Last Calculated (Revenue)** with the current time.
2. Writes the same class and time to every stockkeeping unit of the item.
3. If **Update Phys. Invt. Counting Codes** is on in setup and the counting policy has a period for this model and class, sets the item's counting period code, and the stockkeeping units' codes when **Update SKU Counting Codes** is also on.
4. Records the line in [ABC History](history).

Items with **ABC Manual Override** on the item card are recorded in history but not changed.

Finally the **Last Run** field in setup is updated and a message tells you how many items were updated.

## Fields on the item and stockkeeping unit

The **ABC Classification** group on the item card and the stockkeeping unit card shows the class and the last calculation time per model. The item list shows the class columns, with GMROII and Pick Frequency hidden by default; use **Personalize** to show them.

| Field | Meaning |
|---|---|
| ABC Class (model) | The class last applied for that model. Blank means never classified. Read-only. |
| ABC Last Calculated (model) | When that class was applied. Read-only. |
| ABC Manual Override | Item card only. Keep the classes as they are; the worksheet and the job will not change them. |
| Exclude from ABC | Item card only. Leave the item out of every calculation. |

## Tips

- Run the model that matches how you manage stock. A distributor usually starts with Revenue or Gross Profit, a manufacturer with Usage Value, a warehouse team with Pick Frequency.
- Calculate for a full year first. Short periods exaggerate seasonal items.
- Use the Comparison report to see where models disagree before you choose one for counting policies.
