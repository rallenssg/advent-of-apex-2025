@IsTest
public class VillageTask_IntegrationTest {
    @TestSetup
    static void makeData() {
        List<CAMPX__Village_Task__c> vTasks = new List<CAMPX__Village_Task__c>{
            new CAMPX__Village_Task__c(
                CAMPX__Is_Baby_Safety_Critical__c = false,
                CAMPX__Status__c = 'In Progress'
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Is_Baby_Safety_Critical__c = true,
                CAMPX__Status__c = 'Completed'
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Is_Baby_Safety_Critical__c = true,
                CAMPX__Status__c = 'In Progress'
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
                CAMPX__Due_Date__c = Date.today().addDays(7)
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'After Baby Arrives',
                CAMPX__Due_Date__c = null
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'Before Baby Arrives',
                CAMPX__Due_Date__c = null
            )
        };

        // Insert the test Village Task records
        Database.SaveResult[] insertResults = Database.insert(
            oldVTasks,
            false
        );
        
        // Verify that all records were inserted successfully
        for (Database.SaveResult sr : insertResults) {
            if (!sr.isSuccess()) {
                System.assert(
                    false,
                    'Error inserting Village Task record: ' + sr.getErrors()[0].getMessage()
                );
                return;
            }
        }

        // Query the inserted Village Task records to verify trigger logic
        Map<Id, CAMPX__Village_Task__c> insertedVTasks = (Map<Id,CAMPX__Village_Task__c>)
            btcdev.SOQL.of(CAMPX__Village_Task__c.SObjectType)
                .with(CAMPX__Village_Task__c.CAMPX__Support_Phase__c)
                .with(CAMPX__Village_Task__c.CAMPX__Due_Date__c)
                .whereAre(btcdev.SOQL.Filter.with(CAMPX__Village_Task__c.Id).isIn(oldVTasks))
                .toMap();

        System.assert(insertedVTasks != null, 'No Village Task records found for insert test.');

        System.assertEquals(3, insertedVTasks.size(), 'Expected 3 Village Task records for insert test. Found: ' + insertedVTasks.size());

        for(CAMPX__Village_Task__c oldVTask : oldVTasks) {
            CAMPX__Village_Task__c insertedVTask = insertedVTasks.get(oldVTask.Id);

            if (insertedVTask == null) {
                System.assert(
                    false,
                    'Inserted Village Task record with Id ' + oldVTask.Id + ' not found in database.'
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
}