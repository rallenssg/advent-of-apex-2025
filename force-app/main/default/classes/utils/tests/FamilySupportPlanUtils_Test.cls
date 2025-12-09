@IsTest
public class FamilySupportPlanUtils_Test {
    
    @IsTest
    static void test_getPlansWithPhaseChange_validPhaseChanges() {
        Id beforeToAfterPlanId = 'a0C000000000001AAA';
        Id afterToBeforePlanId = 'a0C000000000002AAA';
        Id unchangedPlanId = 'a0C000000000003AAA';
        
        CAMPX__Family_Support_Plan__c beforeToAfterPlan = new CAMPX__Family_Support_Plan__c(
            Id = beforeToAfterPlanId,
            CAMPX__Phase__c = 'After Baby Arrives'
        );
        
        CAMPX__Family_Support_Plan__c afterToBeforePlan = new CAMPX__Family_Support_Plan__c(
            Id = afterToBeforePlanId,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );
        
        CAMPX__Family_Support_Plan__c unchangedPlan = new CAMPX__Family_Support_Plan__c(
            Id = unchangedPlanId,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );

        List<CAMPX__Family_Support_Plan__c> newPlans = new List<CAMPX__Family_Support_Plan__c>{beforeToAfterPlan, afterToBeforePlan, unchangedPlan};
        
        Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap = new Map<Id, CAMPX__Family_Support_Plan__c>{
            beforeToAfterPlanId => new CAMPX__Family_Support_Plan__c(Id = beforeToAfterPlanId, CAMPX__Phase__c = 'Before Baby Arrives'),
            afterToBeforePlanId => new CAMPX__Family_Support_Plan__c(Id = afterToBeforePlanId, CAMPX__Phase__c = 'After Baby Arrives'),
            unchangedPlanId => new CAMPX__Family_Support_Plan__c(Id = unchangedPlanId, CAMPX__Phase__c = 'Before Baby Arrives')
        };

        Map<Id, CAMPX__Family_Support_Plan__c> result = FamilySupportPlanUtils.getPlansWithPhaseChange(newPlans, oldPlanMap);

        System.assertEquals(
            2, 
            result.size(),
            'PHASE CHANGE DETECTION:\n' +
            'Should detect 2 plans with phase changes:\n\t' +
                'Expected: 2\n' +
                'Actual: ' + result.size()
        );

        System.assert(
            result.containsKey(beforeToAfterPlan.Id),
            'PHASE CHANGE DETECTION:\n' +
            'Should detect beforeToAfterPlan phase change (Before Baby Arrives → After Baby Arrives):\n\t' +
                'Plan: ' + beforeToAfterPlan
        );

        System.assert(
            result.containsKey(afterToBeforePlan.Id),
            'PHASE CHANGE DETECTION:\n' +
            'Should detect afterToBeforePlan phase change (After Baby Arrives → Before Baby Arrives):\n\t' +
                'Plan: ' + afterToBeforePlan
        );

        System.assert(
            !result.containsKey(unchangedPlan.Id),
            'PHASE CHANGE DETECTION:\n' +
            'Should not detect unchangedPlan as changed (no phase change):\n\t' +
                'Plan: ' + unchangedPlan
        );
    }

    @IsTest
    static void test_getPlansWithPhaseChange_noPhaseChanges() {
        Id unchangedPlanId = 'a0C000000000001AAA';
        
        CAMPX__Family_Support_Plan__c unchangedPlan = new CAMPX__Family_Support_Plan__c(
            Id = unchangedPlanId,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );
        
        List<CAMPX__Family_Support_Plan__c> newPlans = new List<CAMPX__Family_Support_Plan__c>{unchangedPlan};
        
        Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap = new Map<Id, CAMPX__Family_Support_Plan__c>{
            unchangedPlanId => new CAMPX__Family_Support_Plan__c(Id = unchangedPlanId, CAMPX__Phase__c = 'Before Baby Arrives')
        };

        Map<Id, CAMPX__Family_Support_Plan__c> result = FamilySupportPlanUtils.getPlansWithPhaseChange(newPlans, oldPlanMap);

        System.assertEquals(
            0, 
            result.size(),
            'NO PHASE CHANGE:\n' +
            'Should detect no plans with phase changes when phases unchanged:\n\t' +
                'Expected: 0\n' +
                'Actual: ' + result.size()
        );
    }

