// Load 8 SparkNest Products
List<Product2> prods = new List<Product2>{
    new Product2(Name = 'SparkPhone X', ProductCode = 'SP-PH-X', SKU__c = 'SKU-PD-001', Product_Category__c = 'Personal Devices', IsActive = true, Description = 'Flagship 5G smartphone with dynamic AMOLED display'),
    new Product2(Name = 'SparkTab Pro', ProductCode = 'SP-TB-PRO', SKU__c = 'SKU-PD-002', Product_Category__c = 'Personal Devices', IsActive = true, Description = 'High performance tablet with active stylus support'),
    new Product2(Name = 'SparkEcho Hub', ProductCode = 'SP-SH-HUB', SKU__c = 'SKU-SH-001', Product_Category__c = 'Smart Home', IsActive = true, Description = 'Central smart home automation touch display and voice assistant'),
    new Product2(Name = 'SparkGlow Smart Light', ProductCode = 'SP-SH-GLOW', SKU__c = 'SKU-SH-002', Product_Category__c = 'Smart Home', IsActive = true, Description = 'Multi-color WiFi ambient LED smart lighting'),
    new Product2(Name = 'SparkNest Wireless Charger', ProductCode = 'SP-AC-WCHG', SKU__c = 'SKU-AC-001', Product_Category__c = 'Accessories', IsActive = true, Description = 'Fast 15W magnetic wireless charging stand'),
    new Product2(Name = 'SparkNest Fast Cable', ProductCode = 'SP-AC-FCBL', SKU__c = 'SKU-AC-002', Product_Category__c = 'Accessories', IsActive = true, Description = 'Durable braided 100W USB-C ultra-fast charging cable'),
    new Product2(Name = 'SparkCare Gold', ProductCode = 'SP-CP-GOLD', SKU__c = 'SKU-CP-001', Product_Category__c = 'Annual Care Plans', IsActive = true, Description = '1-year comprehensive warranty and priority support'),
    new Product2(Name = 'SparkCare Platinum', ProductCode = 'SP-CP-PLAT', SKU__c = 'SKU-CP-002', Product_Category__c = 'Annual Care Plans', IsActive = true, Description = '2-year all-inclusive accidental damage protection and 24/7 VIP assistance')
};
upsert prods SKU__c;
System.debug('Products upserted successfully: ' + prods.size());

// Load 10 Contacts across Hyderabad, Mumbai, Chennai
List<Contact> contacts = new List<Contact>{
    new Contact(FirstName = 'Rajesh', LastName = 'Kumar', Email = 'rajesh.kumar@sparknest.test', MailingCity = 'Hyderabad', MailingCountry = 'India', Phone = '+91 98765 43210'),
    new Contact(FirstName = 'Priya', LastName = 'Sharma', Email = 'priya.sharma@sparknest.test', MailingCity = 'Hyderabad', MailingCountry = 'India', Phone = '+91 98765 43211'),
    new Contact(FirstName = 'Venkat', LastName = 'Reddy', Email = 'venkat.reddy@sparknest.test', MailingCity = 'Hyderabad', MailingCountry = 'India', Phone = '+91 98765 43212'),
    new Contact(FirstName = 'Vikram', LastName = 'Verma', Email = 'vikram.verma@sparknest.test', MailingCity = 'Hyderabad', MailingCountry = 'India', Phone = '+91 98765 43213'),
    new Contact(FirstName = 'Suresh', LastName = 'Patel', Email = 'suresh.patel@sparknest.test', MailingCity = 'Mumbai', MailingCountry = 'India', Phone = '+91 98765 43214'),
    new Contact(FirstName = 'Neha', LastName = 'Deshmukh', Email = 'neha.deshmukh@sparknest.test', MailingCity = 'Mumbai', MailingCountry = 'India', Phone = '+91 98765 43215'),
    new Contact(FirstName = 'Amit', LastName = 'Joshi', Email = 'amit.joshi@sparknest.test', MailingCity = 'Mumbai', MailingCountry = 'India', Phone = '+91 98765 43216'),
    new Contact(FirstName = 'Karthik', LastName = 'Raman', Email = 'karthik.raman@sparknest.test', MailingCity = 'Chennai', MailingCountry = 'India', Phone = '+91 98765 43217'),
    new Contact(FirstName = 'Meenakshi', LastName = 'Sundaram', Email = 'meenakshi.sundaram@sparknest.test', MailingCity = 'Chennai', MailingCountry = 'India', Phone = '+91 98765 43218'),
    new Contact(FirstName = 'Deepa', LastName = 'Subramanian', Email = 'deepa.subramanian@sparknest.test', MailingCity = 'Chennai', MailingCountry = 'India', Phone = '+91 98765 43219')
};

// Check existing contacts by email so we don't hit duplicate rule
Set<String> emails = new Set<String>();
for (Contact c : contacts) {
    emails.add(c.Email);
}
Map<String, Contact> existingMap = new Map<String, Contact>();
for (Contact c : [SELECT Id, Email FROM Contact WHERE Email IN :emails]) {
    existingMap.put(c.Email, c);
}
List<Contact> toInsert = new List<Contact>();
for (Contact c : contacts) {
    if (!existingMap.containsKey(c.Email)) {
        toInsert.add(c);
    }
}
if (!toInsert.isEmpty()) {
    insert toInsert;
}
System.debug('Total SparkNest Contacts in org: ' + (existingMap.size() + toInsert.size()));
