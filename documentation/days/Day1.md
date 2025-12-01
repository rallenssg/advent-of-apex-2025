# Day 1 - Safety First Auto-Task Creator

## Challenge Description
Grandma Kelly is managing the Family Support App and wants to ensure that every high-priority Health & Safety plan gets an automatic safety review task assigned to the pediatrician, Dr. Grace Evergreen. She needs your help setting up the automation to do so.

### Before You Begin
Before you start building, make sure you:

Install the **[managed package in your org](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tHo000000hxfqIAA)** to create the sObjects, Apps, and Permission Sets you need for this challenge.

Assign yourself the `Family Support Manager` Permission Set from the package
Search for and open the `Family Support` app in the App Explorer. There you'll find the sObjects we'll be working with.

You'll complete this challenge in your connected Salesforce org. You can use Apex Trigger, or Record-Triggered Flows to implement the required automation.

Once you think your solution is working, come back here and click `Run Tests` to see how you did.

Create a record-triggered automation (using a Record-Triggered Flow or an Apex Trigger) that automatically creates a Village Task when certain conditions are met.

## Requirements
* **Trigger Event:** After a `Family Support Plan` is inserted
* **Conditions:** `Priority = 'High'` AND `Focus Area = 'Health & Safety'`
* **Action:** Create a new `Village Task` with these field values:
    * `Assigned Character` = 'Dr. Grace Evergreen'
    * `Status` = 'Not Started'
    * `Is Baby Safety Critical` = true
    * `Task Type` = 'Health & Safety Check'
    * `Support Phase` = Match the parent plan's Phase field
    * `Family Support Plan` = Link to the newly created plan

## Notes
* Use either a Record-Triggered Flow or an Apex Trigger (your choice!)
* Only trigger on insert (after insert context)
* Always link the Village Task to its parent via the Family Support Plan lookup field
* Handle bulk operations properly (multiple records inserted at once)
* Testing will insert records and query Village Task to verify your automation ran correctly

---

**[📋 View Solution Details](solutions/Day1_Solution.md)**