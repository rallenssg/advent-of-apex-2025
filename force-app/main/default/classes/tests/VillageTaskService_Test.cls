@IsTest
public class VillageTaskService_Test {
    @IsTest
    static void test_handleBeforeDelete_validTasks() {
        CAMPX__Village_Task__c nonCriticalTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = false,
            CAMPX__Status__c = 'In Progress'
        );
        CAMPX__Village_Task__c criticalCompletedTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'Completed'
        );

        VillageTaskService.handleBeforeDelete(
            new List<CAMPX__Village_Task__c>{
                nonCriticalTask
            }
        );

        System.assert(
            !hasErrors(nonCriticalTask),
            'VALID TASKS SINGLE:\n' +
            'Non-critical task should not have errors:\n\t' +
                'Record: ' + nonCriticalTask + '\n' +
                'Errors: ' + nonCriticalTask.getErrors()
        );

        VillageTaskService.handleBeforeDelete(
            new List<CAMPX__Village_Task__c>{
                criticalCompletedTask
            }
        );

        System.assert(
            !hasErrors(criticalCompletedTask),
            'VALID TASKS SINGLE:\n' +
            'Critical completed task should not have errors:\n\t' +
                'Record: ' + criticalCompletedTask + '\n' +
                'Errors: ' + criticalCompletedTask.getErrors()
        );

        VillageTaskService.handleBeforeDelete(
            new List<CAMPX__Village_Task__c>{
                nonCriticalTask,
                criticalCompletedTask
            }
        );

        System.assert(
            !hasErrors(nonCriticalTask) && !hasErrors(criticalCompletedTask),
            'VALID TASKS MULTI:\n' +
            'Non-critical and critical completed tasks should not have errors:\n\t' +
                'Record1: ' + nonCriticalTask + '\n\t' +
                    'Errors: ' + nonCriticalTask.getErrors() + '\n' +
                'Record2: ' + criticalCompletedTask + '\n\t' +
                    'Errors: ' + criticalCompletedTask.getErrors()
        );
    }

    @IsTest
    static void test_handleBeforeDelete_invalidTasks() {
        CAMPX__Village_Task__c criticalInProgressTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'In Progress'
        );

        VillageTaskService.handleBeforeDelete(
            new List<CAMPX__Village_Task__c>{
                criticalInProgressTask
            }
        );

        System.assert(
            hasErrors(criticalInProgressTask),
            'INVALID TASKS SINGLE:\n' +
            'Critical in-progress task should have errors:\n\t' +
                'Record: ' + criticalInProgressTask
        );

        CAMPX__Village_Task__c criticalInProgressTask2 = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'In Progress'
        );

        VillageTaskService.handleBeforeDelete(
            new List<CAMPX__Village_Task__c>{
                criticalInProgressTask,
                criticalInProgressTask2
            }
        );

        System.assert(
            hasErrors(criticalInProgressTask) && hasErrors(criticalInProgressTask2),
            'INVALID TASKS MULTI:\n' +
            'Critical in-progress task should have 2 errors:\n\t' +
                'Record1: ' + criticalInProgressTask + '\n\t' +
                'Errors: ' + criticalInProgressTask.getErrors() + '\n' +
                'Record2: ' + criticalInProgressTask2 + '\n\t' +
                'Errors: ' + criticalInProgressTask2.getErrors()
        );
    }

    @IsTest
    static void test_handleBeforeDelete_mixedTasks() {
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

        VillageTaskService.handleBeforeDelete(
            new List<CAMPX__Village_Task__c>{
                nonCriticalTask,
                criticalCompletedTask,
                criticalInProgressTask
            }
        );

        System.assert(
            !hasErrors(nonCriticalTask),
            'MIXED TASKS:\n' +
            'Non-critical task should not have errors:\n\t' +
                'Record: ' + nonCriticalTask + '\n' +
                'Errors: ' + nonCriticalTask.getErrors()
        );

        System.assert(
            !hasErrors(criticalCompletedTask),
            'MIXED TASKS:\n' +
            'Critical completed task should not have errors:\n\t' +
                'Record: ' + criticalCompletedTask + '\n' +
                'Errors: ' + criticalCompletedTask.getErrors()
        );

        System.assert(
            hasErrors(criticalInProgressTask),
            'MIXED TASKS:\n' +
            'Critical in-progress task should have errors:\n\t' +
                'Record: ' + criticalInProgressTask + '\n' +
                'Errors: ' + criticalInProgressTask.getErrors()
        );
    }

    private static Boolean hasErrors(CAMPX__Village_Task__c vTask) {
        return vTask.getErrors().size() > 0;
    }
}