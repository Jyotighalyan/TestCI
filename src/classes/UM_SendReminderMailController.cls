public class UM_SendReminderMailController {

    public String Approvelink { get; set; }
    
    private CSCAP__Customer_Approval__c custApporObj;
    private list<CSCAP__Customer_Approval__c > custAppList;
    Set<Id> customerApprovalIdSet;
     private list<cscfga__Product_Basket__c> productBasketList;
    public list<cscfga__Product_Configuration__c> productConfigurationList;
    private list <contact> contactList = new list<contact>();
    private list<user> userList;
    public String oppId {get; set;}
    public string salutationContact {get;set;}
    public string surnameContact{get;set;}
    public string keyCA{get;set;}
    public string orderdateCA{get;set;}
    public string quotedate{get;set;}
    public string firstNameOppOwner{get;set;}
    public string surnameOppOwner{get;set;}
    public string telephoneOppOwner{get;set;}
    public string faxNumberOppOwner{get;set;}
    public string mobNumberOppOwner{get;set;}
    public string emailOppOwner{get;set;}
    public string company{get;set;}
    public String address{get;set;}
    
    /**Constructor**/
    public UM_SendReminderMailController ()
    {
    System.debug('*** Constructor');
        custAppList= new list<CSCAP__Customer_Approval__c>();
        customerApprovalIdSet=new Set<id>();
        userList = new list<user>();
         productBasketList = new list<cscfga__Product_Basket__c>(); 
        productConfigurationList = new list<cscfga__Product_Configuration__c>();
    }
    public list<cscfga__Product_Configuration__c> getproductConfigurationList()
    {
        try
        {
            if(oppId != Null)
            {
                Opportunity opp=[Select Id,name,UM_QuotingDate__c,LG_LastStageChangeDate__c,stagename,LG_PrimaryContact__c,Ownerid,(Select id,order_date__c,CSCAP__Key__c  from CSCAP__Customer_Approvals__r) FROM Opportunity Where Id=:oppId];
                System.debug('***shubh opp'+ opp);
                if(opp.stagename=='Quotation Delivered' && opp.LG_LastStageChangeDate__c!=null)
                    quotedate=DateTime.newInstance(opp.LG_LastStageChangeDate__c.year(),opp.LG_LastStageChangeDate__c.month(),opp.LG_LastStageChangeDate__c.day()).format('dd.MM.YYYY');
                for(CSCAP__Customer_Approval__c customerApprovalIterator : opp.CSCAP__Customer_Approvals__r)
                {
                    customerApprovalIdSet.add(customerApprovalIterator.id);
                    System.debug('***shubh customerApprovalIdSet'+ customerApprovalIdSet);
                }
                CSCAP__Customer_Approval__c CApproval=[Select id,order_date__c,CSCAP__Key__c from CSCAP__Customer_Approval__c where id in:customerApprovalIdSet order by CreatedDate desc LIMIT 1];   
                System.debug('***shubh CSCAP__Customer_Approval__c '+ CApproval);
                if (CApproval.order_date__c!=NULL)
                    orderdateCA = DateTime.newInstance(CApproval.order_date__c.year(),CApproval.order_date__c.month(),CApproval.order_date__c.day()).format('dd.MM.YYYY');
                    keyCA=CApproval.CSCAP__Key__c;
                System.debug('***shubh order date'+ orderdateCA );
                if(opp!=Null)
                {
                    
                    contactList = [select email,salutation,firstname,lastname from contact where id =:opp.LG_PrimaryContact__c limit 1];
                    if(!contactList.isEmpty())
                       {
                           if(contactList[0].salutation=='Mr.')
                               salutationContact = 'Herr';
                           else if(contactList[0].salutation=='Ms.')
                               salutationContact = 'Frau';
                           else  
                               salutationContact =contactList[0].salutation;
                           surnameContact = contactList[0].lastname;
                       }
                    userList = [select firstname, lastname, Fax,Phone,MobilePhone,CompanyName,email from user where id =: opp.ownerid limit 1];
                    if(!userList.isEmpty())
                       {
                           firstNameOppOwner=userList[0].firstname;
                           surnameOppOwner=userList[0].lastname;
                           faxNumberOppOwner=userList[0].Fax;
                           telephoneOppOwner=userList[0].Phone;
                           mobNumberOppOwner=userList[0].MobilePhone;
                           emailOppOwner=userList[0].email;
                           company = userList[0].CompanyName;
                           
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
                           }
                       }
                }
            }
            System.debug('***Details'+oppId+'***'+address+'***'+firstNameOppOwner+'****'+orderdateCA );
            return productConfigurationList;
        }
         catch(exception ex)
        {
            System.debug('An exception occurred: ' + ex.getMessage());
            System.debug('***Stack Trace: ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please contact system admin ' + ex.getMessage()));
            return null;
        }
    }
}