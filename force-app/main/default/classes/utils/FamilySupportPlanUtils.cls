/**
 * @description Utility class for handling operations related to Family Support Plan records, including
 *              synchronizing the support phases of related Village Task records.
 *
 * @author Richard Allen
 * @date December 8, 2025 
 */
public class FamilySupportPlanUtils {
    /**
     * @description Synchronizes the support phases of Village Task records related to Family Support Plan records
     *              that have had their phase changed.
     * 
     * @param newPlans List of new Family Support Plan records from the trigger context
     * @param oldPlanMap Map of old Family Support Plan records from the trigger context
     */
    public static void syncRelatedVillageTasks(List<CAMPX__Family_Support_Plan__c> newPlans, Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap) {
        Map<Id, CAMPX__Family_Support_Plan__c> changedPhasePlans = getPlansWithPhaseChange(newPlans, oldPlanMap);

        if (changedPhasePlans.isEmpty()) {
            return;
        }

        List<CAMPX__Village_Task__c> tasksToUpdate = getVillageTasksByPlanIds(changedPhasePlans.keySet());

        if (tasksToUpdate.isEmpty()) {
            return;
        }

        updateVillageTaskPhases(tasksToUpdate, changedPhasePlans);
    }

    /********************* private helpers *********************/

    /**
     * @description Identifies Family Support Plan records that have had their phase changed.
     * 
     * @param newPlans List of new Family Support Plan records from the trigger context
     * @param oldPlanMap Map of old Family Support Plan records from the trigger context
     * @return Map<Id, CAMPX__Family_Support_Plan__c> Map of Family Support Plan records with changed phases
     */
    @TestVisible
    private static Map<Id,CAMPX__Family_Support_Plan__c> getPlansWithPhaseChange(List<CAMPX__Family_Support_Plan__c> newPlans, Map<Id, CAMPX__Family_Support_Plan__c> oldPlanMap) {
        Map<Id, CAMPX__Family_Support_Plan__c> changedPlans = new Map<Id, CAMPX__Family_Support_Plan__c>();

        if (newPlans == null || oldPlanMap == null) {
            return changedPlans;
        }

        for (CAMPX__Family_Support_Plan__c newPlan : newPlans) {
            CAMPX__Family_Support_Plan__c oldPlan = oldPlanMap.get(newPlan.Id);
            if (newPlan.CAMPX__Phase__c != oldPlan.CAMPX__Phase__c) {
                changedPlans.put(newPlan.Id, newPlan);
            }
        }

        return changedPlans;
    }

    /**
     * @description Retrieves Village Task records associated with the given Family Support Plan IDs.
     * 
     * @param planIds Set of Family Support Plan record IDs to query Village Tasks for
     * @return  `List<CAMPX__Village_Task__c>` List of Village Task records associated with the given Family Support Plan IDs
     */
    @TestVisible
    private static List<CAMPX__Village_Task__c> getVillageTasksByPlanIds(Set<Id> planIds) {
        if (planIds == null || planIds.isEmpty()) {
            return new List<CAMPX__Village_Task__c>();
        }

        return btcdev.SOQL.of(CAMPX__Village_Task__c.SObjectType)
            .with(CAMPX__Village_Task__c.Id, CAMPX__Village_Task__c.CAMPX__Support_Phase__c, CAMPX__Village_Task__c.CAMPX__Family_Support_Plan__c)
            .whereAre(btcdev.SOQL.Filter.with(CAMPX__Village_Task__c.CAMPX__Family_Support_Plan__c).isIn(planIds))
            .toList();
    }

    /**
     * @description Updates the support phase of Village Task records based on their associated Family Support Plan records.
     * 
     * @param tasksToUpdate List of Village Task records to update
     * @param changedPhasePlans Map of Family Support Plan records with changed phases
     */
    @TestVisible
    private static void updateVillageTaskPhases(List<CAMPX__Village_Task__c> tasksToUpdate, Map<Id, CAMPX__Family_Support_Plan__c> changedPhasePlans) {
        if (tasksToUpdate == null || tasksToUpdate.isEmpty() || changedPhasePlans == null || changedPhasePlans.isEmpty()) {
            return;
        }

        for (CAMPX__Village_Task__c task : tasksToUpdate) {
            CAMPX__Family_Support_Plan__c plan = changedPhasePlans.get(task.CAMPX__Family_Support_Plan__c);

            task.CAMPX__Support_Phase__c = plan.CAMPX__Phase__c;
        }

        if (!tasksToUpdate.isEmpty()) {
            Database.update(tasksToUpdate, false);
        }
    }
}