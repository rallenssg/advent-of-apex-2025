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
}