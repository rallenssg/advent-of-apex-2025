public class FamilySupportPlanService {
    public static void handleAfterUpdate(List<CAMPX__Family_Support_Plan__c> newPlans, Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap) {
        FamilySupportPlanUtils.syncRelatedVillageTasks(newPlans, oldPlanMap);
    }
}