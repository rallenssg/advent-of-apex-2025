# Day 5 Solution - Require Assignment Before Completion

## Approach / Solution Notes
I implemented the assignment validation by extending the existing TriggerHandler architecture with a new validation method. The approach leverages the established pattern of delegating business logic from the trigger handler to service classes and then to utility classes. I chose to add the validation logic to the existing `VillageTaskUtils` class and call it from both `beforeInsert` and `beforeUpdate` operations to ensure consistent validation across all save events.

The validation logic is straightforward - prevent any task from being marked as 'Completed' if the `CAMPX__Assigned_Character__c` field is blank or null. This maintains data integrity and enforces Grandma Kelly's business rule.

## Relevant Apex, Flow, or Metadata Details

### Trigger Modification
- **VillageTaskTrigger**: Added `before update` to the existing trigger events
```apex
trigger VillageTaskTrigger on CAMPX__Village_Task__c (before insert, before update, before delete) {
    new VillageTaskTriggerHandler().run();
}
```

### Handler Enhancement
- **VillageTaskTriggerHandler**: Added `beforeUpdate()` method following the TriggerHandler pattern
- Delegates to `VillageTaskService.handleBeforeUpdate()` with `Trigger.new` and `Trigger.oldMap`

### Service Layer Changes
- **VillageTaskService**: Refactored to use utility methods for better separation of concerns
- `handleBeforeInsert()`: Now calls `VillageTaskUtils.validateSave()` and `VillageTaskUtils.setDefaults()`
- `handleBeforeUpdate()`: New method that calls `VillageTaskUtils.validateSave()` for assignment validation
- `handleBeforeDelete()`: Refactored to call `VillageTaskUtils.validateDelete()`

### Core Validation Logic
- **VillageTaskUtils.validateSave()**: Public method that iterates through records and validates each one
- **VillageTaskUtils.isValidSave()**: Private method containing the core business logic
```apex
private static Boolean isValidSave(CAMPX__Village_Task__c vTask) {
    return (vTask == null) || !(String.isBlank(vTask.CAMPX__Assigned_Character__c) && vTask.CAMPX__Status__c == 'Completed');
}
```
- Uses `String.isBlank()` to catch both null and empty string values
- Returns false only when both conditions are met: blank assignment AND completed status
- Adds error message: "Cannot complete a task without assigning it to a villager first."

## Test Summaries
✅ **VillageTaskUtils_Test.cls** - Unit tests for utility methods:
- `test_isValidSave_validTasks()` - Validates assigned completed tasks, assigned in-progress tasks, and unassigned in-progress tasks
- `test_isValidSave_invalidTasks()` - Validates rejection of unassigned completed tasks and blank assigned completed tasks
- `test_isValidSave_nullTask()` - Ensures null task handling
- `test_validateSave_withTasks()` - Tests the public validation method with actual records
- `test_validateSave_nullList()` - Null list handling
- All existing deletion and defaulting tests maintained

✅ **VillageTaskService_Test.cls** - Integration tests for service methods:
- `test_handleBeforeInsert_integration()` - Validates both defaulting and validation work together on insert
- `test_handleBeforeUpdate_integration()` - Tests validation logic on update operations  
- `test_handleBeforeDelete_integration()` - Maintains existing deletion validation tests
- All tests use descriptive assertion messages with context

✅ **VillageTask_IntegrationTest.cls** - End-to-end database tests:
- `test_insertRecords()` - Tests bulk insert with mix of valid/invalid records, verifies validation failures
- `test_updateRecords()` - New comprehensive test for update scenarios including assignment validation
- `test_deleteRecords()` - Maintains existing deletion testing
- All tests use `Database.insert/update()` with `allOrNone = false` to test partial success scenarios

## Lessons Learned

1. **Consistent Validation Pattern**: By adding validation to both insert and update operations, the system maintains consistent business rules regardless of how records are modified. The same validation logic applies whether creating new completed tasks or updating existing tasks to completed status.

2. **TriggerHandler Architecture Benefits**: The established pattern made adding new functionality straightforward - I simply added a new handler method, service method, and utility validation without disrupting existing functionality. The separation of concerns keeps the codebase maintainable.

3. **Comprehensive Error Scenarios**: Testing both insert and update scenarios with `Database` operations and `allOrNone = false` provides realistic validation of error handling. The integration tests verify that valid records succeed while invalid records fail with appropriate error messages.

4. **Bulkification Considerations**: All validation logic handles collections properly, ensuring the solution works for both single record operations and bulk data loads. The utility methods iterate through record lists efficiently.

5. **String Validation Best Practices**: Using `String.isBlank()` instead of just checking for null ensures the validation catches both null values and empty strings, making the business rule more robust against different data entry scenarios.