@IsTest
public class VillageTask_IntegrationTest {
    @TestSetup
    static void makeData() {
        List<CAMPX__Village_Task__c> vTasks = new List<CAMPX__Village_Task__c>{
            new CAMPX__Village_Task__c(
                CAMPX__Is_Baby_Safety_Critical__c = false,
                CAMPX__Status__c = 'In Progress',
                CAMPX__Assigned_Character__c = 'Grandma Kelly'
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Is_Baby_Safety_Critical__c = true,
                CAMPX__Status__c = 'Completed',
                CAMPX__Assigned_Character__c = 'Dr. Grace Evergreen'
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Is_Baby_Safety_Critical__c = true,
                CAMPX__Status__c = 'In Progress',
                CAMPX__Assigned_Character__c = 'Monica McPatchwork'
            )
        };

        try {
            insert vTasks;
        } catch (Exception e) {
            System.assert(false, 'Error inserting test Village Task records: ' + e.getMessage());
        }
    }

    @IsTest
    static void test_deleteRecords() {
        Map<Id, CAMPX__Village_Task__c> vTasks = (Map<Id, CAMPX__Village_Task__c>) btcdev.SOQL.of(CAMPX__Village_Task__c.SObjectType)
            .with(CAMPX__Village_Task__c.Id, CAMPX__Village_Task__c.CAMPX__Is_Baby_Safety_Critical__c, CAMPX__Village_Task__c.CAMPX__Status__c)
            .toMap();

        System.assertNotEquals(null, vTasks, 'No Village Task records found for deletion test.');

        System.assertEquals(3, vTasks.size(), 'Expected 3 Village Task records for deletion test. Found: ' + vTasks.size());

        Database.DeleteResult[] results = Database.delete(
            vTasks.values(),
            false
        );

        System.assertEquals(3, results.size(), 'Expected 3 delete results. Found: ' + results.size());

        for(Database.DeleteResult dr : results) {
            if(dr.isSuccess()) {
                System.assert(
                    (vTasks.get(dr.getId()).CAMPX__Is_Baby_Safety_Critical__c == false) ||
                        (vTasks.get(dr.getId()).CAMPX__Status__c == 'Completed'),
                    'Record with Id ' + dr.getId() + ' should have been deleted:\n\t' +
                        'Record: ' + vTasks.get(dr.getId())
                );
            } else {
                System.assert(
                    (vTasks.get(dr.getId()).CAMPX__Is_Baby_Safety_Critical__c == true) &&
                        (vTasks.get(dr.getId()).CAMPX__Status__c != 'Completed'),
                    'Record with Id ' + dr.getId() + ' should not have been deleted:\n\t' +
                        'Record: ' + vTasks.get(dr.getId())
                );
            }
        }
    }

    @IsTest
    static void test_insertRecords() {

        // Prepare test Village Task records for insertion
        List<CAMPX__Village_Task__c> oldVTasks = new List<CAMPX__Village_Task__c>{
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'Before Baby Arrives',
                CAMPX__Due_Date__c = Date.today().addDays(7),
                CAMPX__Assigned_Character__c = 'Grandma Kelly',
                CAMPX__Status__c = 'In Progress'
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'After Baby Arrives',
                CAMPX__Due_Date__c = null,
                CAMPX__Assigned_Character__c = 'Dr. Grace Evergreen',
                CAMPX__Status__c = 'Not Started'
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'Before Baby Arrives',
                CAMPX__Due_Date__c = null,
                CAMPX__Assigned_Character__c = null,
                CAMPX__Status__c = 'In Progress'
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'Before Baby Arrives',
                CAMPX__Due_Date__c = null,
                CAMPX__Assigned_Character__c = null,
                CAMPX__Status__c = 'Completed'
            )
        };

        // Insert the test Village Task records
        Database.SaveResult[] insertResults = Database.insert(
            oldVTasks,
            false
        );
        
        // Verify insert results - some should succeed, some should fail based on validation
        Integer expectedFailures = 0;
        for (Integer i = 0; i < insertResults.size(); i++) {
            Database.SaveResult sr = insertResults[i];
            CAMPX__Village_Task__c oldVTask = oldVTasks[i];
            
            if (String.isBlank(oldVTask.CAMPX__Assigned_Character__c) && oldVTask.CAMPX__Status__c == 'Completed') {
                // Should fail validation - completed task without assigned character
                expectedFailures++;
                System.assert(
                    !sr.isSuccess(),
                    'Expected validation error for completed task without assigned character:\n\t' +
                        'Record: ' + oldVTask + '\n\t' +
                        'Errors: ' + sr.getErrors()
                );
            } else {
                // Should succeed
                System.assert(
                    sr.isSuccess(),
                    'Expected successful insert for valid record:\n\t' +
                        'Record: ' + oldVTask + '\n\t' +
                        'Error: ' + (sr.getErrors().size() > 0 ? sr.getErrors()[0].getMessage() : 'Unknown error')
                );
            }
        }

