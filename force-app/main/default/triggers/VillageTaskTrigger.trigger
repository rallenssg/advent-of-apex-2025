trigger VillageTaskTrigger on CAMPX__Village_Task__c (before insert, before update, before delete) {
    new VillageTaskTriggerHandler().run();
}