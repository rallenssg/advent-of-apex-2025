/**
 * @description Utility class providing helper methods for Village Task (CAMPX__Village_Task__c) operations.
 *              Contains reusable business logic and validation methods that can be used
 *              across different parts of the Village Task functionality.
 * 
 * @author Richard Allen
 * @date December 3, 2025
 */
public class VillageTaskUtils {

    /**
     * @description Validates a list of Village Task records for saving.
     *              Adds errors to records that cannot be saved based on business rules.
     * 
     * @param vTasks List of Village Task records to validate for saving
     */
    public static void validateSave(List<CAMPX__Village_Task__c> vTasks) {
        if(vTasks == null) {
            return;
        }

        for(CAMPX__Village_Task__c vTask : vTasks) {
            if(!isValidSave(vTask)) {
                vTask.addError('Cannot complete a task without assigning it to a villager first.');
            }
        }
    }

    /**
     * @description Validates a list of Village Task records for deletion.
     *              Adds errors to records that cannot be deleted based on business rules.
     * 
     * @param vTasks List of Village Task records to validate for deletion
     */
    public static void validateDelete(List<CAMPX__Village_Task__c> vTasks) {
        if(vTasks == null) {
            return;
        }

        for(CAMPX__Village_Task__c vTask : vTasks) {
            if(!isValidDelete(vTask)) {
                vTask.addError('Cannot delete safety-critical tasks that are not completed. Please complete the task first or contact your administrator.');
            }
        }
    }

    /**
     * @description Sets default values for a list of Village Task records prior to insertion.
     *              Calls Helper methods to apply specific defaulting logic as needed.
     * 
     * @param vTasks List of Village Task records to set defaults on
     */
    public static void setDefaults(List<CAMPX__Village_Task__c> vTasks) {
        if(vTasks == null) {
            return;
        }

        for(CAMPX__Village_Task__c vTask : vTasks) {
            defaultDueDate(vTask);
        }
    }

    /********************* private helpers *********************/
    
    /**
     * @description Determines if a Village Task record can be safely saved based on business rules.
     *              A task cannot be marked as completed unless it is assigned to a villager.
     * 
     * @param vTask The Village Task record to validate for saving
     * @return Boolean true if the task can be saved, false otherwise
     */
    @TestVisible
    private static Boolean isValidSave(CAMPX__Village_Task__c vTask) {
        return (vTask == null) || !(String.isBlank(vTask.CAMPX__Assigned_Character__c) && vTask.CAMPX__Status__c == 'Completed');
    }

    /**
     * @description Determines if a Village Task record can be safely deleted based on business rules.
     *              Baby safety critical tasks can only be deleted if they are completed,
     *              while non-critical tasks can always be deleted.
     * 
     * @param vTask The Village Task record to validate for deletion
     * @return Boolean true if the task can be deleted, false otherwise
     */
    @TestVisible
    private static Boolean isValidDelete(CAMPX__Village_Task__c vTask) {
        if (vTask == null) {
            return false;
        }
        
        return !vTask.CAMPX__Is_Baby_Safety_Critical__c ? 
                    true : 
                    vTask.CAMPX__Status__c == 'Completed';
    }

    /**
     * @description Sets the default due date for a Village Task record based on its support phase.
     *              If the task is in the "Before Baby Arrives" phase and has no due date,
     *              sets the due date to 14 days from today.
     * 
     * @param vTask The Village Task record to set the default due date on
     */
    @TestVisible
    private static void defaultDueDate(CAMPX__Village_Task__c vTask) {
        if(vTask == null) {
            return;
        }

        if(vTask.CAMPX__Support_Phase__c == 'Before Baby Arrives' && vTask.CAMPX__Due_Date__c == null) {
            vTask.CAMPX__Due_Date__c = Date.today().addDays(14);
        }
    }
}