public with sharing class CloseStaleEnquiriesScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CloseStaleEnquiriesBatch(), 200);
    }
}