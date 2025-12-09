# Day 6 - Sync Phase to Tasks

## Challenge Description
Grandma Kelly just realized that when the `Family Support Plan's` `Phase` changes (maybe the baby arrived early!), all the related `Village Tasks` should also update to reflect the new phase. She needs your help to keep everything in sync!

Create a record-triggered automation that synchronizes the `Phase` from `Family Support Plan` to all related `Village Tasks`.

## Requirements
* **Trigger Event:** After a `Family Support Plan` is updated
* **Conditions:** The `Phase` field has changed
* **Action:** Update all related `Village Tasks` to set their `Support Phase` to match the parent plan's new Phase

## Notes
* Use an **After Update** trigger on `Family Support Plan`
* Check if `Phase` field has actually changed using `Trigger.oldMap` in Apex or `"Only when a record is updated to meet the condition requirements"` in Flow
* Query all related `Village Tasks` using the lookup relationship
* Update all related `Village Tasks` to match the new `Phase`
* Handle cases where there are no related tasks (don't error)
* Use bulk-safe patterns when updating child records

---

**[📋 View Solution Details](solutions/Day6_Solution.md)**