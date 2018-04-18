@isTest
public Class LG_Care_MedalliaRelation_Batch_Test{
    
    @isTest Static void MedalliaCallRelation(){ 
        
        List<id> Mid = New List<id>();
    
        List<Contact> Cntcs= new List<Contact>();
                       
                
                Account MAcc = New Account();
                MAcc.Name='Medalia Account';
                MAcc.LG_VisitCountry__c ='Germany';
                Insert MAcc;
                   
                Contact MCon = New Contact();
                MCon.Salutation='Mr.';
                MCon.LastName='NPS Test Contact';
                MCon.Email='Nilesh_tanwar@infosys.com';
                MCon.Accountid = MAcc.id;
                MCon.LG_Role__c='Business User';
                MCon.LG_Care_Survey_Opt_Out__c=false;
                //MCon.LG_Care_Relationship_Survey_Sent_Date__c=null;
                //Insert MCon;
                Cntcs.add(MCon);
                Contact Mcon1 = New Contact();
                MCon1.Salutation='Mr.';
                MCon1.LastName='Medalia Test';
                MCon1.Email='Rishi.kapoor@infosys.com';
                MCon1.Accountid= MAcc.id; 
                MCon1.LG_Care_Survey_Opt_Out__c=false;
                MCon1.LG_Role__c='Business User';
                //MCon1.LG_Care_Relationship_Survey_Sent_Date__c=null;
                Cntcs.add(MCon1);
                Contact Mcon2 = New Contact();
                MCon2.Salutation='Mr.';
                MCon2.LastName='Medalia Test2';
                MCon2.Email='Rishi.kapoor23@infosys.com';
                MCon2.Accountid= MAcc.id; 
                MCon2.LG_Care_Survey_Opt_Out__c=false;
                MCon2.LG_Role__c='Business User';
                //MCon2.LG_Care_Relationship_Survey_Sent_Date__c=null;
              //  Insert Mcon2;
                Cntcs.add(MCon2);
      
                Insert Cntcs;
               
               
                
                csord__Subscription__c sub = new csord__Subscription__c();
                sub.Name = 'Company Fiber';
                sub.csord__Account__c = MAcc.id;
                sub.csord__Identification__c = 'Test Identification';
                sub.csord__Status__c='Active';
                insert sub;
                
                cscfga__Product_Configuration__c prodConfig= new cscfga__Product_Configuration__c();
                prodConfig.Name='Test One';
                prodConfig.cscfga__Product_Family__c='Company Fiber';
                insert prodConfig;
                
                
                cscfga__Product_Configuration__c prodConfig2= new cscfga__Product_Configuration__c();
                prodConfig2.Name='Test Two';
                prodConfig2.cscfga__Product_Family__c='Company Internet';
                insert prodConfig2;
                
                cscfga__Product_Configuration__c prodConfig3= new cscfga__Product_Configuration__c();
                prodConfig3.Name='Test Three';
                prodConfig3.cscfga__Product_Family__c='WLAN';
                insert prodConfig3;
                
                csord__Service__c service = new csord__Service__c();
                service.csord__Subscription__c = sub.id;
                service.LG_ServiceExternalId__c = '112245 testing';
                service.LG_SLA__c = 'Gold';
                service.Name = 'Company fiber';
                service.csord__Status__c = 'Active';
               
                service.csord__Identification__c ='test Identification';
                service.csordtelcoa__Product_Configuration__c=prodConfig.id;
                insert service;
                
                
                csord__Service__c service2 = new csord__Service__c();
                service2.csord__Subscription__c = sub.id;
                service2.LG_ServiceExternalId__c = '00023456';
                service2.Name = 'Company Internet';
                service2.csord__Status__c = 'Active';
                 service2.csord__Identification__c ='test Identification';
                service2.csordtelcoa__Product_Configuration__c=prodConfig2.id;
                insert service2;
                
                csord__Service__c service3 = new csord__Service__c();
                service3.csord__Subscription__c = sub.id;
                service3.LG_ServiceExternalId__c = '00007';
                service3.Name = 'WLAN';
                service3.csord__Status__c = 'Active';
             
                service3.csord__Identification__c ='test Identification';
                service3.csordtelcoa__Product_Configuration__c=prodConfig3.id;
                insert service3;
                
                
                B2B_Care_Ext_Connections__c MedalliaConnBrand = new B2B_Care_Ext_Connections__c();
                MedalliaConnBrand.Name = 'Germany';
                MedalliaConnBrand.Brand__c = 'Unitymedia Business';               
                insert MedalliaConnBrand;
                
                B2B_Care_Ext_Connections__c MedalliaConn = new B2B_Care_Ext_Connections__c();
                MedalliaConn.Name = 'Medallia Relational System Info';
                MedalliaConn.UM_No_of_Tries__c = 3;
                MedalliaConn.Connection_URL__c = 'https://libertyglobal.medallia.eu';       
                insert MedalliaConn;
                
                LG_Care_Medallia_Settings__c MedalliaRecord= new LG_Care_Medallia_Settings__c();
                MedalliaRecord.Name='Default';
                MedalliaRecord.LG_Care_Contact_Created_Date__c =-1;
                MedalliaRecord.LG_Care_Contact_Role__c='Business User';
                MedalliaRecord.LG_Care_Max_Number_of_Contacts__c=100;
                MedalliaRecord.LG_Care_Last_rNPS_Send_Date__c=-1;
                insert MedalliaRecord;
         
                Test.StartTest();
                LG_Care_MedalliaRelationshipSurvey_Batch b = new LG_Care_MedalliaRelationshipSurvey_Batch();
                 Database.executeBatch(b);
      
                
           //   Test.setMock(HttpCalloutMock.class, new LG_Care_SBC_MockHttpResponseGenerator());
              /*  LG_Care_Medallia_Relationship_Survey.Create_Medallia_NPS_JSON_Request(camp); 
                for(Contact con : [SELECT Email,LG_Care_Relationship_Survey_Sent_Date__c  from Contact limit 1]){
                    //System.debug('----------- '+ con.Email);
                    //System.debug('----------- '+ con.LG_Care_Relationship_Survey_Sent_Date__c  );
                    system.assertNotEquals(Null,con.LG_Care_Relationship_Survey_Sent_Date__c );
                }*/
                Test.StopTest();
                
                //system.assertNotEquals(Null,LG_Care_MedalliaRelationshipSurvey_Batch.RqstFile); 
            
            
            
        
    }
    
}