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
     * @description Handles the before delete trigger event for Village Task records.
     *              Validates each task against deletion rules and prevents deletion
     *              of safety-critical tasks that are not completed by adding errors to the records.
     * 
     * @param vTasks List of Village Task records being deleted
     */
    public static void handleBeforeDelete(List<CAMPX__Village_Task__c> vTasks) {
        for(CAMPX__Village_Task__c vTask : vTasks) {
            if(!VillageTaskUtils.isValidDelete(vTask)) {
                vTask.addError('Cannot delete safety-critical tasks that are not completed. Please complete the task first or contact your administrator.');
            }
        }
    }
}