Product2 p = [SELECT Id FROM Product2 LIMIT 1];
Enquiry__c eq = new Enquiry__c(Subject__c = 'Test', Customer_Budget__c = 1500, Status__c = 'New');
insert eq;
try {
    Enquiry_Product__c ep = new Enquiry_Product__c(Enquiry__c = eq.Id, Product__c = p.Id, Quantity_Interested__c = 2);
    insert ep;
    System.debug('Inserted successfully: ' + ep.Id);
} catch (Exception ex) {
    System.debug('ERROR OCCURRED: ' + ex.getMessage());
    System.debug('STACK TRACE: ' + ex.getStackTraceString());
}
