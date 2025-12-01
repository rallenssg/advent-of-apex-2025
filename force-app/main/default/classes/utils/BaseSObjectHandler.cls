public virtual class BaseSObjectHandler {
    List<SObject> records { get; private set; }
    Map<Id, SObject> recordMap { get; private set; }

    public BaseSObjectHandler() {}

    public BaseSObjectHandler(List<SObject> records) {
        if (hasNoRecords(records)) {
            throw new IllegalArgumentException('Records list cannot be null or empty.\nrecords: ' + records);
        }

        else {
            this.records = records;
        }
    }

    public BaseSObjectHandler(List<SObject> records, Map<Id, SObject> recordMap ) {
        if (hasNoRecords(records, recordMap)) {
            throw new IllegalArgumentException('Both records list and record map cannot be null or empty.\nrecords: ' + records + '\nrecordMap: ' + recordMap);
        }
        else {
            this.records = records;
            this.recordMap = recordMap;
        }
    }

    public virtual void handleBeforeInsert() {}

    public virtual void handleBeforeUpdate() {}

    public virtual void handleBeforeDelete() {}
    
    public virtual void handleAfterInsert() {}

    public virtual void handleAfterUpdate() {}

    public virtual void handleAfterDelete() {}

    public virtual void handleAfterUndelete() {}

    private static Boolean hasNoRecords(List<SObject> records) {
        return (records == null || records.isEmpty());
    }

    private static Boolean hasNoRecords(List<SObject> records, Map<Id, SObject> recordMap) {
        return hasNoRecords(records) && hasNoRecords(recordMap?.values());
    }
}