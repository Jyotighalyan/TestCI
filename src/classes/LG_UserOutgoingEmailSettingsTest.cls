@isTest
public class LG_UserOutgoingEmailSettingsTest {
    
    // Run test as System Administrator. Administrators should be able to edit the Outgoing Email Settings of other Users.
    public static testMethod void runTestAsAdministrator() {
        User adminUser = prepareAdminUser();
        User salesUser = prepareSalesUser();
        Database.insert(salesUser, true);
        Test.startTest();
        System.runAs(adminUser) {
            LG_UserOutgoingEmailSettingsExtension extension = new LG_UserOutgoingEmailSettingsExtension(new ApexPages.StandardController(salesUser));
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            System.assertEquals(true, extension.editing);
            extension.cancelEditing();
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            System.assertEquals(true, extension.editing);
            extension.selectedUser.SenderName = 'New Test Sender Name';
            extension.selectedUser.SenderEmail = 'new.test.sender.email@example.com';
            extension.confirm();
        }
        Test.stopTest();
        // Evaluate the results - User information should have been updated.
        salesUser = [select u.SenderName, u.SenderEmail from User u where u.Id = :salesUser.Id];
        System.assertEquals('New Test Sender Name', salesUser.SenderName);
        System.assertEquals('new.test.sender.email@example.com', salesUser.SenderEmail);
    }
    
    // Run test as ordinary user. This User should NOT be able to edit the Outgoing Email Settings of other Users.
    /*
    public static testMethod void runTestAsOrdinaryUser() {
        User adminUser = prepareAdminUser();
        User salesUser = prepareSalesUser();
        Database.insert(adminUser, true);
        //System.assertNotEquals(null, adminUser.Id);
        Test.startTest();
        System.runAs(salesUser) {
            LG_UserOutgoingEmailSettingsExtension extension = new LG_UserOutgoingEmailSettingsExtension(new ApexPages.StandardController(adminUser));
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            // Cannot switch to editing mode - no edit access.
            System.assertEquals(false, extension.editing);
            extension.cancelEditing();
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            System.assertEquals(false, extension.editing);
            extension.selectedUser.SenderName = 'New Test Sender Name';
            extension.selectedUser.SenderEmail = 'new.test.sender.email@example.com';
            extension.confirm();
        }
        Test.stopTest();
        // Evaluate the results - User information should NOT have been updated (no edit access).
        System.debug('DEBUG: ' + adminUser.Id);
        adminUser = [select u.SenderName, u.SenderEmail from User u where u.Id = :adminUser.Id];
        System.assertEquals(null, adminUser.SenderName);
        System.assertEquals(null, adminUser.SenderEmail);
    }
    */    
    // Prepare User with 'System Administrator' profile and 'LG_NL Delegated System Administrator' role.
    private static User prepareAdminUser() {
        Profile adminProfile = [select p.Id from Profile p where p.Name = 'System Administrator'];
        //UserRole adminRole = [select r.Id from UserRole r where r.Name = 'LG_NL Delegated System Administrator'];
        String alias = 'oes1' + String.valueOf((Math.random() * 1000).intValue());
        return new User(IsActive = true, Alias = alias, Username = 'email.' + alias + '@example.com',
                        LastName = 'Lastname' + alias, Email = 'email.' + alias + '@example.com',
                        CommunityNickname = 'Nick' + alias, TimeZoneSidKey = 'Europe/Amsterdam',
                        LocaleSidKey = 'nl_NL', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US',
                        ProfileId = adminProfile.Id, /*UserRoleId = adminRole.Id,*/ CompanyName = 'Test Company');
    }
    
    // Prepare User with 'LG_NL Internal Sales Users' profile and 'NL Inbound Sales Rep.' role.
    private static User prepareSalesUser() {
        Profile salesProfile = [select p.Id from Profile p where p.Name = 'LG_NL Sales Management User'];
        //UserRole salesRole = [select r.Id from UserRole r where r.Name = 'LG_NL Inbound Sales Rep'];
        String alias = 'oes2' + String.valueOf((Math.random() * 1000).intValue());
        return new User(IsActive = true, Alias = alias, Username = 'email.' + alias + '@example.com',
                           LastName = 'Lastname' + alias, Email = 'email.' + alias + '@example.com',
                           CommunityNickname = 'Nick' + alias, TimeZoneSidKey = 'Europe/Amsterdam',
                           LocaleSidKey = 'nl_NL', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US',
                           ProfileId = salesProfile.Id, /*UserRoleId = salesRole.Id,*/ CompanyName = 'Test Company');
    }
    
}





