@RestResource(urlMapping='/SparkNestEnquiry/*')
global with sharing class SparkNestEnquiryAPI {

    global class EnquiryRequest {
        public String firstName;
        public String lastName;
        public String email;
        public String phone;
        public String city;
        public String subject;
        public String enquiryType;
        public Decimal budget;
        public String description;
    }

    global class ApiResponse {
        public String status;
        public String message;
        public String contactId;
        public String enquiryId;
        public Boolean isNewCustomer;

        public ApiResponse(String status, String message) {
            this.status = status;
            this.message = message;
        }

        public ApiResponse(String contactId, String enquiryId, Boolean isNewCustomer) {
            this.status = 'success';
            this.contactId = contactId;
            this.enquiryId = enquiryId;
            this.isNewCustomer = isNewCustomer;
        }
    }

    @HttpPost
    global static void handlePost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        try {
            if (req.requestBody == null) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(new ApiResponse('error', 'Request body cannot be empty')));
                return;
            }

            String jsonString = req.requestBody.toString();
            EnquiryRequest body = (EnquiryRequest) JSON.deserialize(jsonString, EnquiryRequest.class);

            // Validation: Scenario 3 - Missing Email
            if (String.isBlank(body.email)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(new ApiResponse('error', 'Email is required')));
                return;
            }

            // Check if contact exists (Scenario 2 vs Scenario 1)
            List<Contact> existingContacts = [
                SELECT Id, FirstName, LastName, Email 
                FROM Contact 
                WHERE Email = :body.email 
                LIMIT 1
            ];

            Id contactId;
            Boolean isNew = false;

            if (!existingContacts.isEmpty()) {
                contactId = existingContacts[0].Id;
            } else {
                isNew = true;
                Contact newContact = new Contact(
                    FirstName = body.firstName,
                    LastName = String.isNotBlank(body.lastName) ? body.lastName : 'Customer',
                    Email = body.email,
                    Phone = body.phone,
                    MailingCity = body.city
                );
                insert newContact;
                contactId = newContact.Id;
            }

            // Create Enquiry
            Enquiry__c enq = new Enquiry__c(
                Subject__c = String.isNotBlank(body.subject) ? body.subject : 'Website Storefront Enquiry',
                Contact__c = contactId,
                Enquiry_Type__c = String.isNotBlank(body.enquiryType) ? body.enquiryType : 'Product Enquiry',
                Customer_Budget__c = body.budget,
                Description__c = body.description,
                Source__c = 'Website',
                Status__c = 'New'
            );
            insert enq;

            res.statusCode = 201;
            res.responseBody = Blob.valueOf(JSON.serialize(new ApiResponse(contactId, enq.Id, isNew)));

        } catch (DmlException de) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(new ApiResponse('error', de.getDmlMessage(0))));
        } catch (Exception ex) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(new ApiResponse('error', ex.getMessage())));
        }
    }
}
