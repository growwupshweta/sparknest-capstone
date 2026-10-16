@IsTest
private class EnquiryServiceTest {
    @IsTest
    static void blankStatusDefaultsToNew() {
        Enquiry__c e = TestDataFactory.createEnquiries(1, false)[0];
        e.Status__c = null;
        insert e;
        Enquiry__c result = [SELECT Status__c FROM Enquiry__c WHERE Id = :e.Id];
        System.assertEquals('New', result.Status__c, 'Blank status should default to New');
    }

    @IsTest
    static void lowBudgetFails() {
        Enquiry__c e = TestDataFactory.createEnquiries(1, false)[0];
        e.Customer_Budget__c = 500;
        Test.startTest();
        Database.SaveResult sr = Database.insert(e, false);
        Test.stopTest();
        System.assert(!sr.isSuccess(), 'Insert should fail for budget below 1000');
        System.assert(sr.getErrors()[0].getMessage().contains('at least'), 'Expected budget error message');
    }

    @IsTest
    static void insertCreatesFollowUpTask() {
        Enquiry__c e = TestDataFactory.createEnquiries(1, true)[0];
        Task t = [SELECT Subject, OwnerId, ActivityDate FROM Task WHERE WhatId = :e.Id LIMIT 1];
        System.assertEquals('Follow up: ' + e.Subject__c, t.Subject, 'Task subject mismatch');
        System.assertEquals(UserInfo.getUserId(), t.OwnerId, 'Task owner should be the Enquiry owner');
        System.assertEquals(Date.today().addDays(3), t.ActivityDate, 'Task due date should be 3 days out');
    }

    @IsTest
    static void closingStampsClosedDate() {
        Enquiry__c e = TestDataFactory.createEnquiries(1, true)[0];
        e.Status__c = 'Closed';
        update e;
        Enquiry__c result = [SELECT Closed_Date__c FROM Enquiry__c WHERE Id = :e.Id];
        System.assertEquals(Date.today(), result.Closed_Date__c, 'Closed Date should be today');
    }

    @IsTest
    static void bulkInsert200() {
        List<Enquiry__c> list1 = TestDataFactory.createEnquiries(200, false);
        Test.startTest();
        insert list1;
        Test.stopTest();
        System.assertEquals(200, [SELECT COUNT() FROM Enquiry__c], 'All 200 enquiries should insert');
        System.assertEquals(200, [SELECT COUNT() FROM Task WHERE Subject LIKE 'Follow up:%'], '200 tasks expected');
    }
}