# Day 3 - Prevent Safety Task Deletion

## Challenge Description
Grandma Kelly is concerned that someone might accidentally delete critical safety tasks for Baby Shaya! She wants to make sure that any `Village Task` marked as safety-critical cannot be deleted unless it's already been completed.

Create a record-triggered automation that prevents deletion of incomplete safety-critical `Village Tasks`.

## Requirements
* **Trigger Event:** Before a `Village Task` is deleted
* **Conditions:** `Is Baby Safety Critical = true` AND `Status != 'Completed'`
* **Action:** Prevent the deletion and display an error message
* **Error Message:** `"Cannot delete safety-critical tasks that are not completed. Please complete the task first or contact your administrator."`

## Notes
* Use a Before Delete trigger to validate before the record is removed
* Use `addError()` method to display the error message and prevent deletion
* A task can only be deleted if it's EITHER not safety-critical OR already completed
* Handle bulk delete operations properly
* The exact error message text must match the requirement above

---

**[📋 View Solution Details](solutions/Day3_Solution.md)**