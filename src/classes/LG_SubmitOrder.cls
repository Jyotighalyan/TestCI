/************************************************************
* File Name     :  LG_SubmitOrder
* Description   :  This class is used to submit order

* @author       : 
* Modification Log
=============================================================
* Ver.    Date          Author              Modification
-------------------------------------------------------------
* 1.0     12/12/2016    Alisha       File Created.
* 1.1     23/01/2016    Ganesh       Code refactoring
* 1.2     02/03/2016    Alisha       Code refactoring
*************************************************************/

public class LG_SubmitOrder{ 
   

    // Variable declaration section
    public Id OppId{get;set;}
    public Id accId {get;set;}
    public String OppName{get;set;}
    public Id basketId{get;set;}
    public ID WayLeaveDocID{get;set;}
    public ID PortingDocID{get;set;}
    public ID ContractDocID{get;set;}
    public ID DDMandateDocID{get;set;}
    public ID numPortingDocID{get;set;}
    
    public Opportunity  OppObj {get;set;}
    public List<cscfga__Product_Configuration__c> productItemList {get;set;}
    public Account accountObj{get; set;}
    public CSCAP__Customer_Approval__c  ca {get; set;}
    
    public Integer totalDD {get;set;}
    public Integer totalBillingAccounts {get;set;}
    
    Public Integer  bookedOpp ;
    
    public string fileName{get;set;}
    public Blob fileBody{get;set;}
    
    public String WayLeaveDocName {get; set;}
    public String PortingDocName {get; set;}
    public String ContractDocName {get; set;}
    public String DDMandateDocName {get; set;}
    public String numPortingDocName {get; set;}
    public boolean DDMandateMandatory {get;set;}
    public String paymentType{get; set;}
    
    public String errorMessage {get; set;}
    
    //checkbox
    public boolean DDMandateChecked  {get;set;}
    public boolean SignedContractChecked  {get;set;}
    public boolean LLAuthChecked  {get;set;}
    public boolean PortAuthChecked  {get;set;}
    public boolean numPortingChecked  {get;set;}
    //Removed as a part of OMB-664
    //public boolean dcChecked{get;set;}
    //public boolean ccChecked{get;set;}
    //public boolean contractChecked{get;set;}


    public boolean viewUploadDocumentOption {get; set;}
    
    public boolean DDmandateDocPresent {get;set;}
    public boolean ContractDocPresent {get;set;}
    public boolean PortingDocPresent {get;set;}  
    public boolean numPortingDocPresent {get;set;}  
    public boolean WayLeaveDocPresent {get;set;}
    
    public boolean oppTermsNcondition {get;set;}
    public boolean orderSummaryEnabled {get;set;}
    public boolean submittedOpp {get;set;}
    
    public boolean PortingMandatory {get;set;}
    public boolean contractMandatory {get;set;}
    public boolean LandlordAuthMandatory {get;set;}
    public boolean debtCheckMandatory {get;set;}
    
    //Flags
    public String debitCheckFlag {get; set;}
    public String creditCheckFlag {get; set;}
    public String quoteFlag {get;set;} 
    public String contStatusFlag {get; set;}
    public String SCStatusFlag {get; set;}
    public String oppQuoteStatusFlag {get;set;} // Added for SFOM-1308
    
    //Status Fields
    public String creditCheckStatus {get; set;}
    public String contStatus {get; set;}
    public String quoteStatus {get; set;}
    public String SCStatus {get; set;}
    public String oppQuoteStatus {get; set;} // Added for SFOM-1308

    // Arrow Flags
    public String debitCheckArrowFlag{get; set;}
    public String creditCheckArrowFlag{get; set;}
    public String contractPAckArrowFlag{get; set;}
    public String SCArrowFlag{get; set;}
    
    //Info Labl
    public String debtCheckInfo {get; set;}
    //sfom-697
    public String SCCheckInfo {get; set;}
    
    public list<case> SCcaselist {get;set;}
    public String OrgaName{get; set;}
    
     //sfom-1123
    public String techContactDetails{get;set;}
    
    /*commented as part of DGT-345
    //SFOM-2503
    public boolean isBDSOpp = false; */
    
    //sfom-1123
 public void getTechnicalContact(){
       Opportunity op  = [select id,name from opportunity where id=:oppId];
      
      List<cscfga__Product_Configuration__c> prodConf = [SELECT Id, LG_Address__r.LG_TechnicalContact__c,LG_BillingAccount__c, LG_Address__r.LG_TechnicalContact__r.Name FROM cscfga__Product_Configuration__c 
      WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c =:op.id AND 
      cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = true LIMIT 1];
      if(prodConf.size()>0){
          if(prodConf[0].LG_Address__r != null && prodConf[0].LG_Address__r.LG_TechnicalContact__c!= null){
              techContactDetails= prodConf[0].LG_Address__r.LG_TechnicalContact__r.Name;
              system.debug(techContactDetails+'Tech contact');
          }
      
      }
        system.debug(techContactDetails+'Tech contact 1');
  }
    
