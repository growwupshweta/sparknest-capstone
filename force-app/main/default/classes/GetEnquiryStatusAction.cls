public with sharing class GetEnquiryStatusAction {

    public class Request {
        @InvocableVariable(label='Enquiry Number' description='The ENQ-XXXX auto-number of the enquiry' required=false)
        public String enquiryNumber;

        @InvocableVariable(label='Customer Email' description='The email address associated with the enquiry' required=false)
        public String customerEmail;
    }

    public class Response {
        @InvocableVariable(label='Found' description='Whether an enquiry was found')
        public Boolean isFound;

        @InvocableVariable(label='Enquiry Number' description='Auto-number name')
        public String enquiryNumber;

        @InvocableVariable(label='Subject' description='Subject of the enquiry')
        public String subject;

        @InvocableVariable(label='Status' description='Current Status of the enquiry')
        public String status;

        @InvocableVariable(label='Enquiry Type' description='Product or Care Plan enquiry')
        public String enquiryType;

        @InvocableVariable(label='Owner Name' description='Current assignee/owner')
        public String ownerName;

        @InvocableVariable(label='Message' description='User-friendly status summary message')
        public String message;
    }

    @InvocableMethod(label='Check Enquiry Status' description='Retrieves the current status and summary of an enquiry using enquiry number or customer email for Agentforce')
    public static List<Response> checkStatus(List<Request> requests) {
        List<Response> responses = new List<Response>();

        for (Request req : requests) {
            Response res = new Response();
            List<Enquiry__c> enqs = new List<Enquiry__c>();

            if (String.isNotBlank(req.enquiryNumber)) {
                enqs = [
                    SELECT Id, Name, Subject__c, Status__c, Enquiry_Type__c, Owner.Name, Contact__r.Name
                    FROM Enquiry__c
                    WHERE Name = :req.enquiryNumber.trim()
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];
            } else if (String.isNotBlank(req.customerEmail)) {
                enqs = [
                    SELECT Id, Name, Subject__c, Status__c, Enquiry_Type__c, Owner.Name, Contact__r.Name
                    FROM Enquiry__c
                    WHERE Contact__r.Email = :req.customerEmail.trim()
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];
            }

            if (!enqs.isEmpty()) {
                Enquiry__c e = enqs[0];
                res.isFound = true;
                res.enquiryNumber = e.Name;
                res.subject = e.Subject__c;
                res.status = e.Status__c;
                res.enquiryType = e.Enquiry_Type__c;
                res.ownerName = e.Owner != null ? e.Owner.Name : 'Unassigned';
                res.message = 'Enquiry ' + e.Name + ' (' + e.Subject__c + ') is currently ' + e.Status__c + 
                              ' and is assigned to ' + res.ownerName + '.';
            } else {
                res.isFound = false;
                res.message = 'No enquiry found matching the provided details. Please verify the enquiry number or email address.';
            }

            responses.add(res);
        }

        return responses;
    }
}
