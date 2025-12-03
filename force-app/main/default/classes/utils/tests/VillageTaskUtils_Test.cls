@IsTest
public class VillageTaskUtils_Test {
    @IsTest
    static void test_isValidDelete() {
        CAMPX__Village_Task__c nonCriticalTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = false,
            CAMPX__Status__c = 'In Progress'
        );
        CAMPX__Village_Task__c criticalCompletedTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'Completed'
        );
        CAMPX__Village_Task__c criticalInProgressTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'In Progress'
        );

        // Non-critical tasks can always be deleted
        System.assert(
            VillageTaskUtils.isValidDelete(nonCriticalTask),
            'Non-critical task should be valid for delete: \nRecord: ' + nonCriticalTask
        );

        // Critical tasks can be deleted only if completed
        System.assert(
            VillageTaskUtils.isValidDelete(criticalCompletedTask),
            'Critical completed task should be valid for delete: \nRecord: ' + criticalCompletedTask
        );
            
        System.assert(
            !VillageTaskUtils.isValidDelete(criticalInProgressTask),
            'Critical in progress task should not be valid for delete: \nRecord: ' + criticalInProgressTask
        );
    }
}