        // Get list of successfully inserted record IDs
        List<Id> successfulIds = new List<Id>();
        for (Database.SaveResult sr : insertResults) {
            if (sr.isSuccess()) {
                successfulIds.add(sr.getId());
            }
        }

        // Query the inserted Village Task records to verify trigger logic
        Map<Id, CAMPX__Village_Task__c> insertedVTasks = (Map<Id,CAMPX__Village_Task__c>)
            btcdev.SOQL.of(CAMPX__Village_Task__c.SObjectType)
                .with(CAMPX__Village_Task__c.CAMPX__Support_Phase__c)
                .with(CAMPX__Village_Task__c.CAMPX__Due_Date__c)
                .with(CAMPX__Village_Task__c.CAMPX__Assigned_Character__c)
                .with(CAMPX__Village_Task__c.CAMPX__Status__c)
                .whereAre(btcdev.SOQL.Filter.with(CAMPX__Village_Task__c.Id).isIn(successfulIds))
                .toMap();

        System.assert(insertedVTasks != null, 'No Village Task records found for insert test.');

        Integer expectedSuccessful = oldVTasks.size() - expectedFailures;
        System.assertEquals(expectedSuccessful, insertedVTasks.size(), 'Expected ' + expectedSuccessful + ' successfully inserted Village Task records. Found: ' + insertedVTasks.size());