    //added as part of sfom-81
    
    public static LG_ValidateOpportunity__c val = LG_ValidateOpportunity__c.getInstance(UserInfo.getUserId());
    public static LG_ValidateOpportunityUtil validatorClass=null;
      public static string OrgName=null;
    
    public static string getClass_name(){
    system.debug(LoggingLevel.ERROR,'initial queries');
        if(val!=null &&val.Class_Name__C!=null){
            Type appropriateClass = Type.forName(val.Class_Name__C);
            validatorClass= (LG_ValidateOpportunityUtil) appropriateClass.newInstance();
            system.debug(LoggingLevel.ERROR,'initial queries'+Limits.getQueries());
            system.debug('validator=='+validatorClass);
        }
        
        return null;
    }
    public static string getOrg_name(){     
          
          if(val!=null && val.Org_Name__c!=null){
          OrgName= val.Org_Name__c;          
          }
            
        return OrgName;
    }
    
     /*public LG_SubmitOrder() {
     System.debug('querrrrryyyyyy>>>>' +Limits.getQueries());
    //OppId = controller.getRecord().id;
    oppID=ApexPages.currentPage().getParameters().get('id');

          OrgaName=LG_SubmitOrder.getOrg_name();
        creditCheckFlag ='Red_Flag.png';
        creditCheckStatus='Invalid';
        
        submittedOpp = false;
              
        
        debtCheckInfo  = 'this is just test message.\nwe will add dynamic messages once this functionality if fully developed.';
        SCCheckInfo ='Please ensure all Serviceability Case are Closed and Site Category should not be 4 to submit Order.';
 
        if(oppId != null )
        {
            OppObj = [SELECT Id, Name,Payplan_Declaration__c,Payplan_Approval_Status__c,stageName,LG_StandaloneFraudCheckStatus__c,Account.Name,Account.ID,LG_Order_Summary_Accepted__c,Planning_Detail_Status__c,LG_DebitCheckStatus__c,Opportunity_ID__c,LG_Credit_Check_Condition__c FROM Opportunity WHERE Id = :OppId];
            if(OppObj!=null )
            {
                accId = OppObj.Account.ID;
                accountObj=[select id,name,Type from account where id=:accid];
                List<cscfga__Product_Basket__c> productBasketId = [select id,spt_quote_status__c from cscfga__Product_Basket__c where csordtelcoa__Synchronised_with_Opportunity__c = TRUE and  cscfga__Opportunity__c =:oppId];
                if(!productbasketid.isEmpty())
                {
                    basketId= productBasketId[0].id;
                }        
                bookedOpp =[select count() from Contract__c where Opportunity__c =:oppId];
                if(bookedOpp > 0) 
                {
                    submittedOpp = true;
                    orderSummaryEnabled =false;
                }
                LG_BillingAccount lgBillingAccount = new LG_BillingAccount(OppId);
                totalBillingAccounts = lgBillingAccount.totalBillingAccount(OppId,null);
                totalDD = lgBillingAccount.countDD();
                
                debitCheckFlag=debitCheckStatusFlag();
                if(debitCheckFlag=='Green_Flag.png')
                {
                    creditCheckFlag =Creditcheckflag();      
                }
            } 
            OppName = OppObj.Name;
            
        }
     
         debtCheckAction();
        creditCheckAction();
        debitCheckStatusFlag();
        creditCheckFlag();
        getQuoteStatus();
        contractStatus();
        mandatoryDocsCheck();
        getsccases();

           
    }*/

