// Get a test Contact and Products
Contact c = [SELECT Id FROM Contact WHERE Email = 'rajesh.kumar@sparknest.test' LIMIT 1];
List<Product2> prods = [SELECT Id FROM Product2 WHERE SKU__c IN ('SKU-PD-001', 'SKU-SH-001', 'SKU-AC-001') LIMIT 3];

// Create an Enquiry
Enquiry__c enq = new Enquiry__c(
    Subject__c = 'Smart Home and Device Bundle Enquiry',
    Contact__c = c.Id,
    Enquiry_Type__c = 'Product Enquiry',
    Customer_Budget__c = 50000,
    Status__c = 'New'
);
insert enq;

// Insert 3 Enquiry_Product__c records
List<Enquiry_Product__c> epList = new List<Enquiry_Product__c>();
for (Product2 p : prods) {
    epList.add(new Enquiry_Product__c(
        Enquiry__c = enq.Id,
        Product__c = p.Id,
        Quantity_Interested__c = 1,
        Notes__c = 'Interested in demo'
    ));
}
insert epList;

// Re-query Enquiry to verify rollup
enq = [SELECT Id, Name, Total_Products_Interested__c FROM Enquiry__c WHERE Id = :enq.Id];
System.debug('ROLLUP_VERIFICATION: Enquiry ' + enq.Name + ' Total_Products_Interested__c = ' + enq.Total_Products_Interested__c);
System.assertEquals(3, enq.Total_Products_Interested__c, 'Rollup should equal 3');
