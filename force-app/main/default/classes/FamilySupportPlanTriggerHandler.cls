public class FamilySupportPlanTriggerHandler extends TriggerHandler {
    public override void afterUpdate() {
        FamilySupportPlanService.handleAfterUpdate(Trigger.new, (Map<Id, CAMPX__Family_Support_Plan__c>) Trigger.oldMap);
    }
}