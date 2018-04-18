/*
 * Test class for LG_ValidateMyBillDetails
 @ Author : Shruthi Gopal
 @ Date   : 23/10/2017
*/

@isTest
public class LG_CaseRelatedListControllerTest {
    public static testmethod void newCommentTest(){
        Profile p = [select id from profile where name='System Administrator'];
        User ur = new User();
            ur.FirstName = 'Test';
            ur.LastName = 'User2';
            ur.Email = 'test.user2@test.com';
            ur.Username = 'drder@test.com';
            ur.Alias = 'yjulrty';
            ur.CommunityNickname = 'derkui';
            ur.TimeZoneSidKey = 'Pacific/Fiji';
            ur.LocaleSidKey ='en_US';
            ur.EmailEncodingKey ='UTF-8';
               ur.ProfileId = p.Id;
         ur.LanguageLocaleKey ='en_US';
            ur.CompanyName = 'Test Company';
        insert ur;
              system.assertequals('Test',ur.FirstName);
        List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];

  Case c = new Case();
        c.CreatedById = ur.id;
        c.LastModifiedById = ur.id;
        c.RecordTypeId = caseRecordTypes[0].Id;
        insert c;
      
        CaseComment cc = new CaseComment();
        cc.LastModifiedDate = date.today();
        cc.LastModifiedById = ur.id;
        cc.CreatedById = ur.id;
       	cc.IsPublished = true;
        cc.CreatedDate = date.today();
       	cc.CommentBody = 'Test Body';
        cc.ParentId = c.id;
        insert cc;
        
        String action = 'Changed';
        
  LG_CaseRelatedListController crc = new LG_CaseRelatedListController();
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        test.startTest();
        crc.NewComment();
        crc.deleteComment();
        
        crc.makePublicPrivate();
        LG_CaseRelatedListController.cComments cCom = new LG_CaseRelatedListController.cComments();
        
        LG_CaseRelatedListController.caseHistories ch = new LG_CaseRelatedListController.caseHistories();
        
        test.stopTest();
    }
}}