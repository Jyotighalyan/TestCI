/**
* @Description : Custom controller for UM_OrderAcknowlegementEmail vf component which is used in UM_OrderAcknowlegementEmail
*                vf email template.
* 
* @Author      : Trupti Rajput  
* @Story       : SFSLS-114
* @Since       : 09/01/2016
*/

public class UM_OrderAcknowlegementEmailController 
{
    public list<cscfga__Product_Configuration__c> productConfigurationList;
    private CSCAP__Customer_Approval__c custApporObj;
    private list<Opportunity> opportunityList;
    private list<cscfga__Product_Basket__c> productBasketList;
    private list <contact> contactList = new list<contact>();
    private list<user> userList;
    public String custApproId {get; set;}
    public string salutationContact {get;set;}
    public string salutationContact1 {get;set;}
    public string surnameContact{get;set;}
    public string orderdateCA{get;set;}
    public string firstNameOppOwner{get;set;}
    public string surnameOppOwner{get;set;}
    public string telephoneOppOwner{get;set;}
    public string faxNumberOppOwner{get;set;}
    public string mobNumberOppOwner{get;set;}
    public string emailOppOwner{get;set;}
    public string company{get;set;}
    public String address{get;set;}
    
    /**Constructor**/
    public UM_OrderAcknowlegementEmailController()
    {
        opportunityList = new list<Opportunity>();
        productBasketList = new list<cscfga__Product_Basket__c>(); 
        productConfigurationList = new list<cscfga__Product_Configuration__c>();
        userList = new list<user>();
    }
    
    /**
         * @author      : Trupti Rajput
         * @date        : 10/01/2016
         * @description : getter for list to be displyed in the page. required data is fetched 
                          from the data base with nested soql
    */
    public list<cscfga__Product_Configuration__c> getproductConfigurationList()
    {
        try
        {
            //custApproId ='a2C4E000002Q5FJ';
            if(custApproId != Null)
            {
               /*retrive opp id from customer approval id recieved from email template*/
               list<CSCAP__Customer_Approval__c> custApprList = [SELECT id,order_date__c,CSCAP__Contact__c from CSCAP__Customer_Approval__c where id =:custApproId];
               //  orderdateCA = string.valueof(custApprList[0].order_date__c);
               if (custApprList[0].order_date__c!=NULL)
                   orderdateCA = DateTime.newInstance(custApprList[0].order_date__c.year(),custApprList[0].order_date__c.month(),custApprList[0].order_date__c.day()).format('dd.MM.YYYY');
                
                if(!custApprList.isEmpty())
                {
                    
                    contactList = [select email,salutation,firstname,lastname from contact where id =:custApprList[0].CSCAP__Contact__c limit 1];
                    if(!contactList.isEmpty())
                    {
                    salutationContact1 = contactList[0].salutation;
                    surnameContact = contactList[0].lastname;
                        if(salutationContact1.contains('Mr'))
                           {
                          salutationContact='Herr';
                          }
                       else if(salutationContact1.contains('Ms'))
                           {
                           salutationContact='Frau';
                           //salutationContact = contactList[0].salutation;
                          }
                          
                       //salutationContact = contactList[0].salutation;
                       //surnameContact = contactList[0].lastname;
                    }
                    
                    opportunityList = [SELECT id,UM_QuotingDate__c,LG_PrimaryContact__c,ownerid 
                                       FROM Opportunity 
                                       WHERE id IN (SELECT CSCAP__Opportunity__c
                                                    FROM CSCAP__Customer_Approval__c 
                                                    WHERE id =: custApproId)];
                                                  
                    
                }                              
                if(!opportunityList.isEmpty())
                {
                   /*
                   fetch active product basket based on opp id and fetch product configuration from that product basket,
                   retrive product information from product configuration 
                   */
                      
                   
                   
                   userList = [select firstname, lastname, Fax,Phone,MobilePhone,CompanyName,email from user where id =: opportunityList[0].ownerid limit 1];
                   if(!userList.isEmpty())
                   {
                       firstNameOppOwner=userList[0].firstname;
                       surnameOppOwner=userList[0].lastname;
                       faxNumberOppOwner=userList[0].Fax;
                       telephoneOppOwner=userList[0].Phone;
                       mobNumberOppOwner=userList[0].MobilePhone;
                       emailOppOwner=userList[0].email;
                       company = userList[0].CompanyName;
                       
                       /* commented as logic is changed as part of SFOM-1224
                       if(company.equals(System.Label.UM_Unitymedia_NRW_GmbH))
                       {
                           address=Label.UM_Unitymedia_NRW_GmbH_Address;
                       }
                       else if(company.equals(System.Label.UM_Unitymedia_Hessen_GmbH_Co_KG))
                       {
                           address=Label.UM_Unitymedia_Hessen_GmbH_Co_KG_Address;
                       }
                       else if(company.equals(System.Label.UM_Unitymedia_BW_GmbH))
                       {
                           address=Label.UM_Unitymedia_BW_GmbH_Address;
                       }
                       else
                       {
                           address='';
                       } */
                       
                       //Added as part of SFOM-1224 for footer address logic
                       AggregateResult[] groupedResults = [select MAX(UM_State_Code__c) maxStateCode,MIN(UM_State_Code__c)  minStateCode from LG_OpportunityReport__c where LG_Opportunity__c =: opportunityList[0].id];
                       Integer maxStateCode = Integer.valueOf(groupedResults[0].get('maxStateCode'));
                       Integer minStateCode = Integer.valueOf(groupedResults[0].get('minStateCode'));
                       if ((maxStateCode == 3 && minStateCode <= 3) || (maxStateCode == null && minStateCode == null) || (maxStateCode == 2 && minStateCode == 1))
                       {
                           address=Label.UM_Unitymedia_NRW_GmbH_Updated_Address;
                       }
                       else if (maxStateCode == 2 && minStateCode == 2)
                       {                           
                           address=Label.UM_Unitymedia_Hessen_GmbH_Co_KG_Updated_Address;
                       }
                       else if (maxStateCode == 1 && minStateCode == 1)
                       {
                           address=Label.UM_Unitymedia_BW_GmbH_Updated_Address;
                       }
                       else
                       {
                           address='';
                       }
                   }
                }
           }
           return productConfigurationList;
        }
        catch(exception ex)
        {
            System.debug('An exception occurred: ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please contact system admin ' + ex.getMessage()));
            
            return null;
        }
    }
}