        for(CAMPX__Village_Task__c oldVTask : oldVTasks) {
            // Skip validation check for records that should have failed insertion
            if (String.isBlank(oldVTask.CAMPX__Assigned_Character__c) && oldVTask.CAMPX__Status__c == 'Completed') {
                continue;
            }
            
            CAMPX__Village_Task__c insertedVTask = insertedVTasks.get(oldVTask.Id);

            if (insertedVTask == null) {
                System.assert(
                    false,
                    'Successfully inserted Village Task record with Id ' + oldVTask.Id + ' not found in database.'
                );
                continue;
            }

            switch on insertedVTask.CAMPX__Support_Phase__c {
                when 'Before Baby Arrives' {
                    if (oldVTask.CAMPX__Due_Date__c == null) {
                        System.assertEquals(
                            Date.today().addDays(14),
                            insertedVTask.CAMPX__Due_Date__c,
                            'Due Date should have been set for Village Task with Support Phase "Before Baby Arrives".\n\t' +
                                'Old Record: ' + oldVTask + '\n' +
                                'Inserted Record: ' + insertedVTask
                        );
                    } else {
                        System.assertEquals(
                            oldVTask.CAMPX__Due_Date__c,
                            insertedVTask.CAMPX__Due_Date__c,
                            'Due Date should not have been modified for Village Task with Support Phase "Before Baby Arrives" and pre-populated Due Date.\n\t' +
                                'Old Record: ' + oldVTask + '\n' +
                                'Inserted Record: ' + insertedVTask
                        );
                    }
                }
                when else {
                    System.assertEquals(
                        oldVTask.CAMPX__Due_Date__c,
                        insertedVTask.CAMPX__Due_Date__c,
                        'Due Date should not have been modified for Village Task with Support Phase "' + insertedVTask.CAMPX__Support_Phase__c + '".\n\t' +
                            'Old Record: ' + oldVTask + '\n' +
                            'Inserted Record: ' + insertedVTask
                    );
                }
            }
        }
    }

    @IsTest
    static void test_updateRecords() {
        // Get the existing test records from TestSetup
        Map<Id, CAMPX__Village_Task__c> existingVTasks = (Map<Id, CAMPX__Village_Task__c>) btcdev.SOQL.of(CAMPX__Village_Task__c.SObjectType)
            .with(CAMPX__Village_Task__c.Id, CAMPX__Village_Task__c.CAMPX__Is_Baby_Safety_Critical__c, CAMPX__Village_Task__c.CAMPX__Status__c)
            .with(CAMPX__Village_Task__c.CAMPX__Assigned_Character__c)
            .toMap();

        System.assertNotEquals(null, existingVTasks, 'No Village Task records found for update test.');
        System.assertEquals(3, existingVTasks.size(), 'Expected 3 Village Task records for update test. Found: ' + existingVTasks.size());

        // Prepare records for update - some valid, some invalid
        List<CAMPX__Village_Task__c> vTasksToUpdate = new List<CAMPX__Village_Task__c>();
        for (CAMPX__Village_Task__c vTask : existingVTasks.values()) {
            CAMPX__Village_Task__c updateTask = vTask.clone(true, true, false, false);
            
            if (!vTask.CAMPX__Is_Baby_Safety_Critical__c) {
                // Valid update - assign character and complete non-critical task
                updateTask.CAMPX__Assigned_Character__c = 'Monica McPatchwork';
                updateTask.CAMPX__Status__c = 'Completed';
            } else if (vTask.CAMPX__Status__c == 'Completed') {
                // Valid update - change assigned character for completed critical task
                updateTask.CAMPX__Assigned_Character__c = 'Dr. Grace Evergreen';
            } else {
                // Invalid update - try to complete critical task without assignment
                updateTask.CAMPX__Assigned_Character__c = '';
                updateTask.CAMPX__Status__c = 'Completed';
            }
            vTasksToUpdate.add(updateTask);
        }

        // Perform the update
        Database.SaveResult[] updateResults = Database.update(
            vTasksToUpdate,
            false
        );

        System.assertEquals(3, updateResults.size(), 'Expected 3 update results. Found: ' + updateResults.size());

        // Verify update results
        for (Integer i = 0; i < updateResults.size(); i++) {
            Database.SaveResult sr = updateResults[i];
            CAMPX__Village_Task__c updateTask = vTasksToUpdate[i];
            CAMPX__Village_Task__c originalTask = existingVTasks.get(updateTask.Id);

            if (String.isBlank(updateTask.CAMPX__Assigned_Character__c) && updateTask.CAMPX__Status__c == 'Completed') {
                // Should fail validation - completed task without assigned character
                System.assert(
                    !sr.isSuccess(),
                    'Expected validation error for completed task without assigned character:\n\t' +
                        'Original: ' + originalTask + '\n\t' +
                        'Update: ' + updateTask + '\n\t' +
                        'Errors: ' + sr.getErrors()
                );
            } else {
                // Should succeed
                System.assert(
                    sr.isSuccess(),
                    'Expected successful update for valid record:\n\t' +
                        'Original: ' + originalTask + '\n\t' +
                        'Update: ' + updateTask + '\n\t' +
                        'Error: ' + (sr.getErrors().size() > 0 ? sr.getErrors()[0].getMessage() : 'Unknown error')
                );
            }
        }

        // Query updated records to verify changes were applied
        List<Id> successfulIds = new List<Id>();
        for (Database.SaveResult sr : updateResults) {
            if (sr.isSuccess()) {
                successfulIds.add(sr.getId());
            }
        }

        Map<Id, CAMPX__Village_Task__c> updatedVTasks = (Map<Id, CAMPX__Village_Task__c>) btcdev.SOQL.of(CAMPX__Village_Task__c.SObjectType)
            .with(CAMPX__Village_Task__c.Id, CAMPX__Village_Task__c.CAMPX__Is_Baby_Safety_Critical__c, CAMPX__Village_Task__c.CAMPX__Status__c)
            .with(CAMPX__Village_Task__c.CAMPX__Assigned_Character__c)
            .whereAre(btcdev.SOQL.Filter.with(CAMPX__Village_Task__c.Id).isIn(successfulIds))
            .toMap();

        // Verify the updates were applied correctly
        for (Id taskId : successfulIds) {
            CAMPX__Village_Task__c originalTask = existingVTasks.get(taskId);
            CAMPX__Village_Task__c updatedTask = updatedVTasks.get(taskId);
            CAMPX__Village_Task__c expectedTask = null;
            
            // Find the expected update for this task
            for (CAMPX__Village_Task__c vTask : vTasksToUpdate) {
                if (vTask.Id == taskId) {
                    expectedTask = vTask;
                    break;
                }
            }

            System.assertNotEquals(
                null,
                updatedTask,
                'Updated Village Task record with Id ' + taskId + ' not found in database.'
            );

            System.assertEquals(
                expectedTask.CAMPX__Assigned_Character__c,
                updatedTask.CAMPX__Assigned_Character__c,
                'Assigned Character should have been updated:\n\t' +
                    'Original: ' + originalTask + '\n\t' +
                    'Expected: ' + expectedTask + '\n\t' +
                    'Actual: ' + updatedTask
            );

            System.assertEquals(
                expectedTask.CAMPX__Status__c,
                updatedTask.CAMPX__Status__c,
                'Status should have been updated:\n\t' +
                    'Original: ' + originalTask + '\n\t' +
                    'Expected: ' + expectedTask + '\n\t' +
                    'Actual: ' + updatedTask
            );
        }
    }
}