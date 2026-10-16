public with sharing class EnquiryProductService {
    public static void updateEnquiryRollups(List<Enquiry_Product__c> newList, Map<Id, Enquiry_Product__c> oldMap) {
        Set<Id> enquiryIds = new Set<Id>();

        if (newList != null) {
            for (Enquiry_Product__c ep : newList) {
                if (ep.Enquiry__c != null) {
                    enquiryIds.add(ep.Enquiry__c);
                }
                if (oldMap != null && oldMap.containsKey(ep.Id)) {
                    Enquiry_Product__c oldEp = oldMap.get(ep.Id);
                    if (oldEp.Enquiry__c != null && oldEp.Enquiry__c != ep.Enquiry__c) {
                        enquiryIds.add(oldEp.Enquiry__c);
                    }
                }
            }
        }

        if (newList == null && oldMap != null) {
            for (Enquiry_Product__c ep : oldMap.values()) {
                if (ep.Enquiry__c != null) {
                    enquiryIds.add(ep.Enquiry__c);
                }
            }
        }

        if (enquiryIds.isEmpty()) {
            return;
        }

        Map<Id, Integer> countMap = new Map<Id, Integer>();
        for (Id eqId : enquiryIds) {
            countMap.put(eqId, 0);
        }

        for (AggregateResult ar : [
            SELECT Enquiry__c eqId, COUNT(Id) totalCount
            FROM Enquiry_Product__c
            WHERE Enquiry__c IN :enquiryIds
            GROUP BY Enquiry__c
        ]) {
            countMap.put((Id) ar.get('eqId'), (Integer) ar.get('totalCount'));
        }

        List<Enquiry__c> toUpdate = new List<Enquiry__c>();
        for (Id eqId : enquiryIds) {
            toUpdate.add(new Enquiry__c(
                Id = eqId,
                Total_Products_Interested__c = countMap.get(eqId)
            ));
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}