    public LG_SubmitOrder(ApexPages.StandardController controller)
    {
    System.debug('querrrrryyyyyy111>>>>' +Limits.getQueries());
        OppId = controller.getRecord().id;
          OrgaName=LG_SubmitOrder.getOrg_name();
        creditCheckFlag ='Red_Flag.png';
        creditCheckStatus='Invalid';
        
        submittedOpp = false;
       
           
        
        debtCheckInfo  = 'this is just test message.\nwe will add dynamic messages once this functionality if fully developed.';
        SCCheckInfo ='Please ensure all Serviceability Case are Closed and Site Category should not be 4 to submit Order.';
 
        if(oppId != null )
        {
            OppObj = [SELECT Id, Name,Payplan_Declaration__c,Payplan_Approval_Status__c,stageName,LG_StandaloneFraudCheckStatus__c,Account.Name,Account.ID,LG_Order_Summary_Accepted__c,Planning_Detail_Status__c,LG_DebitCheckStatus__c,Opportunity_ID__c,LG_Credit_Check_Condition__c, csordtelcoa__Change_Type__c FROM Opportunity WHERE Id = :OppId];
            if(OppObj!=null )
            {
                accId = OppObj.Account.ID;
                accountObj=[select id,name,Type,LG_ChamberOfCommerceNumber__c from account where id=:accid];
                List<cscfga__Product_Basket__c> productBasketId = [select id,spt_quote_status__c from cscfga__Product_Basket__c where csordtelcoa__Synchronised_with_Opportunity__c = TRUE and  cscfga__Opportunity__c =:oppId];
                if(!productbasketid.isEmpty())
                {
                    basketId= productBasketId[0].id;
                }        
                bookedOpp =[select count() from Contract__c where Opportunity__c =:oppId];
                if(bookedOpp > 0) 
                {
                    submittedOpp = true;
                    orderSummaryEnabled =false;
                }
                LG_BillingAccount lgBillingAccount = new LG_BillingAccount(OppId);
                totalBillingAccounts = lgBillingAccount.totalBillingAccount(OppId,null);
                totalDD = lgBillingAccount.countDD();
                
                debitCheckFlag=debitCheckStatusFlag();
                if(debitCheckFlag=='Green_Flag.png')
                {
                    creditCheckFlag =Creditcheckflag();      
                }
            } 
            OppName = OppObj.Name;
           /* Commented as part of DGT-345
           //SFOM-2503 -- Start 
           for(cscfga__Product_Configuration__c pc : [SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c = :oppId and cscfga__Product_Family__c like '%BDS%'])
           {
               isBDSOpp = true;
               System.debug('isBDS#' + isBDSOpp);
               break;
           }
           //SFOM-2503 -- End
		   */
        }
        debtCheckAction();
        creditCheckAction();
          //sfom-1123
        getTechnicalContact();
        debitCheckStatusFlag();
        creditCheckFlag();
        getQuoteStatus();
        getOppQuoteStatus(); //SFOM 1308
        contractStatus();
        mandatoryDocsCheck();
        getsccases();
        System.debug('querrrrryyyyyy111>>>>' +Limits.getQueries());
        system.debug('debitCheckFlag=='+debitCheckFlag+'==creditCheckFlag=='+creditCheckFlag+'==quoteFlag=='+quoteFlag+'contractStatus=='+contStatus);
    }
    
    //Method blocked as a part of SFOM-2069 - point 3.
    //Method to navigate to Account
    /*Public PageReference gotoAccount()
    {
        PageReference pageRef = null;
        pageRef = new PageReference('/'+accid);
        return pageRef;
    }*/
    
    //Method to navigate to Debt check page on click of Debt check flag    
    Public PageReference debtCheckAction()
    {
        PageReference pageRef = null;
        pageRef = new PageReference('/apex/LG_DebitCheck?oppId='+oppId);
        return pageRef;
    }
    
    //Method to navigate to Credit Check page on click of Credit Check flag
    Public PageReference creditCheckAction()
    {
        PageReference pageRef = null;
        pageRef = new PageReference('/apex/LG_CreditCheck?oppId='+oppId);
        return pageRef;
    }
    
    //Method to navigate to Product basket for Quote status flag    
    Public PageReference gotoBasket()
    {
        PageReference p = Page.csbb__BasketBuilderApp;
        p.getParameters().put('Id', basketId);
        return p;
    }
    
    //Method to navigate to Contract pack for Contract Status flag    
    public pagereference sendContract()
    {
        PageReference pageRef = null;
        pageRef = new PageReference('/apex/PMSDB?Id='+oppid);
        return pageRef;
    }
    
    //Method blocked as a part of SFOM-2069 - point 3.
    //Method to navigate to Opportunity    
    /*Public PageReference backToOpportunity()
    {
        return new PageReference('/'+oppid);
    }*/
    
    
    //Method to naviage to Opportunity to click of Validate Order Button     
    Public PageReference validateOrder()
    {
        PageReference pr = new PageReference('/apex/LG_SubmitOrder?id='+oppObj);
        return pr;
    }    
    
