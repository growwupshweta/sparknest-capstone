public with sharing class EnquiryService {
    public static final Decimal MIN_BUDGET = 1000;

    public static void setDefaultStatus(List<Enquiry__c> enquiries) {
        for (Enquiry__c e : enquiries) {
            if (String.isBlank(e.Status__c)) {
                e.Status__c = 'New';
            }
        }
    }

    public static void validateBudget(List<Enquiry__c> enquiries) {
        for (Enquiry__c e : enquiries) {
            if (e.Customer_Budget__c != null && e.Customer_Budget__c < MIN_BUDGET) {
                e.Customer_Budget__c.addError('Customer budget must be at least \u20B91,000');
            }
        }
    }

    public static void createFollowUpTasks(List<Enquiry__c> enquiries) {
        List<Task> tasks = new List<Task>();
        for (Enquiry__c e : enquiries) {
            tasks.add(new Task(
                Subject = 'Follow up: ' + e.Subject__c,
                ActivityDate = Date.today().addDays(3),
                OwnerId = e.OwnerId,
                WhatId = e.Id
            ));
        }
        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }

    public static void stampClosedDate(List<Enquiry__c> enquiries, Map<Id, Enquiry__c> oldMap) {
        for (Enquiry__c e : enquiries) {
            Enquiry__c old = oldMap.get(e.Id);
            if (e.Status__c == 'Closed' && old.Status__c != 'Closed') {
                e.Closed_Date__c = Date.today();
            }
        }
    }
}