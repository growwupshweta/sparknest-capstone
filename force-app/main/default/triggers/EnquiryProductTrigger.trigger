trigger EnquiryProductTrigger on Enquiry_Product__c (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUndelete) {
            EnquiryProductService.updateEnquiryRollups(Trigger.new, null);
        } else if (Trigger.isUpdate) {
            EnquiryProductService.updateEnquiryRollups(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            EnquiryProductService.updateEnquiryRollups(null, Trigger.oldMap);
        }
    }
}