    //Method to check debtcheck flag    
    Public String debitCheckStatusFlag()
    {
        String tmpdebitCheckFlag;//='Yellow_Flag.png';
        if(string.isblank(oppobj.LG_DebitCheckStatus__c))
        {
            tmpdebitCheckFlag='Red_Flag.png';
        }
        if(OppObj.LG_DebitCheckStatus__c=='Not Completed')
        {
            tmpdebitCheckFlag='Red_Flag.png';
        }
        if(OppObj.LG_DebitCheckStatus__c=='Pending')
        {
            tmpdebitCheckFlag='Yellow_Flag.png';
        }
        if(OppObj.LG_DebitCheckStatus__c=='Completed')
        {
            List<LG_CustomerAccountBalance__c>  customerABList =[SELECT Id, LG_Account__c,createdDate, LG_Opportunity__c, LG_TotalDebtBalance__c, LG_TotalPayableDebt__c, LG_TotalCurrentBillingCharges__c, LG_TotalDepositAmount__c,LG_DebitStatus__c FROM LG_CustomerAccountBalance__c where LG_Account__c=:accountObj.id and LG_Opportunity__c=:OppId  order by createddate desc limit 1] ;
            LG_DebtCredit_Check__c dcCheckObj=LG_DebtCredit_Check__c.getInstance();
            tmpdebitCheckFlag='Green_Flag.png';
            if(customerABList.isEmpty())
            {
                tmpdebitCheckFlag='Red_Flag.png';
            }
            else if(!customerABList.isEmpty())
            {
                LG_CustomerAccountBalance__c cab=customerABList.get(0);
                Datetime dt=cab.createdDate;
                date dcCreatedDate=date.newinstance(dT.year(), dT.month(), dT.day()); 
                Integer CbValiddays =Integer.valueOf(dcCheckObj.LG_Customer_Balance_Validity__c);
                if(CbValiddays !=null)
                {   
                    Boolean isCaseClosed=true;
                    List<case> lcase =  [Select ID,Status from Case  where LG_Opportunity__c=: oppId and LG_CustomerAccountBalance__c=:cab.id and RecordType.Name = 'Collections Team' ];//LG_CustomerAccountBalance__c
                    if(lcase !=null && lcase.size()>0)
                    {
                        if(lcase.get(0).status!='Completed')
                        { //pending case
                            isCaseClosed= false;
                            tmpdebitCheckFlag='Yellow_Flag.png';
                        }
                    }
                    if(dcCreatedDate.addDays(CbValiddays) < Date.today() && isCaseClosed)
                    {
                        tmpdebitCheckFlag='Yellow_Flag.png';
                    }  
                } 
            }
        }
        return tmpdebitCheckFlag;
    }
    
   
    /******* Methods for Credit check flag */////////////
    Public String Creditcheckflag()
    {
        list<LG_Credit_Check_Opportunity__c> creditcheckopty = [select LG_Credit_check__c,LG_Opportunity__c from LG_Credit_Check_Opportunity__c where LG_Opportunity__c =:oppId];
        
        if(creditcheckopty!=null && creditcheckopty.size()>0)
        {
            list<LG_Credit_Check__c > credtcheck=  [select Id, LG_Opportunity__c, LG_Total_Exposure_Value__c, LG_Credit_Limit__c,
                                                    LG_ApplicationDate__c, LG_applicationExpiryDate__c, LG_CreditCheck_ExecutionDate__c, LG_Payment_Type__c 
                                                    from LG_Credit_Check__c where id =:creditcheckopty[0].LG_Credit_check__c limit 1 ]; 
            system.debug('credtcheck--'+credtcheck);
            if(credtcheck.size()==0 && credtcheck==null)
            {
                creditCheckFlag ='Red_Flag.png';
                creditcheckStatus='Invalid';
            }
            if(credtcheck.size()>0 && credtcheck!=null)
            {
                //  date d30 = credtcheck[0].LG_applicationExpiryDate__c.addDays(30);
                date d90= credtcheck[0].LG_ApplicationDate__c.addDays(Integer.valueof(Label.LG_Credit_Check_Expiry_Date));
                
                if(credtcheck[0].LG_Total_Exposure_Value__c <= credtcheck[0].LG_Credit_Limit__c)
                {
                    creditCheckFlag ='Green_Flag.png';
                    creditcheckStatus='Completed';
                }
                
                if(system.today()>d90)
                {
                    creditCheckFlag ='Yellow_Flag.png';
                    creditcheckStatus='Expired';
                    system.debug('Credit check has expired');       
                }
            }
        } 
        return  creditCheckFlag ; 
    }
    
    //Method to check Quote status flag
    public String getQuoteStatus()
    {
        //List<cscfga__Product_Basket__c> productBasketId = [select id,spt_quote_status__c,Quote_Stage__c,Account_Lapse_Date__c,    // //Quote_Expiry_Date__c from cscfga__Product_Basket__c where csordtelcoa__Synchronised_with_Opportunity__c = TRUE and  cscfga__Opportunity__c =:oppId];
                    quoteFlag='Green_Flag.png';

        
          getclass_name();
             
        // added as part of sfom-669 validations
        LG_Submit_Order_Validations_On_Off__c  submittingUser = LG_Submit_Order_Validations_On_Off__c.getInstance(UserInfo.getUserId());

        
        List<cscfga__Product_Basket__c> productBasketId = [select id,spt_quote_status__c,Quote_Stage__c,Account_Lapse_Date__c,     Quote_Expiry_Date__c from cscfga__Product_Basket__c where  cscfga__Opportunity__c =:oppId];
        system.debug('productBasketId=='+productBasketId);
        for(cscfga__Product_Basket__c obj1:productBasketId )
        {
            quoteFlag='Red_Flag.png';
            if(system.today()>obj1.Quote_Expiry_Date__c)
            {
                quoteFlag='Red_Flag.png';
                quoteStatus='Expired';
            }
            else
            {
            quoteStatus='Active';
            quoteFlag='Green_Flag.png';

        
            }
        }            
        
        system.debug(' quoteStatus--------'+quoteStatus);
        return quoteStatus;
    }
    
