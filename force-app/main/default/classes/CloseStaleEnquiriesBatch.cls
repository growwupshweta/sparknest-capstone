public with sharing class CloseStaleEnquiriesBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Datetime cutoff = Datetime.now().addDays(-30);
        return Database.getQueryLocator([
            SELECT Id, Status__c FROM Enquiry__c
            WHERE Status__c = 'In Progress'
            AND LastModifiedDate < :cutoff
        ]);
    }
    public void execute(Database.BatchableContext bc, List<Enquiry__c> scope) {
        Datetime cutoff = Datetime.now().addDays(-30);
        Set<Id> ids = new Map<Id, Enquiry__c>(scope).keySet();
        Set<Id> active = new Set<Id>();
        for (Task t : [SELECT WhatId FROM Task WHERE WhatId IN :ids AND CreatedDate >= :cutoff]) {
            active.add(t.WhatId);
        }
        for (Event ev : [SELECT WhatId FROM Event WHERE WhatId IN :ids AND CreatedDate >= :cutoff]) {
            active.add(ev.WhatId);
        }
        List<Enquiry__c> toClose = new List<Enquiry__c>();
        for (Enquiry__c e : scope) {
            if (!active.contains(e.Id)) {
                e.Status__c = 'Closed';
                toClose.add(e);
            }
        }
        if (!toClose.isEmpty()) {
            update toClose;
        }
    }
    public void finish(Database.BatchableContext bc) {}
}