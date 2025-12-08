@IsTest
public class VillageTaskUtils_Test {
    @IsTest
    static void test_isValidSave_validTasks() {
        CAMPX__Village_Task__c validCompletedTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = 'Grandma Kelly',
            CAMPX__Status__c = 'Completed'
        );
        CAMPX__Village_Task__c validInProgressTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = 'Dr. Grace Evergreen',
            CAMPX__Status__c = 'In Progress'
        );
        CAMPX__Village_Task__c unassignedInProgressTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = null,
            CAMPX__Status__c = 'In Progress'
        );

        System.assert(
            VillageTaskUtils.isValidSave(validCompletedTask),
            'VALID SAVE:\n' +
            'Task assigned to character and completed should be valid for save:\n\t' +
                'Record: ' + validCompletedTask
        );

        System.assert(
            VillageTaskUtils.isValidSave(validInProgressTask),
            'VALID SAVE:\n' +
            'Task assigned to character and in progress should be valid for save:\n\t' +
                'Record: ' + validInProgressTask
        );

        System.assert(
            VillageTaskUtils.isValidSave(unassignedInProgressTask),
            'VALID SAVE:\n' +
            'Task unassigned and in progress should be valid for save:\n\t' +
                'Record: ' + unassignedInProgressTask
        );
    }

    @IsTest
    static void test_isValidSave_invalidTasks() {
        CAMPX__Village_Task__c invalidTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = null,
            CAMPX__Status__c = 'Completed'
        );

        System.assert(
            !VillageTaskUtils.isValidSave(invalidTask),
            'INVALID SAVE:\n' +
            'Completed task without assigned character should not be valid for save:\n\t' +
                'Record: ' + invalidTask
        );

        CAMPX__Village_Task__c invalidTask2 = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = '',
            CAMPX__Status__c = 'Completed'
        );

        System.assert(
            !VillageTaskUtils.isValidSave(invalidTask2),
            'INVALID SAVE:\n' +
            'Completed task with blank assigned character should not be valid for save:\n\t' +
                'Record: ' + invalidTask2
        );
    }

    @IsTest
    static void test_isValidSave_nullTask() {
        System.assert(
            VillageTaskUtils.isValidSave(null),
            'VALID SAVE:\n' +
            'Null task should be valid for save (null check handling)'
        );
    }

    @IsTest
    static void test_isValidDelete_validTasks() {
        CAMPX__Village_Task__c nonCriticalTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = false,
            CAMPX__Status__c = 'In Progress'
        );
        CAMPX__Village_Task__c criticalCompletedTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'Completed'
        );

        System.assert(
            VillageTaskUtils.isValidDelete(nonCriticalTask),
            'VALID DELETE:\n' +
            'Non-critical task should be valid for delete:\n\t' +
                'Record: ' + nonCriticalTask
        );

        System.assert(
            VillageTaskUtils.isValidDelete(criticalCompletedTask),
            'VALID DELETE:\n' +
            'Critical completed task should be valid for delete:\n\t' +
                'Record: ' + criticalCompletedTask
        );
    }

    @IsTest
    static void test_isValidDelete_invalidTasks() {
        CAMPX__Village_Task__c criticalInProgressTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'In Progress'
        );

        System.assert(
            !VillageTaskUtils.isValidDelete(criticalInProgressTask),
            'INVALID DELETE:\n' +
            'Critical in-progress task should not be valid for delete:\n\t' +
                'Record: ' + criticalInProgressTask
        );

        CAMPX__Village_Task__c criticalNotStartedTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'Not Started'
        );

        System.assert(
            !VillageTaskUtils.isValidDelete(criticalNotStartedTask),
            'INVALID DELETE:\n' +
            'Critical not started task should not be valid for delete:\n\t' +
                'Record: ' + criticalNotStartedTask
        );
    }

    @IsTest
    static void test_isValidDelete_nullTask() {
        System.assert(
            !VillageTaskUtils.isValidDelete(null),
            'INVALID DELETE:\n' +
            'Null task should not be valid for delete (null check handling)'
        );
    }

    @IsTest
    static void test_defaultDueDate_validPhaseNullDueDate() {
        CAMPX__Village_Task__c nullDueDateTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = null
        );

        VillageTaskUtils.defaultDueDate(nullDueDateTask);

        System.assert(
            nullDueDateTask.CAMPX__Due_Date__c == Date.today().addDays(14),
            'DEFAULT DUE DATE:\n' +
            'Due Date should be set to 14 days from today for tasks in \'Before Baby Arrives\' phase with null due date:\n\t' +
                'Expected: ' + Date.today().addDays(14) + '\n' +
                'Actual: ' + nullDueDateTask.CAMPX__Due_Date__c
        );
    }

    @IsTest
    static void test_defaultDueDate_validPhaseWithDueDate() {
        CAMPX__Village_Task__c dueDateTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = Date.today().addDays(7)
        );

        VillageTaskUtils.defaultDueDate(dueDateTask);

        System.assert(
            dueDateTask.CAMPX__Due_Date__c == Date.today().addDays(7),
            'DEFAULT DUE DATE:\n' +
            'Due Date should not be updated when already populated:\n\t' +
                'Expected: ' + Date.today().addDays(7) + '\n' +
                'Actual: ' + dueDateTask.CAMPX__Due_Date__c
        );
    }

    @IsTest
    static void test_defaultDueDate_invalidPhase() {
        CAMPX__Village_Task__c invalidPhaseTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'After Baby Arrives',
            CAMPX__Due_Date__c = null
        );

        VillageTaskUtils.defaultDueDate(invalidPhaseTask);

        System.assert(
            invalidPhaseTask.CAMPX__Due_Date__c == null,
            'DEFAULT DUE DATE:\n' +
            'Due Date should not be updated for invalid support phase tasks:\n\t' +
                'Phase: ' + invalidPhaseTask.CAMPX__Support_Phase__c + '\n' +
                'Expected: ' + null + '\n' +
                'Actual: ' + invalidPhaseTask.CAMPX__Due_Date__c
        );
    }

    @IsTest
    static void test_defaultDueDate_nullTask() {
        // Test null handling - should not throw exception
        VillageTaskUtils.defaultDueDate(null);
        
        System.assert(true, 'DEFAULT DUE DATE:\ndefaultDueDate should handle null task without throwing exception');
    }

    @IsTest
    static void test_validateSave_nullList() {
        // Test null list handling - should not throw exception
        VillageTaskUtils.validateSave(null);
        
        System.assert(true, 'VALIDATE SAVE:\nvalidateSave should handle null list without throwing exception');
    }

    @IsTest
    static void test_validateDelete_nullList() {
        // Test null list handling - should not throw exception
        VillageTaskUtils.validateDelete(null);
        
        System.assert(true, 'VALIDATE DELETE:\nvalidateDelete should handle null list without throwing exception');
    }

    @IsTest
    static void test_setDefaults_nullList() {
        // Test null list handling - should not throw exception
        VillageTaskUtils.setDefaults(null);
        
        System.assert(true, 'SET DEFAULTS:\nsetDefaults should handle null list without throwing exception');
    }

    @IsTest
    static void test_validateSave_withTasks() {
        // Test the public validateSave method with actual tasks
        CAMPX__Village_Task__c validTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = 'Grandma Kelly',
            CAMPX__Status__c = 'Completed'
        );
        
        CAMPX__Village_Task__c invalidTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = null,
            CAMPX__Status__c = 'Completed'
        );
        
        List<CAMPX__Village_Task__c> tasks = new List<CAMPX__Village_Task__c>{validTask, invalidTask};
        
        VillageTaskUtils.validateSave(tasks);
        
        System.assert(
            !hasErrors(validTask),
            'VALIDATE SAVE WITH TASKS:\nValid task should not have errors'
        );
        
        System.assert(
            hasErrors(invalidTask),
            'VALIDATE SAVE WITH TASKS:\nInvalid task should have errors'
        );
    }

    @IsTest
    static void test_validateDelete_withTasks() {
        // Test the public validateDelete method with actual tasks
        CAMPX__Village_Task__c validTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = false,
            CAMPX__Status__c = 'In Progress'
        );
        
        CAMPX__Village_Task__c invalidTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'In Progress'
        );
        
        List<CAMPX__Village_Task__c> tasks = new List<CAMPX__Village_Task__c>{validTask, invalidTask};
        
        VillageTaskUtils.validateDelete(tasks);
        
        System.assert(
            !hasErrors(validTask),
            'VALIDATE DELETE WITH TASKS:\nValid task should not have errors'
        );
        
        System.assert(
            hasErrors(invalidTask),
            'VALIDATE DELETE WITH TASKS:\nInvalid task should have errors'
        );
    }

    @IsTest
    static void test_setDefaults_withTasks() {
        // Test the public setDefaults method with actual tasks
        CAMPX__Village_Task__c taskWithNullDate = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = null
        );
        
        CAMPX__Village_Task__c taskWithDate = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = Date.today().addDays(7)
        );
        
        List<CAMPX__Village_Task__c> tasks = new List<CAMPX__Village_Task__c>{taskWithNullDate, taskWithDate};
        
        VillageTaskUtils.setDefaults(tasks);
        
        System.assertEquals(
            Date.today().addDays(14),
            taskWithNullDate.CAMPX__Due_Date__c,
            'SET DEFAULTS WITH TASKS:\nTask with null date should be defaulted'
        );
        
        System.assertEquals(
            Date.today().addDays(7),
            taskWithDate.CAMPX__Due_Date__c,
            'SET DEFAULTS WITH TASKS:\nTask with existing date should not be changed'
        );
    }

    private static Boolean hasErrors(CAMPX__Village_Task__c vTask) {
        return vTask.getErrors().size() > 0;
    }

}