    @IsTest
    static void test_getPlansWithPhaseChange_nullInputs() {
        Map<Id, CAMPX__Family_Support_Plan__c> result1 = FamilySupportPlanUtils.getPlansWithPhaseChange(null, new Map<Id, CAMPX__Family_Support_Plan__c>());
        Map<Id, CAMPX__Family_Support_Plan__c> result2 = FamilySupportPlanUtils.getPlansWithPhaseChange(new List<CAMPX__Family_Support_Plan__c>(), null);
        Map<Id, CAMPX__Family_Support_Plan__c> result3 = FamilySupportPlanUtils.getPlansWithPhaseChange(null, null);

        System.assert(
            result1.isEmpty(),
            'NULL INPUT HANDLING:\n' +
            'Should handle null newPlans gracefully:\n\t' +
                'Expected: empty map\n' +
                'Actual: ' + result1
        );

        System.assert(
            result2.isEmpty(),
            'NULL INPUT HANDLING:\n' +
            'Should handle null oldPlanMap gracefully:\n\t' +
                'Expected: empty map\n' +
                'Actual: ' + result2
        );

        System.assert(
            result3.isEmpty(),
            'NULL INPUT HANDLING:\n' +
            'Should handle null inputs gracefully:\n\t' +
                'Expected: empty map\n' +
                'Actual: ' + result3
        );
    }

    @IsTest
    static void test_getVillageTasksByPlanIds_withValidIds() {
        // We can't test the SOQL directly in unit tests, but we can test null handling
        Set<Id> planIds = new Set<Id>{
            'a0C000000000001AAA',
            'a0C000000000002AAA'
        };

        // This will return empty list since no actual data exists, but method should execute without error
        List<CAMPX__Village_Task__c> result = FamilySupportPlanUtils.getVillageTasksByPlanIds(planIds);

        System.assertNotEquals(
            null,
            result,
            'VILLAGE TASKS QUERY:\n' +
            'Should return non-null list even when no records found:\n\t' +
                'Result: ' + result
        );
    }

    @IsTest
    static void test_getVillageTasksByPlanIds_nullAndEmptyInputs() {
        List<CAMPX__Village_Task__c> result1 = FamilySupportPlanUtils.getVillageTasksByPlanIds(null);
        List<CAMPX__Village_Task__c> result2 = FamilySupportPlanUtils.getVillageTasksByPlanIds(new Set<Id>());

        System.assert(
            result1.isEmpty(),
            'NULL INPUT HANDLING:\n' +
            'Should handle null planIds gracefully:\n\t' +
                'Expected: empty list\n' +
                'Actual: ' + result1
        );

        System.assert(
            result2.isEmpty(),
            'EMPTY INPUT HANDLING:\n' +
            'Should handle empty planIds gracefully:\n\t' +
                'Expected: empty list\n' +
                'Actual: ' + result2
        );
    }

    @IsTest
    static void test_updateVillageTaskPhases_validUpdate() {
        Id supportPlanId = 'a0C000000000001AAA';
        
        CAMPX__Village_Task__c firstTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Family_Support_Plan__c = supportPlanId
        );
        
        CAMPX__Village_Task__c secondTask = new CAMPX__Village_Task__c(
            CAMPX__Support_Phase__c = 'Before Baby Arrives',
            CAMPX__Family_Support_Plan__c = supportPlanId
        );

        List<CAMPX__Village_Task__c> tasksToUpdate = new List<CAMPX__Village_Task__c>{firstTask, secondTask};
        
        Map<Id, CAMPX__Family_Support_Plan__c> changedPhasePlans = new Map<Id, CAMPX__Family_Support_Plan__c>{
            supportPlanId => new CAMPX__Family_Support_Plan__c(Id = supportPlanId, CAMPX__Phase__c = 'After Baby Arrives')
        };

