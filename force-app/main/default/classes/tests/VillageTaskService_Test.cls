@IsTest
public class VillageTaskService_Test {
    @IsTest
    static void test_handleBeforeInsert_validPhaseWithDueDate() {
        CAMPX__Village_Task__c dueDateTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = Date.today().addDays(7)
        );

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                dueDateTask
            }
        );

        System.assert(
            dueDateTask.CAMPX__Due_Date__c == Date.today().addDays(7),
            'POPULATED DUE DATE TASK:\n' +
            'Due Date should not be updated when already populated:\n\t' +
                'Expected: ' + Date.today().addDays(7) + '\n' +
                'Actual: ' + dueDateTask.CAMPX__Due_Date__c
        );

        CAMPX__Village_Task__c dueDateTaskClone = dueDateTask.clone(false);

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                dueDateTask,
                dueDateTaskClone
            }
        );

        System.assert(
            dueDateTask.CAMPX__Due_Date__c == Date.today().addDays(7),
            'POPULATED DUE DATE TASKS:\n' +
            'Due Date should not be updated when already populated:\n\t' +
                'Expected: ' + Date.today().addDays(7) + '\n' +
                'Actual: ' + dueDateTask.CAMPX__Due_Date__c
        );

        System.assert(
            dueDateTaskClone.CAMPX__Due_Date__c == Date.today().addDays(7),
            'POPULATED DUE DATE TASKS:\n' +
            'Due Date should not be updated when already populated:\n\t' +
                'Expected: ' + Date.today().addDays(7) + '\n' +
                'Actual: ' + dueDateTaskClone.CAMPX__Due_Date__c
        );
    }

    @IsTest
    static void test_handleBeforeInsert_invalidPhase() {
        CAMPX__Village_Task__c invalidPhaseTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'After Baby Arrives',
            CAMPX__Due_Date__c = null
        );

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                invalidPhaseTask
            }
        );

        System.assert(
            invalidPhaseTask.CAMPX__Due_Date__c == null,
            'INVALID PHASE TASK:\n' +
            'Due Date should not be updated for invalid support phase tasks:\n\t' +
                'Phase: ' + invalidPhaseTask.CAMPX__Support_Phase__c + '\n' +
                'Expected: ' + null + '\n' +
                'Actual: ' + invalidPhaseTask.CAMPX__Due_Date__c
        );

        CAMPX__Village_Task__c invalidPhaseTask2 = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'After Baby Arrives',
            CAMPX__Due_Date__c = Date.today().addDays(7)
        );

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                invalidPhaseTask,
                invalidPhaseTask2
            }
        );

        System.assert(
            invalidPhaseTask.CAMPX__Due_Date__c == null,
            'INVALID PHASE TASKS:\n' +
            'Due Date should not be updated for invalid support phase tasks:\n\t' +
                'Phase: ' + invalidPhaseTask.CAMPX__Support_Phase__c + '\n' +
                'Expected: ' + null + '\n' +
                'Actual: ' + invalidPhaseTask.CAMPX__Due_Date__c
        );

        System.assert(
            invalidPhaseTask2.CAMPX__Due_Date__c == Date.today().addDays(7),
            'INVALID PHASE TASKS:\n' +
            'Due Date should not be updated for invalid support phase tasks:\n\t' +
                'Phase: ' + invalidPhaseTask2.CAMPX__Support_Phase__c + '\n' +
                'Expected: ' + Date.today().addDays(7) + '\n' +
                'Actual: ' + invalidPhaseTask2.CAMPX__Due_Date__c
        );
    }

    @IsTest
    static void test_handleBeforeInsert_validPhaseNullDueDate() {
        CAMPX__Village_Task__c nullDueDateTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = null
        );

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                nullDueDateTask
            }
        );

        System.assert(
            nullDueDateTask.CAMPX__Due_Date__c == Date.today().addDays(14),
            'NULL DUE DATE TASK:\n' +
            'Due Date should be set to 14 days from today for tasks in \'Before Baby Arrives\' phase with null due date:\n\t' +
                'Expected: ' + Date.today().addDays(14) + '\n' +
                'Actual: ' + nullDueDateTask.CAMPX__Due_Date__c
        );

        CAMPX__Village_Task__c nullDueDateTaskClone = nullDueDateTask.clone(false);

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                nullDueDateTask,
                nullDueDateTaskClone
            }
        );

        System.assert(
            nullDueDateTask.CAMPX__Due_Date__c == Date.today().addDays(14),
            'NULL DUE DATE TASKS:\n' +
            'Due Date should be set to 14 days from today for tasks in \'Before Baby Arrives\' phase with null due date:\n\t' +
                'Expected: ' + Date.today().addDays(14) + '\n' +
                'Actual: ' + nullDueDateTask.CAMPX__Due_Date__c
        );

        System.assert(
            nullDueDateTaskClone.CAMPX__Due_Date__c == Date.today().addDays(14),
            'NULL DUE DATE TASKS:\n' +
            'Due Date should be set to 14 days from today for tasks in \'Before Baby Arrives\' phase with null due date:\n\t' +
                'Expected: ' + Date.today().addDays(14) + '\n' +
                'Actual: ' + nullDueDateTaskClone.CAMPX__Due_Date__c
        );
    }

    @IsTest
    static void test_handleBeforeInsert_mixedTasks() {
        CAMPX__Village_Task__c dueDateTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = Date.today().addDays(7)
        );
        CAMPX__Village_Task__c invalidPhaseTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'After Baby Arrives',
            CAMPX__Due_Date__c = null
        );
        CAMPX__Village_Task__c nullDueDateTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = null
        );

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                nullDueDateTask,
                dueDateTask,
                invalidPhaseTask
            }
        );

        System.assert(
            dueDateTask.CAMPX__Due_Date__c == Date.today().addDays(7),
            'MIXED TASKS:\n' +
            'Due Date should not be updated when already populated:\n\t' +
                'Expected: ' + Date.today().addDays(7) + '\n' +
                'Actual: ' + dueDateTask.CAMPX__Due_Date__c
        );

        System.assert(
            invalidPhaseTask.CAMPX__Due_Date__c == null,
            'MIXED TASKS:\n' +
            'Due Date should not be updated for invalid support phase tasks:\n\t' +
                'Phase: ' + invalidPhaseTask.CAMPX__Support_Phase__c + '\n' +
                'Expected: ' + null + '\n' +
                'Actual: ' + invalidPhaseTask.CAMPX__Due_Date__c
        );

        System.assert(
            nullDueDateTask.CAMPX__Due_Date__c == Date.today().addDays(14),
            'MIXED TASKS:\n' +
            'Due Date should be set to 14 days from today for tasks in \'Before Baby Arrives\' phase with null due date:\n\t' +
                'Expected: ' + Date.today().addDays(14) + '\n' +
                'Actual: ' + nullDueDateTask.CAMPX__Due_Date__c
        );
    }

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
            'VALID TASK:\n' +
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
            'VALID TASK:\n' +
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
            'VALID TASKS:\n' +
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
            'INVALID TASK:\n' +
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
            'INVALID TASKS:\n' +
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