    //Method to check Contract Status Flag
    public PageReference contractStatus()
    {
        contStatus='Pending';
        contStatusFlag='Yellow_Flag.png';
        List<CSCAP__Customer_Approval__c> ca= [select id,CSCAP__Approved_By_Customer__c,CSCAP__Rejected_By_Customer__c from CSCAP__Customer_Approval__c where CSCAP__Opportunity__c =:OppObj.ID order by createddate desc ];
        if(ca.size()>0)
        {
            //OMB-1134 - Signed contract is always mandatory.
            contractMandatory=true;
            if(ca[0].CSCAP__Approved_By_Customer__c==true)
            {
                contStatus='Approved';
                contStatusFlag='Green_Flag.png';
            }
            else
            /*{
                contStatus='Rejected';
                contStatusFlag='Red_Flag.png';
                
            }*/
            if(ca[0].CSCAP__Rejected_By_Customer__c==true)
            {
                contStatus='Rejected';
                contStatusFlag='Red_Flag.png';
            }
            //return null;
        }
        else
        {
            List<attachment> attList=[SELECT id,name  from Attachment where parentid =:OppId ];
            DDmandateDocPresent=false;
            ContractDocPresent=false;
            PortingDocPresent=false;
            WayLeaveDocPresent=false;
            contractMandatory=true;
            if(attList.size()>0)
            {
                system.debug('attList=='+attList);         
                for(Attachment att:attList)
                { 
                    if(att.name.containsIgnoreCase('Order')|| att.name.containsIgnoreCase('Contract'))
                    {
                        ContractDocPresent=true;
                        ContractDocID=att.id;
                        ContractDocName=att.name;
                        contStatus='Approved';
                        contStatusFlag='Green_Flag.png';
                        system.debug('ContractDocPresen=='+ContractDocPresent);
                    }
                }
                //return null;
            }
            //else
            //{   
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can not validate an order without a signed contract'  ));
            // return null;
            //    return new PageReference('/'+oppid);
            //}
        }
        
        //SFOM-2069
        if(OppObj.csordtelcoa__Change_Type__c == 'Move'){
            contractMandatory = false;
            contStatus='Pending';
            contStatusFlag='Yellow_Flag.png';
        }
        
        return null;
    }
    
    
    //Added for sfom-697
    public PageReference  getsccases(){
    
    getclass_name();
       SCcaselist=validatorClass.getSCCase(oppId);
       
    return null;
    
    }
    
