UserRole ceo = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
UserRole salesMgr = [SELECT Id, Name, ParentRoleId FROM UserRole WHERE DeveloperName = 'Sales_Manager_TechVerse' LIMIT 1];
UserRole supportMgr = [SELECT Id, Name, ParentRoleId FROM UserRole WHERE DeveloperName = 'Support_Manager' LIMIT 1];

salesMgr.Name = 'Sales Manager';
salesMgr.ParentRoleId = ceo.Id;
update salesMgr;

supportMgr.ParentRoleId = ceo.Id;
update supportMgr;

List<UserRole> existingMumbai = [SELECT Id FROM UserRole WHERE DeveloperName = 'Support_Agent_Mumbai'];
if (existingMumbai.isEmpty()) {
    UserRole supportMumbai = new UserRole(
        Name = 'Support Agent — Mumbai',
        DeveloperName = 'Support_Agent_Mumbai',
        ParentRoleId = supportMgr.Id
    );
    insert supportMumbai;
    System.debug('Created Support Agent — Mumbai');
} else {
    System.debug('Support Agent — Mumbai already exists');
}

System.debug('Role hierarchy successfully aligned with project brief!');
