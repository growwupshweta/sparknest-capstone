@IsTest
private class GetEnquiryStatusActionTest {

    @TestSetup
    static void setup() {
        Contact c = new Contact(
            FirstName = 'Status',
            LastName = 'Tester',
            Email = 'status.tester@sparknest.test'
        );
        insert c;

        Enquiry__c enq = new Enquiry__c(
            Subject__c = 'Status Check Test Enquiry',
            Contact__c = c.Id,
            Enquiry_Type__c = 'Product Enquiry',
            Customer_Budget__c = 10000,
            Status__c = 'In Progress'
        );
        insert enq;
    }

    @IsTest
    static void testFindByEmail() {
        GetEnquiryStatusAction.Request req = new GetEnquiryStatusAction.Request();
        req.customerEmail = 'status.tester@sparknest.test';

        Test.startTest();
        List<GetEnquiryStatusAction.Response> responses = GetEnquiryStatusAction.checkStatus(
            new List<GetEnquiryStatusAction.Request>{ req }
        );
        Test.stopTest();

        System.assertEquals(1, responses.size());
        System.assertEquals(true, responses[0].isFound);
        System.assertEquals('In Progress', responses[0].status);
        System.assertEquals('Status Check Test Enquiry', responses[0].subject);
    }

    @IsTest
    static void testFindByNumber() {
        Enquiry__c enq = [SELECT Id, Name FROM Enquiry__c LIMIT 1];

        GetEnquiryStatusAction.Request req = new GetEnquiryStatusAction.Request();
        req.enquiryNumber = enq.Name;

        Test.startTest();
        List<GetEnquiryStatusAction.Response> responses = GetEnquiryStatusAction.checkStatus(
            new List<GetEnquiryStatusAction.Request>{ req }
        );
        Test.stopTest();

        System.assertEquals(1, responses.size());
        System.assertEquals(true, responses[0].isFound);
        System.assertEquals('In Progress', responses[0].status);
    }

    @IsTest
    static void testNotFound() {
        GetEnquiryStatusAction.Request req = new GetEnquiryStatusAction.Request();
        req.enquiryNumber = 'ENQ-99999';

        Test.startTest();
        List<GetEnquiryStatusAction.Response> responses = GetEnquiryStatusAction.checkStatus(
            new List<GetEnquiryStatusAction.Request>{ req }
        );
        Test.stopTest();

        System.assertEquals(1, responses.size());
        System.assertEquals(false, responses[0].isFound);
        System.assert(responses[0].message.contains('No enquiry found'));
    }
}
