@IsTest
public class VillageTaskService_Test {
    @IsTest
    static void test_handleBeforeInsert_integration() {
        CAMPX__Village_Task__c validTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Due_Date__c = null,
            CAMPX__Assigned_Character__c = 'Grandma Kelly',
            CAMPX__Status__c = 'In Progress'
        );
        
        CAMPX__Village_Task__c invalidTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'After Baby Arrives',
            CAMPX__Due_Date__c = null,
            CAMPX__Assigned_Character__c = null,
            CAMPX__Status__c = 'Completed'
        );

        VillageTaskService.handleBeforeInsert(
            new List<CAMPX__Village_Task__c>{
                validTask,
                invalidTask
            }
        );

        // Verify defaults were set (delegated to utils)
        System.assert(
            validTask.CAMPX__Due_Date__c == Date.today().addDays(14),
            'BEFORE INSERT INTEGRATION:\n' +
            'Valid task should have due date defaulted:\n\t' +
                'Expected: ' + Date.today().addDays(14) + '\n' +
                'Actual: ' + validTask.CAMPX__Due_Date__c
        );

        System.assert(
            invalidTask.CAMPX__Due_Date__c == null,
            'BEFORE INSERT INTEGRATION:\n' +
            'Invalid phase task should not have due date defaulted:\n\t' +
                'Expected: null\n' +
                'Actual: ' + invalidTask.CAMPX__Due_Date__c
        );

        // Verify validation was performed (delegated to utils)
        System.assert(
            !hasErrors(validTask),
            'BEFORE INSERT INTEGRATION:\n' +
            'Valid task should not have errors:\n\t' +
                'Record: ' + validTask + '\n' +
                'Errors: ' + validTask.getErrors()
        );

        System.assert(
            hasErrors(invalidTask),
            'BEFORE INSERT INTEGRATION:\n' +
            'Invalid task should have errors:\n\t' +
                'Record: ' + invalidTask
        );
    }

    @IsTest
    static void test_handleBeforeUpdate_integration() {
        CAMPX__Village_Task__c validTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = 'Grandma Kelly',
            CAMPX__Status__c = 'In Progress'
        );
        
        CAMPX__Village_Task__c invalidTask = new CAMPX__Village_Task__c(
            CAMPX__Assigned_Character__c = null,
            CAMPX__Status__c = 'Completed'
        );
        
        Map<Id, CAMPX__Village_Task__c> oldMap = new Map<Id, CAMPX__Village_Task__c>();

        VillageTaskService.handleBeforeUpdate(
            new List<CAMPX__Village_Task__c>{
                validTask,
                invalidTask
            },
            oldMap
        );

        // Verify validation was performed (delegated to utils)
        System.assert(
            !hasErrors(validTask),
            'BEFORE UPDATE INTEGRATION:\n' +
            'Valid task should not have errors:\n\t' +
                'Record: ' + validTask + '\n' +
                'Errors: ' + validTask.getErrors()
        );

        System.assert(
            hasErrors(invalidTask),
            'BEFORE UPDATE INTEGRATION:\n' +
            'Invalid task should have errors:\n\t' +
                'Record: ' + invalidTask
        );
    }

    @IsTest
    static void test_handleBeforeDelete_integration() {
        CAMPX__Village_Task__c validTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = false,
            CAMPX__Status__c = 'In Progress'
        );
        
        CAMPX__Village_Task__c invalidTask = new CAMPX__Village_Task__c(
            CAMPX__Is_Baby_Safety_Critical__c = true,
            CAMPX__Status__c = 'In Progress'
        );

        VillageTaskService.handleBeforeDelete(
            new List<CAMPX__Village_Task__c>{
                validTask,
                invalidTask
            }
        );

        // Verify validation was performed (delegated to utils)
        System.assert(
            !hasErrors(validTask),
            'BEFORE DELETE INTEGRATION:\n' +
            'Valid task should not have errors:\n\t' +
                'Record: ' + validTask + '\n' +
                'Errors: ' + validTask.getErrors()
        );

        System.assert(
            hasErrors(invalidTask),
            'BEFORE DELETE INTEGRATION:\n' +
            'Invalid task should have errors:\n\t' +
                'Record: ' + invalidTask
        );
    }

    private static Boolean hasErrors(CAMPX__Village_Task__c vTask) {
        return vTask.getErrors().size() > 0;
    }
}