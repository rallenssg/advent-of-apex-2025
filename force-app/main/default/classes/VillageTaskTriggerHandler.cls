/**
 * @description Trigger handler class for Village Task (CAMPX__Village_Task__c) operations.
 *              Extends the TriggerHandler framework to provide structured trigger execution
 *              with proper separation of concerns and bulkified operations.
 * 
 * @author Richard Allen
 * @date December 3, 2025
 */
public class VillageTaskTriggerHandler extends TriggerHandler {
    
    /**
     * @description Handles before delete trigger operations for Village Task records.
     *              This method is automatically called by the TriggerHandler framework
     *              when Village Task records are about to be deleted from the database.
     *              
     *              The method delegates the actual business logic to the VillageTaskService
     *              to maintain separation of concerns and enable proper unit testing.
     */
    public override void beforeDelete() {
        VillageTaskService.handleBeforeDelete(Trigger.old);
    }
}