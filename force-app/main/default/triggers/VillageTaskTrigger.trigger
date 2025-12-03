trigger VillageTaskTrigger on CAMPX__Village_Task__c (before delete) {
    new VillageTaskTriggerHandler().run();
}