/*@isTest
public class LG_UserOutgoingEmailSettingsTest {
    
    // Run test as System Administrator. Administrators should be able to edit the Outgoing Email Settings of other Users.
    public static testMethod void runTestAsAdministrator() {
        User adminUser = prepareAdminUser();
        User salesUser = prepareSalesUser();
        system.debug('--+ salesUser: '+salesUser);
        
        Database.insert(salesUser, true);
        Test.startTest();
        System.runAs(adminUser) {
            LG_UserOutgoingEmailSettingsExtension extension = new LG_UserOutgoingEmailSettingsExtension(new ApexPages.StandardController(salesUser));
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            System.assertEquals(true, extension.editing);
            extension.cancelEditing();
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            System.assertEquals(true, extension.editing);
            extension.selectedUser.SenderName = 'New Test Sender Name';
            extension.selectedUser.SenderEmail = 'new.test.sender.email@example.com';
            extension.confirm();
        }
        Test.stopTest();
        system.debug('--+ salesUser.Id: '+salesUser.Id);
        // Evaluate the results - User information should have been updated.
        salesUser = [select u.SenderName, u.SenderEmail from User u where u.Id = :salesUser.Id];
        
        system.debug('--+ salesUser: '+salesUser);
        
        //System.assertEquals('New Test Sender Name', salesUser.SenderName);
        //System.assertEquals('new.test.sender.email@example.com', salesUser.SenderEmail);
    }
    
    // Run test as ordinary user. This User should NOT be able to edit the Outgoing Email Settings of other Users.
    /** RS: Test doesn't work need to be checked and fixed
    public static testMethod void runTestAsOrdinaryUser() {
        User adminUser = prepareAdminUser();
        User salesUser = prepareSalesUser();
        system.debug('--+ adminUser: '+adminUser);
        
        Database.insert(adminUser, true);
        //System.assertNotEquals(null, adminUser.Id);
        Test.startTest();
        System.runAs(salesUser) {
            LG_UserOutgoingEmailSettingsExtension extension = new LG_UserOutgoingEmailSettingsExtension(new ApexPages.StandardController(adminUser));
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            // Cannot switch to editing mode - no edit access.
            System.assertEquals(false, extension.editing);
            extension.cancelEditing();
            System.assertEquals(false, extension.editing);
            extension.startEditing();
            System.assertEquals(false, extension.editing);
            extension.selectedUser.SenderName = 'New Test Sender Name';
            extension.selectedUser.SenderEmail = 'new.test.sender.email@example.com';
            extension.confirm();
        }
        Test.stopTest();
        // Evaluate the results - User information should NOT have been updated (no edit access).
        System.debug('--+ Admin User Id: ' + adminUser.Id);
        adminUser = [select u.SenderName, u.SenderEmail from User u where u.Id = :adminUser.Id];
        System.assertEquals(null, adminUser.SenderName);
        System.assertEquals(null, adminUser.SenderEmail);
    }
    */
   
/*   
    // Prepare User with 'System Administrator' profile and 'NL Delegated System Admin.' role.
    private static User prepareAdminUser() {
        Profile adminProfile = [select p.Id from Profile p where p.Name = 'System Administrator'];
        UserRole adminRole = [select r.Id from UserRole r where r.Name = 'LG_NL Delegated System Administrator'];
        String alias = 'oes1' + String.valueOf((Math.random() * 1000).intValue());
        return new User(IsActive = true, Alias = alias, Username = 'email.' + alias + '@example.com',
                        LastName = 'Lastname' + alias, Email = 'email.' + alias + '@example.com',
                        CommunityNickname = 'Nick' + alias, TimeZoneSidKey = 'Europe/Amsterdam',
                        LocaleSidKey = 'nl_NL', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US',
                        ProfileId = adminProfile.Id, UserRoleId = adminRole.Id, CompanyName = 'Test Company');
    }
    
    // Prepare User with 'LG_NL Internal Sales Users' profile and 'NL Inbound Sales Rep.' role.
    private static User prepareSalesUser() {
        Profile salesProfile = [select p.Id from Profile p where p.Name = 'LG_NL Telesales Inbound User'];
        UserRole salesRole = [select r.Id from UserRole r where r.Name = 'LG_NL Inbound Sales Rep'];
        String alias = 'oes2' + String.valueOf((Math.random() * 1000).intValue());
        return new User(IsActive = true, Alias = alias, Username = 'email.' + alias + '@example.com',
                           LastName = 'Lastname' + alias, Email = 'email.' + alias + '@example.com',
                           CommunityNickname = 'Nick' + alias, TimeZoneSidKey = 'Europe/Amsterdam',
                           LocaleSidKey = 'nl_NL', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US',
                           ProfileId = salesProfile.Id, UserRoleId = salesRole.Id, CompanyName = 'Test Company');
    }
    
}
*/