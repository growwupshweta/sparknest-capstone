// Test Auto_close_Follow_up_Tasks Flow
Contact c = [SELECT Id FROM Contact WHERE Email = 'rajesh.kumar@sparknest.test' LIMIT 1];

// 1. Create an Enquiry (EnquiryService will auto-create a follow-up Task)
Enquiry__c enq = new Enquiry__c(
    Subject__c = 'Flow Verification Test Enquiry',
    Contact__c = c.Id,
    Enquiry_Type__c = 'Care Plan Enquiry',
    Customer_Budget__c = 15000,
    Status__c = 'New'
);
insert enq;

// Verify follow-up task was created
List<Task> openTasks = [SELECT Id, Subject, Status FROM Task WHERE WhatId = :enq.Id];
System.debug('Tasks after Enquiry creation: ' + openTasks.size());
System.assert(!openTasks.isEmpty(), 'A follow-up task should have been created');
System.assertEquals('Not Started', openTasks[0].Status);

// 2. Update Enquiry Status to Closed (should fire Auto_close_Follow_up_Tasks flow)
enq.Status__c = 'Closed';
update enq;

// 3. Verify task is now marked Completed by the flow
Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :openTasks[0].Id];
System.debug('Task status after Enquiry closed: ' + updatedTask.Status);
System.assertEquals('Completed', updatedTask.Status, 'Task should be auto-closed by flow');

// 4. Test Convert_Enquiry_to_Case Flow invocation via Flow.Interview
Map<String, Object> flowParams = new Map<String, Object>();
Enquiry__c enq2 = new Enquiry__c(
    Subject__c = 'Convert Flow Verification Enquiry',
    Contact__c = c.Id,
    Enquiry_Type__c = 'Care Plan Enquiry',
    Customer_Budget__c = 20000,
    Status__c = 'New'
);
insert enq2;

flowParams.put('recordId', enq2.Id);
Flow.Interview.Convert_Enquiry_to_Case convertFlow = new Flow.Interview.Convert_Enquiry_to_Case(flowParams);
// Flow interview instantiation succeeded
System.debug('Convert_Enquiry_to_Case instantiated successfully with recordId: ' + enq2.Id);
