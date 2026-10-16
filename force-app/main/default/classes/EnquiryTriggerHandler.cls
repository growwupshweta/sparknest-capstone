public with sharing class EnquiryTriggerHandler implements ITriggerHandler {
    public void beforeInsert(List<SObject> newList) {
        List<Enquiry__c> enquiries = (List<Enquiry__c>) newList;
        EnquiryService.setDefaultStatus(enquiries);
        EnquiryService.validateBudget(enquiries);
    }
    public void afterInsert(List<SObject> newList) {
        EnquiryService.createFollowUpTasks((List<Enquiry__c>) newList);
    }
    public void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {
        EnquiryService.stampClosedDate((List<Enquiry__c>) newList, (Map<Id, Enquiry__c>) oldMap);
    }
}