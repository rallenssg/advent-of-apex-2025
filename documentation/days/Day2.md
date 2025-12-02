# Day 2 - Task Auto-Assignment by Type

## Challenge Description
Grandma Kelly wants to streamline task assignment in the Family Support App. Instead of manually assigning every Village Task to a villager, she wants the system to automatically assign tasks based on their Task Type. Each villager has their specialty!

## Requirements
* **Trigger Event:** Before a `Village Task` is inserted
* **Conditions:** `Task Type` is populated
* **Action:** Set the `Assigned Character` based on `Task Type`:
    * `Task Type = 'Cook / Deliver Meal'` → `Assigned Character = 'Ginger Claus'`
    * `Task Type = 'Build / Fix'` → `Assigned Character = 'Stella Pinewood'`
    * `Task Type = 'Health & Safety Check'` → `Assigned Character = 'Dr. Grace Evergreen'`
    * `Task Type = 'Decorate'` → `Assigned Character = 'Poppy Wintergold'`
    * `Task Type = 'Garden / Outdoor'` → `Assigned Character = 'Ivy Evergreen'`
    * For all other `Task Types`, do not set `Assigned Character`

## Notes
* Use a **Before Insert** trigger to set the field value before the record is saved
* Only set Assigned Character for the specific Task Types listed above
* If the Task Type doesn't match any of the listed types, leave Assigned Character blank
* Handle bulk operations properly (multiple records at once)
* If Assigned Character is already set manually, respect that value (don't overwrite it)

---

**[📋 View Solution Details](solutions/Day2_Solution.md)**