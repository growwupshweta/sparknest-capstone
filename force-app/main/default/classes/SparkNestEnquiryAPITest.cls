@IsTest
private class SparkNestEnquiryAPITest {

    @TestSetup
    static void setupData() {
        Contact c = new Contact(
            FirstName = 'Existing',
            LastName = 'Customer',
            Email = 'existing.customer@sparknest.test',
            Phone = '+91 99999 88888',
            MailingCity = 'Mumbai'
        );
        insert c;
    }

    @IsTest
    static void testNewCustomer() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SparkNestEnquiry/';
        req.httpMethod = 'POST';

        SparkNestEnquiryAPI.EnquiryRequest body = new SparkNestEnquiryAPI.EnquiryRequest();
        body.firstName = 'Aarav';
        body.lastName = 'Mehta';
        body.email = 'aarav.mehta@sparknest.test';
        body.phone = '+91 98111 22233';
        body.city = 'Hyderabad';
        body.subject = 'Interest in Smart Light';
        body.enquiryType = 'Product Enquiry';
        body.budget = 5000;
        body.description = 'Looking for RGB lights';

        req.requestBody = Blob.valueOf(JSON.serialize(body));
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        SparkNestEnquiryAPI.handlePost();
        Test.stopTest();

        System.assertEquals(201, res.statusCode, 'Should return HTTP 201: ' + (res.responseBody != null ? res.responseBody.toString() : 'null'));
        String responseStr = res.responseBody.toString();
        System.assert(responseStr.contains('"status":"success"'), 'Response should be success');
        System.assert(responseStr.contains('"isNewCustomer":true'), 'Should be flagged as new customer');

        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE Email = 'aarav.mehta@sparknest.test'];
        System.assertEquals(1, createdContacts.size(), 'Contact should have been created');
        List<Enquiry__c> createdEnqs = [SELECT Id, Subject__c, Contact__c FROM Enquiry__c WHERE Contact__c = :createdContacts[0].Id];
        System.assertEquals(1, createdEnqs.size(), 'Enquiry should have been created');
    }

    @IsTest
    static void testExistingCustomer() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SparkNestEnquiry/';
        req.httpMethod = 'POST';

        SparkNestEnquiryAPI.EnquiryRequest body = new SparkNestEnquiryAPI.EnquiryRequest();
        body.firstName = 'Existing';
        body.lastName = 'Customer';
        body.email = 'existing.customer@sparknest.test';
        body.subject = 'Care Plan Upgrade';
        body.enquiryType = 'Care Plan Enquiry';
        body.budget = 12000;

        req.requestBody = Blob.valueOf(JSON.serialize(body));
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        SparkNestEnquiryAPI.handlePost();
        Test.stopTest();

        System.assertEquals(201, res.statusCode, 'Should return HTTP 201: ' + (res.responseBody != null ? res.responseBody.toString() : 'null'));
        String responseStr = res.responseBody.toString();
        System.assert(responseStr.contains('"isNewCustomer":false'), 'Should be flagged as existing customer');

        Contact existing = [SELECT Id FROM Contact WHERE Email = 'existing.customer@sparknest.test' LIMIT 1];
        List<Enquiry__c> enqs = [SELECT Id, Subject__c FROM Enquiry__c WHERE Contact__c = :existing.Id];
        System.assertEquals(1, enqs.size(), 'Enquiry should link to existing contact');
    }

    @IsTest
    static void testMissingEmail() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SparkNestEnquiry/';
        req.httpMethod = 'POST';

        SparkNestEnquiryAPI.EnquiryRequest body = new SparkNestEnquiryAPI.EnquiryRequest();
        body.firstName = 'No';
        body.lastName = 'Email';
        body.subject = 'Missing Email Request';
        body.budget = 5000;

        req.requestBody = Blob.valueOf(JSON.serialize(body));
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        SparkNestEnquiryAPI.handlePost();
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'Should return HTTP 400');
        String responseStr = res.responseBody.toString();
        System.assert(responseStr.contains('Email is required'), 'Should complain about missing email');
    }

    @IsTest
    static void testEmptyBody() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SparkNestEnquiry/';
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        SparkNestEnquiryAPI.handlePost();
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'Should return HTTP 400 for empty body');
    }

    @IsTest
    static void testInvalidBudget() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SparkNestEnquiry/';
        req.httpMethod = 'POST';

        SparkNestEnquiryAPI.EnquiryRequest body = new SparkNestEnquiryAPI.EnquiryRequest();
        body.firstName = 'Low';
        body.lastName = 'Budget';
        body.email = 'low.budget@sparknest.test';
        body.subject = 'Low Budget Enquiry';
        body.budget = 500; // Violates MIN_BUDGET 1000

        req.requestBody = Blob.valueOf(JSON.serialize(body));
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        SparkNestEnquiryAPI.handlePost();
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'Should return HTTP 400 for validation failure');
    }
}
