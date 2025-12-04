# Day 4 - Auto-Set Task Due Date

## Challenge Description
Grandma Kelly wants to ensure all pre-arrival `Village Tasks` have reasonable deadlines. She's decided that any task scheduled for `'Before Baby Arrives'` should automatically have a due date set to 14 days from creation, giving the village plenty of time to prepare!

Create a record-triggered automation that automatically sets `Due Date` for pre-arrival `Village Tasks`.

## Requirements
* **Trigger Event:** Before a `Village Task` is inserted
* **Conditions:** `Support Phase = 'Before Baby Arrives'` AND `Due Date is blank`
* **Action:** Set `Due Date` to 14 days from today

## Notes
* Use a **Before Insert** trigger to set the field before saving
* Use `Date.today().addDays(14)` in Apex or equivalent in Flow
* Only set `Due Date` if it's currently blank (`null`)
* Do not overwrite manually entered Due Dates
* Handle bulk operations properly

---

**[📋 View Solution Details](solutions/Day4_Solution.md)**