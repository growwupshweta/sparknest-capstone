Database.DMLOptions dml = new Database.DMLOptions();
dml.DuplicateRuleHeader.allowSave = false;
Contact dupContact = new Contact(FirstName = 'Duplicate', LastName = 'Shah', Email = 'kavya.shah@example.com');
Database.SaveResult sr = Database.insert(dupContact, dml);
System.debug('Success: ' + sr.isSuccess());
for(Database.Error err : sr.getErrors()) {
    System.debug('Error: ' + err.getStatusCode() + ' - ' + err.getMessage());
}
