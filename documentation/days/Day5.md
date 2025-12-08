# Day 5 - Require Assignment Before Completion

## Challenge Description
Grandma Kelly noticed that some `Village Tasks` are being marked as `'Completed'` without anyone actually being assigned to them! This doesn't make sense - how can a task be done if nobody was assigned to do it? She needs your help to add a validation rule.

Create a record-triggered automation that prevents Village Tasks from being marked as Completed without an assigned villager.

## Requirements
* **Trigger Event:** Before a `Village Task` is inserted or updated
* **Conditions:** `Status = 'Completed'` AND `Assigned Character` is blank
* **Action:** Prevent the save and display an error message
* **Error Message:** `"Cannot complete a task without assigning it to a villager first."`

## Notes
* Use a **Before Insert** and **Before Update** trigger
* Use `addError()` to display the error and prevent the save
* Validation should apply to both new records and updates
* Tasks with any other Status ('Not Started', 'In Progress', 'Blocked') can be saved without an assignment
* Handle bulk operations properly

---

**[📋 View Solution Details](solutions/Day5_Solution.md)**