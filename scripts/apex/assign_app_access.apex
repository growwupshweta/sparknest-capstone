PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'SparkNest_App_Access' LIMIT 1];
List<User> users = [SELECT Id, Username FROM User WHERE Username IN ('singhshweta3024.584f9afd844e@agentforce.com', 'arjun.shrma@gmail.com', 'sneha.nairsparknest2026@gmail.com')];

List<PermissionSetAssignment> toInsert = new List<PermissionSetAssignment>();
Set<Id> existingAssignees = new Set<Id>();
for (PermissionSetAssignment psa : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :ps.Id]) {
    existingAssignees.add(psa.AssigneeId);
}

for (User u : users) {
    if (!existingAssignees.contains(u.Id)) {
        toInsert.add(new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = u.Id));
    }
}

if (!toInsert.isEmpty()) {
    insert toInsert;
    System.debug('SparkNest_App_Access assigned to ' + toInsert.size() + ' users.');
} else {
    System.debug('SparkNest_App_Access already assigned.');
}
