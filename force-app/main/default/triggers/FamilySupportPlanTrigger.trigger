trigger FamilySupportPlanTrigger on CAMPX__Family_Support_Plan__c (after insert) {
    new FamilySupportPlanTriggerHandler().run();
}