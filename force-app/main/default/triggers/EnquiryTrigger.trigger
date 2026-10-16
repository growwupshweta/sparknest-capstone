trigger EnquiryTrigger on Enquiry__c (before insert, after insert, before update) {
    TriggerDispatcher.run(new EnquiryTriggerHandler());
}