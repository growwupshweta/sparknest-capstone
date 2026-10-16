Profile salesRepProfile = [SELECT Id FROM Profile WHERE Name = 'SparkNest Sales Rep' LIMIT 1];
Profile supportAgentProfile = [SELECT Id FROM Profile WHERE Name = 'SparkNest Support Agent' LIMIT 1];
UserRole salesRepHydRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Sales_Rep_Hyderabad' LIMIT 1];
UserRole supportAgentHydRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Support_Agent_Hyderabad' LIMIT 1];

User arjun = [SELECT Id, Name, ProfileId, UserRoleId FROM User WHERE Username = 'arjun.shrma@gmail.com' LIMIT 1];
arjun.ProfileId = salesRepProfile.Id;
arjun.UserRoleId = salesRepHydRole.Id;
update arjun;
System.debug('Arjun updated successfully');

User sneha = [SELECT Id, Name, ProfileId, UserRoleId FROM User WHERE Username = 'sneha.nairsparknest2026@gmail.com' LIMIT 1];
sneha.ProfileId = supportAgentProfile.Id;
sneha.UserRoleId = supportAgentHydRole.Id;
update sneha;
System.debug('Sneha updated successfully');