    // Added for SFOM-1308
    public String getOppQuoteStatus(){
        
        Profile prof =[SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        
        Opportunity oppo = [SELECT id,Name,Probability,csordtelcoa__Change_Type__c,UM_PartnerAccount__c,StageName,Lg_Sales_Channel__c FROM Opportunity WHERE id = :oppId];
        system.debug('1111111111oppo'+ oppo);
        
         if(prof.Name.equalsIgnoreCase('UM_CSR_Profile') && (oppo.Lg_Sales_Channel__c!='D2D'|| oppo.Lg_Sales_Channel__c!='Partner')){
            OppQuoteStatus='N/A';
            return OppQuoteStatus;
            }
            
        else if(oppo.csordtelcoa__Change_Type__c!='Terminate')
        {
        if(oppo.StageName=='Quotation Delivered' || (oppo.UM_PartnerAccount__c != Null && oppo.StageName != 'Customer Approved')){
     //       oppQuoteStatus='InActive';
            
            oppQuoteStatusFlag='Red_Flag.png';
        }
        
        else if(oppo.Probability>=80)
        {
                 //   OppQuoteStatus='Active';
            oppQuoteStatusFlag='Green_Flag.png';
        }
        }
        else if(oppo.csordtelcoa__Change_Type__c=='Terminate'){
        OppQuoteStatus='N/A';
        return OppQuoteStatus;
        }
        return oppQuoteStatusFlag; 
        
    } //End of code for SFOM-1308
    
    //Method for submit order button
    Public PageReference submitOrder()
    {
        System.debug('Limit queryy>>>>' +Limits.getQueries());
        string error1, error2,error3,error4,error5;
        system.debug('DDMandateChecked  && SignedContractChecked  &&  LLAuthChecked  &&  PortAuthChecked  '+  DDMandateChecked  + SignedContractChecked  +  LLAuthChecked  +  PortAuthChecked  );
        system.debug('all conditions met=='+(debitCheckFlag.contains('Green') && creditCheckFlag.contains('Green') && quoteFlag.contains('Green')));
/* SFOM-1101 chages to pick final status from Custom settings*/
        csordtelcoa__Orders_Subscriptions_Options__c cs=csordtelcoa__Orders_Subscriptions_Options__c.getInstance();
     /*   if(OppObj.stageName==cs.csordtelcoa__Opportunity_Stages_creating_orders__c)
        if(OppObj.stageName=='Order Generated')
        {
            errorMessage = System.Label.LG_ErrorOrderAlreadyGenerated;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));  
            return null;
               }
            
            */      /*sfom-990 bug fix
        if(OppObj.stageName=='Closed Lost')
        {
            errorMessage = System.Label.LG_ErrorOpportunityLost;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));  
            return null;
        }   */
        
        // added as part of sfom-697 refactoring of validations
       if(OrgaName.contains('VMB') || OrgaName.contains('Q35')){
       integer sccount;
       integer sccategory;
       getclass_name();
       sccount=validatorClass.servicecasecheck(oppId);
       sccategory=validatorClass.SCCategorycheck(oppId);
       if(sccount>0 || sccategory>0){ 
       ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Order cannot be submitted because there are still open cases for Serviceability / got Category 4 in Site.'));  
            return null;
            }            
        }
        
     
        
     
        // added as part of sfom-669 validations
        LG_Submit_Order_Validations_On_Off__c  submittingUser = LG_Submit_Order_Validations_On_Off__c.getInstance(UserInfo.getUserId());
          
        if(debitCheckFlag.contains('Red'))
        {
            error1=System.Label.LG_ErrorInvalidDebtCheck;
        }
        if(creditCheckFlag.contains('Red'))
        {
            error2=System.Label.LG_ErrorInvalidCreditCheck;
        }
        if(quoteFlag.contains('Red'))
        {
            error3=System.Label.LG_ErrorQuoteStatusExpired;
        }  
        if(contStatusFlag .contains('Red'))
        {
            error4=System.Label.LG_ErrorInvalidContractStatus;
        } 
        //as part of sfom-669
        if(!submittingUser.Flag__c){
        if(contStatusFlag.contains('Green') && debitCheckFlag.contains('Green') && creditCheckFlag.contains('Green') && quoteFlag.contains('Green') )

        {
          system.debug('all green flags');
        }
         else
        {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LG_Validation_Error));        
            return null;      
        }
        }
       if(submittingUser.Flag__c){
            //Removed as a part of OMB-664
           /*if(!dcChecked || !contractChecked || !ccChecked ){
             errorMessage = System.Label.LG_ErrorDebitCreditCheckbox;
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));        
            return null; 
            }*/
           //End - OMB-664
            /*if(!(ccChecked)){
             errorMessage = System.Label.LG_ErrorCreditCheckbox;
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));        
            return null; 
            }
             if(!contractChecked){
             errorMessage = System.Label.LG_ErrorContractCheckbox;
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));        
            return null; 
            }*/
            /* -- //Removed as a part of SFOM-1722
            if(accountObj.LG_ChamberOfCommerceNumber__c==null){
             errorMessage ='Please add National ID number in Account' ;//System.Label.LG_ErrorContractCheckbox;
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));        
            return null; 
            }
     
          else if(PaymentType=='Fail'){ */
          
          
            if(PaymentType=='Fail'){
            errorMessage = System.Label.LG_ErrorDDMandatoryStatus;
          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
          return null; 
            }
        
        }
            
        //OMB-1134 - Validation to check the file upload should be removed, as CSR will take care of it manually.    
        /*if(LandlordAuthMandatory==true && WayleaveDocName==null )
            {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LG_LL_Auth_Doc_Error));        
            }
            else
            {
                if(PortingMandatory==true && PortingDocName==null)
                {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LG_Port_Authorisation_Doc_Error));        
                }  
                else
                {
                    if(contractMandatory==true &&  ContractDocName==null)
                    {
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LG_Signed_Contract_Doc_Error));        
                    }
                    else
                    { */      
                       if((LandlordAuthMandatory==true && LLAuthChecked==false) || (DDMandateChecked==false  && OrgName=='UM') || (PortingMandatory==true &&PortAuthChecked==false) || (contractMandatory==true && SignedContractChecked==false))
                       {
                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check all the mandatory documents'));        
                       }
                       // Added for SFOM-1308
                       
