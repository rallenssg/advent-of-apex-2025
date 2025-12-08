/**
 * @description Service class containing business logic for Village Task (CAMPX__Village_Task__c) operations.
 *              Provides centralized methods for handling trigger events and enforcing business rules
 *              while maintaining separation of concerns from trigger handlers.
 * 
 * @author Richard Allen
 * @date December 3, 2025
 */
public class VillageTaskService {

    /**
     * @description Handles the before insert trigger event for Village Task records.
     *              Sets default values and enforces business rules prior to record insertion.
     * 
     * @param vTasks List of Village Task records being inserted
     */
    public static void handleBeforeInsert(List<CAMPX__Village_Task__c> vTasks) {
        VillageTaskUtils.validateSave(vTasks);

        VillageTaskUtils.setDefaults(vTasks);
    }

    /**
     * @description Handles the before update trigger event for Village Task records.
     * 
     * @param vTasks List of Village Task records being updated
     * @param oldMap Map of old Village Task records prior to update
     */
    public static void handleBeforeUpdate(List<CAMPX__Village_Task__c> vTasks, Map<Id, CAMPX__Village_Task__c> oldMap) {
        VillageTaskUtils.validateSave(vTasks);
    }

    /**
     * @description Handles the before delete trigger event for Village Task records.
     *              Validates each task against deletion rules and prevents deletion
     *              of safety-critical tasks that are not completed by adding errors to the records.
     * 
     * @param vTasks List of Village Task records being deleted
     */
    public static void handleBeforeDelete(List<CAMPX__Village_Task__c> vTasks) {
        VillageTaskUtils.validateDelete(vTasks);
    }
}