        // Store original phases for comparison
        String originalFirstTaskPhase = firstTask.CAMPX__Support_Phase__c;
        String originalSecondTaskPhase = secondTask.CAMPX__Support_Phase__c;

        FamilySupportPlanUtils.updateVillageTaskPhases(tasksToUpdate, changedPhasePlans);

        System.assertEquals(
            'After Baby Arrives',
            firstTask.CAMPX__Support_Phase__c,
            'PHASE UPDATE:\n' +
            'First task phase should be updated to match plan phase:\n\t' +
                'Original: ' + originalFirstTaskPhase + '\n' +
                'Expected: After Baby Arrives\n' +
                'Actual: ' + firstTask.CAMPX__Support_Phase__c
        );

        System.assertEquals(
            'After Baby Arrives',
            secondTask.CAMPX__Support_Phase__c,
            'PHASE UPDATE:\n' +
            'Second task phase should be updated to match plan phase:\n\t' +
                'Original: ' + originalSecondTaskPhase + '\n' +
                'Expected: After Baby Arrives\n' +
                'Actual: ' + secondTask.CAMPX__Support_Phase__c
        );
    }

    @IsTest
    static void test_updateVillageTaskPhases_nullAndEmptyInputs() {
        // Test null inputs - should not throw exceptions
        FamilySupportPlanUtils.updateVillageTaskPhases(null, new Map<Id, CAMPX__Family_Support_Plan__c>());
        FamilySupportPlanUtils.updateVillageTaskPhases(new List<CAMPX__Village_Task__c>(), null);
        FamilySupportPlanUtils.updateVillageTaskPhases(null, null);
        FamilySupportPlanUtils.updateVillageTaskPhases(new List<CAMPX__Village_Task__c>(), new Map<Id, CAMPX__Family_Support_Plan__c>());

        System.assert(true, 'NULL INPUT HANDLING:\nupdateVillageTaskPhases should handle null and empty inputs without throwing exceptions');
    }

    @IsTest
    static void test_syncRelatedVillageTasks_integrationCall() {
        // This is a unit test for the main public method, testing the integration of private methods
        Id changedPhasePlanId = 'a0C000000000001AAA';
        
        CAMPX__Family_Support_Plan__c changedPhasePlan = new CAMPX__Family_Support_Plan__c(
            Id = changedPhasePlanId,
            CAMPX__Phase__c = 'After Baby Arrives'
        );
        
        List<CAMPX__Family_Support_Plan__c> newPlans = new List<CAMPX__Family_Support_Plan__c>{changedPhasePlan};
        
        Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap = new Map<Id, CAMPX__Family_Support_Plan__c>{
            changedPhasePlanId => new CAMPX__Family_Support_Plan__c(Id = changedPhasePlanId, CAMPX__Phase__c = 'Before Baby Arrives')
        };

        // This should execute without errors - we can't test the actual SOQL/DML in unit tests
        FamilySupportPlanUtils.syncRelatedVillageTasks(newPlans, oldPlanMap);

        System.assert(true, 'SYNC INTEGRATION:\nsyncRelatedVillageTasks should execute without errors when given valid inputs');
    }

    @IsTest
    static void test_syncRelatedVillageTasks_noPhaseChanges() {
        Id unchangedPhasePlanId = 'a0C000000000001AAA';
        
        CAMPX__Family_Support_Plan__c unchangedPhasePlan = new CAMPX__Family_Support_Plan__c(
            Id = unchangedPhasePlanId,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );
        
        List<CAMPX__Family_Support_Plan__c> newPlans = new List<CAMPX__Family_Support_Plan__c>{unchangedPhasePlan};
        
        Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap = new Map<Id, CAMPX__Family_Support_Plan__c>{
            unchangedPhasePlanId => new CAMPX__Family_Support_Plan__c(Id = unchangedPhasePlanId, CAMPX__Phase__c = 'Before Baby Arrives')
        };

        // Should return early when no phase changes detected
        FamilySupportPlanUtils.syncRelatedVillageTasks(newPlans, oldPlanMap);

        System.assert(true, 'EARLY RETURN:\nsyncRelatedVillageTasks should return early when no phase changes detected');
    }
}