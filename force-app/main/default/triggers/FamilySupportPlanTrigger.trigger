trigger FamilySupportPlanTrigger on CAMPX__Family_Support_Plan__c (after update) {
    new FamilySupportPlanTriggerHandler().run();
}