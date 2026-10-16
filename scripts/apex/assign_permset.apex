PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Senior_Sales_Rep' LIMIT 1];
User arjun = [SELECT Id FROM User WHERE Username = 'arjun.shrma@gmail.com' LIMIT 1];

List<PermissionSetAssignment> existing = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :ps.Id AND AssigneeId = :arjun.Id];
if (existing.isEmpty()) {
    insert new PermissionSetAssignment(
        PermissionSetId = ps.Id,
        AssigneeId = arjun.Id
    );
    System.debug('Senior Sales Rep assigned to Arjun Sharma successfully.');
} else {
    System.debug('Senior Sales Rep is already assigned to Arjun Sharma.');
}
