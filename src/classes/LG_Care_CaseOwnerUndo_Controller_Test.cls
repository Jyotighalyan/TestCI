@isTest
public class LG_Care_CaseOwnerUndo_Controller_Test {

    
    Static testmethod void testfindcases()
        
       
    {
        test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User testUser = new User(Alias = 'cAgnt', Email='careAgent@unityMediaorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='UM', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='careagent.testuser@unityMediaorg.com',CompanyName='Infosys');
        Insert testUser;
        
        List<Group> group1 = [select name, developername, type, email from group where developername = 'UM_SME_Repair_Queue'];
        
        System.runAs(testUser)
        {
             
         
            
        UM_Care_Queue__mdt queueList = [SELECT Id, developername from UM_Care_Queue__mdt where developername = 'SME_Complaint_Queue' ];
          
        List<RecordType> caseRecordTypes1 = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Technical Case')];
          
                Account a1 = new Account();
                a1.Name = 'test account';
                insert a1;
                
                Contact c1 = new Contact();
            	c1.Salutation = 'Mr';
                c1.LastName = 'test contact';
                insert c1;
                
                Case case1 = new Case();
                case1.RecordTypeId = caseRecordTypes1[0].Id;
                case1.AccountId = a1.Id;
                case1.ContactId = c1.Id;
                case1.Origin = 'Phone';
                case1.Type = 'Service Down';
                case1.Status = 'Assigned';
                case1.Priority = 'P1';
                case1.Subject = 'test subject';
                case1.Description = 'test description';
                case1.OwnerId = testUser.Id;
                insert case1;
                
            
            	case1.OwnerId = group1[0].Id;
                update case1;
            	
            
                case1.OwnerId = testUser.Id;
                update case1;
           		
             	
        LG_Care_CaseOwnerUndo_Controller a = new LG_Care_CaseOwnerUndo_Controller();
           	
            test.stopTest(); 
            
        }
        
        
    }
    
    
    Static testmethod void undoCaseOwnerTest()
    {
       
        List<LG_Care_CaseOwnerUndo_Controller.caseWrapper> caseWrapperList = new List<LG_Care_CaseOwnerUndo_Controller.caseWrapper>();
        
        LG_Care_CaseOwnerUndo_Controller.caseWrapper wrapper1 = new LG_Care_CaseOwnerUndo_Controller.caseWrapper();
        
        wrapper1.selected = true;
        caseWrapperList.add(wrapper1);
        
        LG_Care_CaseOwnerUndo_Controller.caseWrapper wrapper2 = new LG_Care_CaseOwnerUndo_Controller.caseWrapper();
        wrapper2.selected = false;
        caseWrapperList.add(wrapper2);
        
        LG_Care_CaseOwnerUndo_Controller a = new LG_Care_CaseOwnerUndo_Controller();
        a.undoCaseOwner();
    }
    

}