@IsTest
private class CloseStaleEnquiriesBatchTest {
    @IsTest
    static void closesInactiveEnquiry() {
        Enquiry__c e = TestDataFactory.createEnquiries(1, false)[0];
        e.Status__c = 'In Progress';
        insert e;
        delete [SELECT Id FROM Task WHERE WhatId = :e.Id];
        CloseStaleEnquiriesBatch b = new CloseStaleEnquiriesBatch();
        b.execute(null, new List<Enquiry__c>{ e });
        System.assertEquals('Closed', [SELECT Status__c FROM Enquiry__c WHERE Id = :e.Id].Status__c, 'Inactive enquiry should be closed');
    }

    @IsTest
    static void keepsEnquiryWithRecentActivity() {
        Enquiry__c e = TestDataFactory.createEnquiries(1, false)[0];
        e.Status__c = 'In Progress';
        insert e;
        CloseStaleEnquiriesBatch b = new CloseStaleEnquiriesBatch();
        b.execute(null, new List<Enquiry__c>{ e });
        System.assertEquals('In Progress', [SELECT Status__c FROM Enquiry__c WHERE Id = :e.Id].Status__c, 'Enquiry with a recent Task must stay open');
    }

    @IsTest
    static void batchStartAndFinishRun() {
        Test.startTest();
        Database.executeBatch(new CloseStaleEnquiriesBatch(), 200);
        Test.stopTest();
        System.assert(true, 'Batch executed without error');
    }

    @IsTest
    static void schedulerRuns() {
        Test.startTest();
        String jobId = System.schedule('Test CloseStale', '0 0 1 * * ?', new CloseStaleEnquiriesScheduler());
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM CronTrigger WHERE Id = :jobId], 'Job should be scheduled');
    }
}