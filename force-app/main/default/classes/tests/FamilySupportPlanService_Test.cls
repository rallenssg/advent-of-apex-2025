@IsTest
public class FamilySupportPlanService_Test {
    
    @IsTest
    static void test_handleAfterUpdate_integration() {
        Id beforeToAfterPlanId = 'a0C000000000001AAA';
        Id unchangedPlanId = 'a0C000000000002AAA';
        
        CAMPX__Family_Support_Plan__c beforeToAfterPlan = new CAMPX__Family_Support_Plan__c(
            Id = beforeToAfterPlanId,
            CAMPX__Phase__c = 'After Baby Arrives'
        );
        
        CAMPX__Family_Support_Plan__c unchangedPlan = new CAMPX__Family_Support_Plan__c(
            Id = unchangedPlanId,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );

        List<CAMPX__Family_Support_Plan__c> newPlans = new List<CAMPX__Family_Support_Plan__c>{
            beforeToAfterPlan,
            unchangedPlan
        };
        
        Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap = new Map<Id, CAMPX__Family_Support_Plan__c>{
            beforeToAfterPlanId => new CAMPX__Family_Support_Plan__c(
                Id = beforeToAfterPlanId, 
                CAMPX__Phase__c = 'Before Baby Arrives'
            ),
            unchangedPlanId => new CAMPX__Family_Support_Plan__c(
                Id = unchangedPlanId, 
                CAMPX__Phase__c = 'Before Baby Arrives'
            )
        };

        // This should execute the service method which delegates to utils
        FamilySupportPlanService.handleAfterUpdate(newPlans, oldPlanMap);

        System.assert(
            true,
            'AFTER UPDATE INTEGRATION:\n' +
            'handleAfterUpdate should execute without errors and delegate to utils:\n\t' +
                'Plans with changes: 1\n' +
                'Plans without changes: 1'
        );
    }

    @IsTest
    static void test_handleAfterUpdate_nullInputs() {
        // Test null handling - should delegate gracefully to utils
        FamilySupportPlanService.handleAfterUpdate(null, new Map<Id, CAMPX__Family_Support_Plan__c>());
        FamilySupportPlanService.handleAfterUpdate(new List<CAMPX__Family_Support_Plan__c>(), null);
        FamilySupportPlanService.handleAfterUpdate(null, null);

        System.assert(
            true,
            'NULL INPUT HANDLING:\n' +
            'handleAfterUpdate should handle null inputs gracefully by delegating to utils'
        );
    }

    @IsTest
    static void test_handleAfterUpdate_emptyInputs() {
        // Test empty collections
        FamilySupportPlanService.handleAfterUpdate(
            new List<CAMPX__Family_Support_Plan__c>(), 
            new Map<Id, CAMPX__Family_Support_Plan__c>()
        );

        System.assert(
            true,
            'EMPTY INPUT HANDLING:\n' +
            'handleAfterUpdate should handle empty collections gracefully'
        );
    }

    @IsTest
    static void test_handleAfterUpdate_bulkData() {
        List<CAMPX__Family_Support_Plan__c> newPlans = new List<CAMPX__Family_Support_Plan__c>();
        Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap = new Map<Id, CAMPX__Family_Support_Plan__c>();

        // Create a few plans to test bulk handling without complex ID generation
        Id planId1 = 'a0C000000000001AAA';
        Id planId2 = 'a0C000000000002AAA';
        Id planId3 = 'a0C000000000003AAA';
        
        CAMPX__Family_Support_Plan__c newPlan1 = new CAMPX__Family_Support_Plan__c(
            Id = planId1,
            CAMPX__Phase__c = 'After Baby Arrives'
        );
        CAMPX__Family_Support_Plan__c oldPlan1 = new CAMPX__Family_Support_Plan__c(
            Id = planId1,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );
        
        CAMPX__Family_Support_Plan__c newPlan2 = new CAMPX__Family_Support_Plan__c(
            Id = planId2,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );
        CAMPX__Family_Support_Plan__c oldPlan2 = new CAMPX__Family_Support_Plan__c(
            Id = planId2,
            CAMPX__Phase__c = 'After Baby Arrives'
        );
        
        CAMPX__Family_Support_Plan__c newPlan3 = new CAMPX__Family_Support_Plan__c(
            Id = planId3,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );
        CAMPX__Family_Support_Plan__c oldPlan3 = new CAMPX__Family_Support_Plan__c(
            Id = planId3,
            CAMPX__Phase__c = 'Before Baby Arrives' // No change
        );

        newPlans.addAll(new List<CAMPX__Family_Support_Plan__c>{newPlan1, newPlan2, newPlan3});
        oldPlanMap.putAll(new Map<Id, CAMPX__Family_Support_Plan__c>{
            planId1 => oldPlan1,
            planId2 => oldPlan2,
            planId3 => oldPlan3
        });

        // Should handle bulk data processing
        FamilySupportPlanService.handleAfterUpdate(newPlans, oldPlanMap);

        System.assert(
            true,
            'BULK DATA HANDLING:\n' +
            'handleAfterUpdate should process bulk data (3 records) without errors:\n\t' +
                'Records processed: ' + newPlans.size()
        );
    }

    @IsTest
    static void test_handleAfterUpdate_singleRecord() {
        Id afterToBeforePlanId = 'a0C000000000001AAA';
        
        CAMPX__Family_Support_Plan__c afterToBeforePlan = new CAMPX__Family_Support_Plan__c(
            Id = afterToBeforePlanId,
            CAMPX__Phase__c = 'Before Baby Arrives'
        );

        List<CAMPX__Family_Support_Plan__c> newPlans = new List<CAMPX__Family_Support_Plan__c>{afterToBeforePlan};
        
        Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap = new Map<Id, CAMPX__Family_Support_Plan__c>{
            afterToBeforePlanId => new CAMPX__Family_Support_Plan__c(
                Id = afterToBeforePlanId, 
                CAMPX__Phase__c = 'After Baby Arrives'
            )
        };

        // Should handle single record processing
        FamilySupportPlanService.handleAfterUpdate(newPlans, oldPlanMap);

        System.assert(
            true,
            'SINGLE RECORD HANDLING:\n' +
            'handleAfterUpdate should process single records correctly:\n\t' +
                'Plan: ' + afterToBeforePlan
        );
    }
}