@IsTest
public class FamilySupportPlan_IntegrationTest {
    
    @TestSetup
    static void makeData() {
        // Create Family Support Plans with different phases
        List<CAMPX__Family_Support_Plan__c> plans = new List<CAMPX__Family_Support_Plan__c>{
            new CAMPX__Family_Support_Plan__c(
                CAMPX__Phase__c = 'Before Baby Arrives'
            ),
            new CAMPX__Family_Support_Plan__c(
                CAMPX__Phase__c = 'Before Baby Arrives'
            ),
            new CAMPX__Family_Support_Plan__c(
                CAMPX__Phase__c = 'After Baby Arrives'
            )
        };

        try {
            insert plans;
        } catch (Exception e) {
            System.assert(false, 'Error inserting test Family Support Plan records: ' + e.getMessage());
        }

        // Create Village Tasks associated with the Family Support Plans
        List<CAMPX__Village_Task__c> tasks = new List<CAMPX__Village_Task__c>{
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'Before Baby Arrives',
                CAMPX__Status__c = 'In Progress',
                CAMPX__Assigned_Character__c = 'Grandma Kelly',
                CAMPX__Family_Support_Plan__c = plans[0].Id
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'Before Baby Arrives',
                CAMPX__Status__c = 'Not Started',
                CAMPX__Assigned_Character__c = 'Dr. Grace Evergreen',
                CAMPX__Family_Support_Plan__c = plans[0].Id
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'Before Baby Arrives',
                CAMPX__Status__c = 'Completed',
                CAMPX__Assigned_Character__c = 'Monica McPatchwork',
                CAMPX__Family_Support_Plan__c = plans[1].Id
            ),
            new CAMPX__Village_Task__c(
                CAMPX__Support_Phase__c = 'After Baby Arrives',
                CAMPX__Status__c = 'In Progress',
                CAMPX__Assigned_Character__c = 'Grandma Kelly',
                CAMPX__Family_Support_Plan__c = plans[2].Id
            )
        };

