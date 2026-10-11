# Counting policies

A counting policy links ABC classes to physical inventory counting periods, so that A items are counted more often than C items. The app can set the counting period code on items and stockkeeping units automatically whenever classes are applied.

## Prerequisite

Create the counting periods first under **Phys. Invt. Counting Periods** in Business Central, for example MONTHLY with 12 counts per year, QUARTERLY with 4 and YEARLY with 1.

## The policy

Search for **ABC Counting Policies**. The policy **DEFAULT** is created automatically with one line for every combination of model and class, 24 lines in total, all with an empty counting period.

| Field | Meaning |
|---|---|
| Code, Description | Identify the policy. |
| Model | The model the line applies to. |
| Class | A, B, C or D. |
| Counting Period Code | The counting period to assign. Leave empty for combinations that should not change the item. |

A typical policy fills only the model you apply for counting, for example Revenue: A = MONTHLY, B = QUARTERLY, C = YEARLY, D empty.

You can create more than one policy, for example one per season, and switch between them in setup.

## Turning it on

In **ABC Analysis Setup**, group Counting Policy:

1. Select the policy in **Counting Policy Code**.
2. Turn on **Update Phys. Invt. Counting Codes**.
3. Turn on **Update SKU Counting Codes** if you count per location and use stockkeeping units.

From the next **Apply** in the worksheet, or the next job run, the counting period code is set on each item whose class has a period in the policy. Items are only modified when the code actually changes. Business Central then calculates the next counting start and end dates as usual, and the items appear in **Calculate Counting Period** on the physical inventory journal when due.

## Things to know

- Only one model should carry counting periods. If two models both have periods for class A, the model applied last wins.
- Items with **ABC Manual Override** are not touched.
- Turning the setting off does not clear counting period codes already written. Change them on the items if needed.
