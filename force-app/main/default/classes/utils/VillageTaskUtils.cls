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
     * @description Determines if a Village Task record can be safely deleted based on business rules.
     *              Baby safety critical tasks can only be deleted if they are completed,
     *              while non-critical tasks can always be deleted.
     * 
     * @param vTask The Village Task record to validate for deletion
     * @return Boolean true if the task can be deleted, false otherwise
     */
    public static Boolean isValidDelete(CAMPX__Village_Task__c vTask) {
        return !vTask.CAMPX__Is_Baby_Safety_Critical__c ?
                    true :
                    vTask.CAMPX__Status__c == 'Completed';
    }
}