        try {
            insert tasks;
        } catch (Exception e) {
            System.assert(false, 'Error inserting test Village Task records: ' + e.getMessage());
        }
    }

    @IsTest
    static void test_updateFamilySupportPlan_phaseChange_syncsTasks() {
        // Query the test data - get plans that have tasks associated
        List<CAMPX__Family_Support_Plan__c> allPlans = [SELECT Id, CAMPX__Phase__c FROM CAMPX__Family_Support_Plan__c ORDER BY Id];
        
        // Use the first two plans (both start as 'Before Baby Arrives')
        CAMPX__Family_Support_Plan__c firstPlan = allPlans[0];
        CAMPX__Family_Support_Plan__c secondPlan = allPlans[1];

        // Verify initial state
        System.assertEquals(
            'Before Baby Arrives',
            firstPlan.CAMPX__Phase__c,
            'INITIAL STATE:\n' +
            'First plan should start in Before Baby Arrives phase'
        );

        List<CAMPX__Village_Task__c> firstPlanTasks = [
            SELECT Id, CAMPX__Support_Phase__c, CAMPX__Family_Support_Plan__c
            FROM CAMPX__Village_Task__c
            WHERE CAMPX__Family_Support_Plan__c = :firstPlan.Id
        ];

        System.assertEquals(
            2,
            firstPlanTasks.size(),
            'INITIAL STATE:\n' +
            'First plan should have 2 associated tasks'
        );

        for (CAMPX__Village_Task__c task : firstPlanTasks) {
            System.assertEquals(
                'Before Baby Arrives',
                task.CAMPX__Support_Phase__c,
                'INITIAL STATE:\n' +
                'All first plan tasks should start in Before Baby Arrives phase'
            );
        }

        // Update the Family Support Plan phase to trigger the sync
        firstPlan.CAMPX__Phase__c = 'After Baby Arrives';
        secondPlan.CAMPX__Phase__c = 'After Baby Arrives';

        Database.SaveResult[] updateResults = Database.update(
            new List<CAMPX__Family_Support_Plan__c>{firstPlan, secondPlan},
            false
        );

        // Verify updates succeeded
        for (Database.SaveResult sr : updateResults) {
            System.assert(
                sr.isSuccess(),
                'PLAN UPDATE:\n' +
                'Family Support Plan updates should succeed:\n\t' +
                    'Errors: ' + sr.getErrors()
            );
        }

        // Query updated Village Tasks to verify phase sync
        List<CAMPX__Village_Task__c> updatedFirstPlanTasks = [
            SELECT Id, CAMPX__Support_Phase__c, CAMPX__Family_Support_Plan__c
            FROM CAMPX__Village_Task__c
            WHERE CAMPX__Family_Support_Plan__c = :firstPlan.Id
        ];

        List<CAMPX__Village_Task__c> updatedSecondPlanTasks = [
            SELECT Id, CAMPX__Support_Phase__c, CAMPX__Family_Support_Plan__c
            FROM CAMPX__Village_Task__c
            WHERE CAMPX__Family_Support_Plan__c = :secondPlan.Id
        ];

        // Verify first plan tasks were synced to new phase
        System.assertEquals(
            2,
            updatedFirstPlanTasks.size(),
            'PHASE SYNC:\n' +
            'Should still have 2 tasks for first plan after update'
        );

        for (CAMPX__Village_Task__c task : updatedFirstPlanTasks) {
            System.assertEquals(
                'After Baby Arrives',
                task.CAMPX__Support_Phase__c,
                'PHASE SYNC:\n' +
                'First plan tasks should be synced to new phase (After Baby Arrives):\n\t' +
                    'Task: ' + task
            );
        }

        // Verify second plan tasks were synced to new phase
        System.assertEquals(
            1,
            updatedSecondPlanTasks.size(),
            'PHASE SYNC:\n' +
            'Should have 1 task for second plan after update'
        );

        for (CAMPX__Village_Task__c task : updatedSecondPlanTasks) {
            System.assertEquals(
                'After Baby Arrives',
                task.CAMPX__Support_Phase__c,
                'PHASE SYNC:\n' +
                'Second plan tasks should be synced to new phase (After Baby Arrives):\n\t' +
                    'Task: ' + task
            );
        }
    }

    @IsTest
    static void test_updateFamilySupportPlan_noPhaseChange_noSync() {
        // Query a plan with 'After Baby Arrives' phase (the third one)
        List<CAMPX__Family_Support_Plan__c> plans = [SELECT Id, CAMPX__Phase__c, CAMPX__Priority__c FROM CAMPX__Family_Support_Plan__c WHERE CAMPX__Phase__c = 'After Baby Arrives' LIMIT 1];
        CAMPX__Family_Support_Plan__c afterPlan = plans[0];

        // Query associated tasks before update
        List<CAMPX__Village_Task__c> tasksBeforeUpdate = [
            SELECT Id, CAMPX__Support_Phase__c, CAMPX__Family_Support_Plan__c
            FROM CAMPX__Village_Task__c
            WHERE CAMPX__Family_Support_Plan__c = :afterPlan.Id
        ];

        System.assertEquals(
            1,
            tasksBeforeUpdate.size(),
            'BEFORE UPDATE:\n' +
            'After Baby Arrives plan should have 1 associated task'
        );

        String originalTaskPhase = tasksBeforeUpdate[0].CAMPX__Support_Phase__c;

        // Update plan without changing phase - just update priority
        if (afterPlan.CAMPX__Priority__c == null) {
            afterPlan.CAMPX__Priority__c = 'High';
        } else {
            afterPlan.CAMPX__Priority__c = afterPlan.CAMPX__Priority__c == 'High' ? 'Medium' : 'High';
        }
        
        Database.SaveResult updateResult = Database.update(afterPlan, false);

        System.assert(
            updateResult.isSuccess(),
            'PLAN UPDATE:\n' +
            'Family Support Plan update should succeed:\n\t' +
                'Errors: ' + updateResult.getErrors()
        );

        // Query tasks after update
        List<CAMPX__Village_Task__c> tasksAfterUpdate = [
            SELECT Id, CAMPX__Support_Phase__c, CAMPX__Family_Support_Plan__c
            FROM CAMPX__Village_Task__c
            WHERE CAMPX__Family_Support_Plan__c = :afterPlan.Id
        ];

        System.assertEquals(
            1,
            tasksAfterUpdate.size(),
            'AFTER UPDATE:\n' +
            'After Baby Arrives plan should still have 1 associated task'
        );

        // Verify task phase was NOT changed
        System.assertEquals(
            originalTaskPhase,
            tasksAfterUpdate[0].CAMPX__Support_Phase__c,
            'NO PHASE SYNC:\n' +
            'Task phase should remain unchanged when plan phase is not modified:\n\t' +
                'Original phase: ' + originalTaskPhase + '\n' +
                'Current phase: ' + tasksAfterUpdate[0].CAMPX__Support_Phase__c
        );
    }

    @IsTest
    static void test_updateFamilySupportPlan_bulkPhaseChanges() {
        // Query all test plans
        List<CAMPX__Family_Support_Plan__c> allPlans = [
            SELECT Id, CAMPX__Phase__c 
            FROM CAMPX__Family_Support_Plan__c
        ];

        System.assertEquals(
            3,
            allPlans.size(),
            'BULK TEST SETUP:\n' +
            'Should have 3 Family Support Plans for bulk test'
        );

        // Count total associated tasks before update
        List<CAMPX__Village_Task__c> allTasksBefore = [
            SELECT Id, CAMPX__Support_Phase__c, CAMPX__Family_Support_Plan__c
            FROM CAMPX__Village_Task__c
        ];

        System.assertEquals(
            4,
            allTasksBefore.size(),
            'BULK TEST SETUP:\n' +
            'Should have 4 total Village Tasks for bulk test'
        );

        // Update all plans to new phase
        for (CAMPX__Family_Support_Plan__c plan : allPlans) {
            plan.CAMPX__Phase__c = 'After Baby Arrives';
        }

        Database.SaveResult[] bulkUpdateResults = Database.update(allPlans, false);

        // Verify all updates succeeded
        for (Integer i = 0; i < bulkUpdateResults.size(); i++) {
            Database.SaveResult sr = bulkUpdateResults[i];
            System.assert(
                sr.isSuccess(),
                'BULK UPDATE:\n' +
                'All Family Support Plan updates should succeed:\n\t' +
                    'Plan: ' + allPlans[i] + '\n\t' +
                    'Errors: ' + sr.getErrors()
            );
        }

        // Query all tasks after bulk update
        List<CAMPX__Village_Task__c> allTasksAfter = [
            SELECT Id, CAMPX__Support_Phase__c, CAMPX__Family_Support_Plan__c
            FROM CAMPX__Village_Task__c
        ];

        System.assertEquals(
            4,
            allTasksAfter.size(),
            'BULK SYNC:\n' +
            'Should still have 4 total Village Tasks after bulk update'
        );

        // Verify all tasks were synced to new phase
        for (CAMPX__Village_Task__c task : allTasksAfter) {
            System.assertEquals(
                'After Baby Arrives',
                task.CAMPX__Support_Phase__c,
                'BULK SYNC:\n' +
                'All tasks should be synced to new phase (After Baby Arrives):\n\t' +
                    'Task: ' + task
            );
        }
    }

    @IsTest
    static void test_triggerHandler_integration() {
        // This test verifies the complete trigger -> handler -> service -> utils flow
        // Get a plan that has tasks (first plan has 2 tasks)
        List<CAMPX__Family_Support_Plan__c> plans = [SELECT Id, CAMPX__Phase__c FROM CAMPX__Family_Support_Plan__c ORDER BY Id LIMIT 1];
        CAMPX__Family_Support_Plan__c triggerTestPlan = plans[0];

        // Verify the trigger is properly configured
        System.assertNotEquals(
            null,
            triggerTestPlan,
            'TRIGGER INTEGRATION:\n' +
            'Test plan should be available for trigger integration test'
        );

        // Update through standard DML to trigger the full flow
        triggerTestPlan.CAMPX__Phase__c = 'After Baby Arrives';
        
        Test.startTest();
        update triggerTestPlan;
        Test.stopTest();

        // Verify the trigger executed and synced related tasks
        List<CAMPX__Village_Task__c> syncedTasks = [
            SELECT Id, CAMPX__Support_Phase__c 
            FROM CAMPX__Village_Task__c 
            WHERE CAMPX__Family_Support_Plan__c = :triggerTestPlan.Id
        ];

        for (CAMPX__Village_Task__c task : syncedTasks) {
            System.assertEquals(
                'After Baby Arrives',
                task.CAMPX__Support_Phase__c,
                'TRIGGER INTEGRATION:\n' +
                'Trigger should execute full flow and sync task phases:\n\t' +
                    'Task: ' + task
            );
        }
    }
}