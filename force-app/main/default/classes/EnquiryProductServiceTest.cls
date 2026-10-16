@IsTest
private class EnquiryProductServiceTest {
    @TestSetup
    static void setupData() {
        Product2 p = new Product2(Name = 'Spark Pro Drone', IsActive = true, SKU__c = 'DRN-001');
        insert p;
    }

    @IsTest
    static void testRollupLifecycle() {
        Product2 prod = [SELECT Id FROM Product2 LIMIT 1];

        // 1. Create Enquiry
        Enquiry__c eq1 = new Enquiry__c(Subject__c = 'Product Info 1', Customer_Budget__c = 1500, Status__c = 'New');
        Enquiry__c eq2 = new Enquiry__c(Subject__c = 'Product Info 2', Customer_Budget__c = 2000, Status__c = 'New');
        insert new List<Enquiry__c>{ eq1, eq2 };

        // 2. Insert 2 Enquiry Products for eq1
        Enquiry_Product__c ep1 = new Enquiry_Product__c(Enquiry__c = eq1.Id, Product__c = prod.Id, Quantity_Interested__c = 2);
        Enquiry_Product__c ep2 = new Enquiry_Product__c(Enquiry__c = eq1.Id, Product__c = prod.Id, Quantity_Interested__c = 1);
        insert new List<Enquiry_Product__c>{ ep1, ep2 };

        eq1 = [SELECT Total_Products_Interested__c FROM Enquiry__c WHERE Id = :eq1.Id];
        System.assertEquals(2, eq1.Total_Products_Interested__c, 'Count should be 2 after inserting 2 products');

        // 3. Move ep2 to eq2 (Reparent)
        ep2.Enquiry__c = eq2.Id;
        update ep2;

        eq1 = [SELECT Total_Products_Interested__c FROM Enquiry__c WHERE Id = :eq1.Id];
        eq2 = [SELECT Total_Products_Interested__c FROM Enquiry__c WHERE Id = :eq2.Id];
        System.assertEquals(1, eq1.Total_Products_Interested__c, 'eq1 should have 1 product after move');
        System.assertEquals(1, eq2.Total_Products_Interested__c, 'eq2 should have 1 product after move');

        // 4. Delete ep1
        delete ep1;
        eq1 = [SELECT Total_Products_Interested__c FROM Enquiry__c WHERE Id = :eq1.Id];
        System.assertEquals(0, eq1.Total_Products_Interested__c, 'eq1 should have 0 products after delete');

        // 5. Undelete ep1
        undelete ep1;
        eq1 = [SELECT Total_Products_Interested__c FROM Enquiry__c WHERE Id = :eq1.Id];
        System.assertEquals(1, eq1.Total_Products_Interested__c, 'eq1 should have 1 product after undelete');
    }
}