                           else if(OppQuoteStatus!='N/A' && oppQuoteStatusFlag.contains('Red'))
                            {
                             
                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LG_QuoteStatusFlag));        
                            return null;
                            } 
                      //End of code for SFOM-1308
                        else                        {
                            if(oppTermsNcondition==false && OrgName!='UM')
                            {
                                system.debug('oppTermsNcondition=='+oppTermsNcondition);
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LG_Opportunity_Terms_and_Condition));        
                            }  
                            else
                            {
                                String errorMsg='';
                                // added as part of sfom-81 refactoring of validations
                                getclass_name();
                                Boolean isValid = validatorClass.ValidateOpportunityUtil(oppObj);
                                if(isValid){
                                     try
                                    {
                                        
                                        system.debug('submit order--errorMsg is null--');
                                       /* SFOM-1101 - commented below call to get custom settings as already made above*/ 
                                     // csordtelcoa__Orders_Subscriptions_Options__c cs=csordtelcoa__Orders_Subscriptions_Options__c.getInstance();
                                        OppObj.stageName=cs.csordtelcoa__Opportunity_Stages_creating_orders__c;
                                        OppObj.LG_Opp_Stage_Check__c = false;
                                        OppObj.Payplan_Declaration__c=true;
                                        /**added to create booked oppty as part of SFOM-81*/
                                        /*Commented as part of DGT-345
                                        //SFOM-2503 -- Start
                                        if(isBDSOpp)
                                            OppObj.LG_SuppressOrderConfirmation__c = true;
                                        else
                                            OppObj.LG_SuppressOrderConfirmation__c = false;
										//SFOM-2503 -- End
                                        */
                                        OppObj.Payplan_Approval_Status__c='Booked';
                                        System.debug('Limit query1>>>>' +Limits.getQueries());
                                        system.debug('--OppObj ----'+oppObj+'  OppObj.stageName-----'+ OppObj.stageName);
                                        update oppObj;
                                        system.debug('--OppObj ----'+oppObj+'  OppObj.stageName-----'+ OppObj.stageName);
                                        /*SFOM-374*/
                                        suborderRemapping(oppId);
                                        /*SFOM-374*/
                                    }
                                    catch(DmlException e)
                                    {
                                        System.debug('The following exception has occurred: ' + e.getMessage());
                                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));        
                                        return null;
                                    }
                                    return new PageReference('/'+oppid);
                                
                             }
                                else{
                                    return null;
                                }
                            }
                          //  }
                        }
                    //}
                //}
            //}
        
        
        return null;
        
    }
    
    
    //Method to check Mandatory documents 
    Public PageReference mandatoryDocsCheck()
    {
        getclass_name();
  
        // added as part of sfom-669 validations
        LG_Submit_Order_Validations_On_Off__c  submittingUser = LG_Submit_Order_Validations_On_Off__c.getInstance(UserInfo.getUserId());
        
        // 
        List<cscfga__Product_Configuration__c> prodConfList = new  List<cscfga__Product_Configuration__c>();
        prodConfList =[SELECT Id, LG_Address__r.LG_TechnicalContact__c,LG_BillingAccount__c,LG_Billing_Account__c, LG_Address__r.LG_TechnicalContact__r.Name FROM cscfga__Product_Configuration__c 
                          WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c =:oppid];
        set<id> billingAcctId=new set<id>();
        for(cscfga__Product_Configuration__c pc: prodConfList )
        {
            billingAcctId.add(pc.LG_Billing_Account__c);
        
        }   
        system.debug('**billingAcctId'+billingAcctId);             
        if(submittingUser.Flag__c){ 
        paymentType=validatorClass.DDmandateCheck(oppObj);
        }
        //  Quantum_Site_Information__c wayLeaveReq=[Select id,WayLeave_Required_for_Landlord__c from Quantum_Site_Information__c where      Quantum_Site_Information_Opportunity__c=:OppId and Product_Basket__c =:basketId and Is_Inactive__c=false];
        List<Quantum_Site_Information__c> quantumList = [Select id,WayLeave_Required_for_Landlord__c,WayLeave_Required_for_Tenant__c from Quantum_Site_Information__c where Quantum_Site_Information_Opportunity__c=:OppId and Is_Inactive__c=false];
        if(!quantumList.isEmpty())
        {
            Quantum_Site_Information__c wayLeaveReq= quantumList[0];
            LandlordAuthMandatory=(wayLeaveReq.WayLeave_Required_for_Landlord__c || wayLeaveReq.WayLeave_Required_for_Tenant__c);
        }
        
        if((OrgName.contains('VMB') || OrgName.contains('Q35')) && productItemList!=null && productItemList.size()>0)
        {
            boolean overAllPlanningDetailFlag = false;
            for(cscfga__Product_Configuration__c obj:productItemList)
            {
                String paymentFlag='Red_Flag.png';
                if(obj.LG_PortIn__c=true)
                {
                    PortingMandatory=true;
                }
            }
        }
        else if(OrgName =='UM')
        {
        //sfom-1123
            PortingMandatory=false;
        }
        
        system.debug('DDMandateMandatory=='+DDMandateMandatory+' LandlordAuthMandatory=='+LandlordAuthMandatory +'PortingMandatory=='+PortingMandatory);
        
        List<attachment> attList=[SELECT id,name, Description  from Attachment where parentid =:OppId ];
        DDmandateDocPresent=false;
        ContractDocPresent=false;
        PortingDocPresent=false;
        WayLeaveDocPresent=false;
        
        if(attList.size()>0)
        {
            system.debug('attList=='+attList);         
            for(Attachment att:attList){
                //OMB-1134 - Keywords for file uploading to be removed.
                if(att.Description != null){
                    if(att.Description.containsIgnoreCase('mandate'))
                {   
                    DDmandateDocPresent=true;
                    DDmandateDocID=att.id;
                    DDMandateDocName=att.name;
                    system.debug('DDmandateDocPresen=='+DDmandateDocPresent);
                } 
                    if(att.Description.containsIgnoreCase('Wayleave'))
                {
                    WayLeaveDocPresent=true;
                    WayLeaveDocID=att.id;
                    WayleaveDocName=att.name;
                    system.debug('DDmandateDocPresen=='+DDmandateDocPresent);
                } 
                   if(att.Description.containsIgnoreCase('Porting'))
                {
                    PortingDocPresent=true;
                    PortingDocID=att.id;
                    PortingDocName=att.name;
                    system.debug('PortingDocPresent=='+PortingDocPresent);
                } 
                   if(att.Description.containsIgnoreCase('Contract'))
                {
                    ContractDocPresent=true;
                    ContractDocID=att.id;
                    ContractDocName=att.name;
                    system.debug('ContractDocPresen=='+ContractDocPresent);
                }
            }
        }
        }
        return null;
    }
    
    //SFOM-1134 - Categorizing the document by Attachment Description
    public PageReference UploadContractFile(){
        return UploadFile('Contract');
    }
    
    public PageReference UploadPortingFile(){
        return UploadFile('Porting');
    }
    
    public PageReference UploadWayleaveFile(){
        return UploadFile('Wayleave');
    }
    
    //Method to upload file/attachments    
    //OMB-1134 - Input parameter added
    public PageReference UploadFile(String FileCategory)
    {
        PageReference pr;
        if(fileBody != null && fileName != null)
        {
            Attachment myAttachment  = new Attachment();
            myAttachment.Body = fileBody;
            myAttachment.Name = fileName;
            myAttachment.ParentId = oppObJ.id;
            myAttachment.Description = FileCategory;
            insert myAttachment;
            // pr = new PageReference('/' + myAttachment.Id);
            system.debug('--attach'+myAttachment.name);
            pr = new PageReference('/apex/LG_submitOrder?id='+OppId);
            
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }    
    
   
    
    /*
    * Remapping Logic
    * @author Ankur Gupta
    * @ticket SFOM-374
    * @since  27/03/2017
    */
    public void suborderRemapping(Id oppId)
    {
        Map<Id,Id> newSuborderMap =  new Map<Id,Id>();
        Opportunity opp = [SELECT id,Name,LG_OlderVersion__c FROM Opportunity WHERE id = :oppId];
        
        if(opp!=null && opp.LG_OlderVersion__c !=null)
        {
            List<csord__Order__c> oldOrdersList = [SELECT id,name,LG_NewOrderVersion__c  FROM csord__order__c WHERE csordtelcoa__Opportunity__c = :opp.LG_OlderVersion__c];
            List<csord__Solution__c> oldSuborderList = [SELECT Id,name,LG_ProvisioningWorkOrder__c FROM csord__Solution__c WHERE csord__Order__c IN :oldOrdersList]; 
            List<csord__Solution__c> newSuborderList = [SELECT Id,name,LG_ProvisioningWorkOrder__c,LG_OldSuborder__c FROM csord__Solution__c WHERE csord__Order__c
                                                        IN (SELECT LG_NewOrderVersion__c FROM csord__Order__c WHERE id IN: oldOrdersList)  AND LG_OldSuborder__c <> null];
            List<LG_ScheduleAppointment__c> appointmentList = new List<LG_ScheduleAppointment__c>();
            
            if(!oldSuborderList .isEmpty() && !newSuborderList .isEmpty())
            {
                for(csord__Solution__c newSuborder : newSuborderList){
                    newSuborderMap.put(newSuborder.id, newSuborder.LG_OldSuborder__c);
                }
                appointmentList = [SELECT id, name, LG_solution__c FROM LG_ScheduleAppointment__c WHERE LG_Solution__c IN :oldSuborderList];
                
                for(csord__solution__c oldSuborder: oldSuborderList)
                {
                    for(csord__solution__c newSuborder: newSuborderList)
                    {
                        if(oldSuborder.id == newSuborderMap.get(newSuborder.id)){
                            newSuborder.LG_ProvisioningWorkOrder__c = oldSuborder.LG_ProvisioningWorkOrder__c;
                            
                            if(!appointmentList.isEmpty()){
                                for(LG_ScheduleAppointment__c appointment:  appointmentList){
                                    if(appointment.LG_solution__c == oldSuborder.id){
                                        appointment.LG_solution__c = newSuborder.id;
                                    }   
                                } 
                            }
                        }
                    }
                }
                update newSuborderList;
                update appointmentList;
            }           
        }
    }      
}