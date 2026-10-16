@IsTest
public class TestDataFactory {
    public static List<Enquiry__c> createEnquiries(Integer count, Boolean doInsert) {
        List<Enquiry__c> list1 = new List<Enquiry__c>();
        for (Integer i = 0; i < count; i++) {
            list1.add(new Enquiry__c(
                Subject__c = 'Test Enquiry ' + i,
                Customer_Budget__c = 5000
            ));
        }
        if (doInsert) {
            insert list1;
        }
        return list1;
    }
}