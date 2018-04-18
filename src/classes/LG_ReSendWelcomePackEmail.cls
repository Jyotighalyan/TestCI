/* 
* Desc: This class is used as controller of LG_ReSendWelcomePackEmail.  
* Author : Sabeena
* JIRA Issue : SFOM - 2169
*/
public class LG_ReSendWelcomePackEmail {
    
    Public Boolean validationStatus {get;set;}
    Public String errorMessage {get;set;}
    public List<Asset> assetList {get;set;}
    Public Asset ast {get;set;}
    Private csord__Solution__c objSubOrder{get;set;}
    Public String ipAddress;
    Public String macAddress;
    Private csord__Service__c cService;
    Public List<csord__Service__c> cService_new;
    Public Boolean kundenService {get;set;}
    Public Boolean hidefn {get;set;}//added for SFOM-2428
    Public Boolean enableSendEmail {get;set;}//SFOM-2428
    Private String profileName;
    Public Boolean disablesendEmail{get;set;}
    Public String solId{get;set;} 
    Public Boolean serviceAvailable;
    
    /**
    * Desc: Constructor to initialize validationStatus variable and Asset object instance
    **/
    public LG_ReSendWelcomePackEmail(){
        solId = Apexpages.currentpage().getparameters().get('id');
        kundenService = false;
        hidefn=true;//added for SFOM-2428
        assetList = new List<Asset>();
        cService_new= new List<csord__Service__c>();
        ast = new Asset();
        ipAddress = '';
        macAddress = '';
        serviceAvailable = false;
        disablesendEmail=false;
        system.debug('solId--------' + solId);
        objSubOrder = [SELECT Id,csord__Order__r.Name, LG_Termination__c, csord__Status__c,LG_ReSendEmailCheck__c, LG_Suppress_Welcome_Pack__c,
                          csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c 
                          FROM csord__Solution__c 
                          WHERE Id = :solId];
        //instance of the service to store the values
        cService = new  csord__Service__c();   
                      
        //check which field is being used to store Sub-order id on Service. Is it LG_Suborder__c or csord__Service__c                 
        //below for loop will only execute once due to limit in query
        For(csord__Service__c cs:[SELECT Id,Name, csord__Status__c FROM csord__Service__c where csord__Service__c = NULL AND
        LG_Suborder__c = :objSubOrder.id LIMIT 1])
        {
        system.debug('cs--------' + cs);    
            cService = cs;
            serviceAvailable = True;
            if(!cs.Name.containsIgnoreCase('Virtual Voice Kundensetup')){
            system.debug('insideif--------' );    
              assetList = [SELECT Id, LG_MACAddress__c, LG_IPAddress__c, csord__Service__c 
                    FROM Asset 
                    WHERE csord__Service__r.id =: cs.id LIMIT 1];
                system.debug('asset--------' + assetList);
                if(!assetList.isEmpty()){
                    ast = assetList[0];
                    ipAddress = ast.LG_IPAddress__c;
                    macAddress = ast.LG_MACAddress__c;
            }
            }
            else{
                kundenService = true;
            }
        }
        
        cService_new =[SELECT Id,Name, csord__Status__c FROM csord__Service__c where csord__Service__c != NULL AND
                                  LG_Suborder__c = :objSubOrder.id];
        
        
        system.debug(cService);
        //Profile information
        profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        
        //all the validation inside this method and returns boolean variable
        validationStatus = True; //by default True
        errorMessage = ''; //by default blank
        validationStatus = validateScenario();
    }
    
    /**
    * Desc: This method is validate all scenarios. Based on the outcome components would be visible on the page.
    **/    
    Public Boolean validateScenario(){
        //check profile name
        if(!profileName.equalsIgnoreCase('UM_CSR_Profile') && !profileName.containsIgnoreCase('System Administrator')){
            errorMessage =System.Label.LG_resendEmailProfilecheck;
            return false;
        }
        //check for service 
        else if(!serviceAvailable){
            errorMessage = System.Label.LG_resendEmailNoService;
            return false;
        }
        //check for Order status
        else if(!cService.Name.equalsIgnoreCase('Company Internet') && !cService.Name.equalsIgnoreCase('Office Internet') && !cService.Name.equalsIgnoreCase('Virtual Voice Kundensetup')){
            errorMessage = System.Label.LG_resendEmailOrdercheck;
            return false;
        }
        //check for Suppress and Preferred Comm
       /* else if(objSubOrder.LG_Suppress_Welcome_Pack__c == True ){
            errorMessage = System.Label.LG_resendEmailSuppressCheck;
            return false;
        } */
        
      /*  else if(objSubOrder.csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c!= NULL && !objSubOrder.csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c.containsIgnoreCase('Email')){
            
            errorMessage = System.Label.LG_resendEmailSuppressCheck;
            return false;
        }*/
        //check for the Terminated orders
        else if(objSubOrder.LG_Termination__c == True ){
            errorMessage = System.Label.LG_resendEmailTerminatedOrder;
            return false;
        }
        else if(!objSubOrder.csord__Status__c.equalsIgnoreCase('Complete')){
            errorMessage = System.Label.LG_resendEmailcheck;
            return false;
        }
        //check for available assets
        else if(assetList.isEmpty() && !cService.Name.containsIgnoreCase('Virtual Voice Kundensetup')){
            errorMessage = System.Label.LG_resendEmailKundensetup;
            return false;
        }    
        return true;
    }
    /**
    * Desc: SFOM-2428, This method is called from LG_ResendWelcomePackEmail page. This updates the Asset object.
    **/    
    public void SaveAsset()
    {
   
        //Boolean enableSendEmail= true;
        ApexPages.Message myMsg;
        try
        {
            if(!kundenService)
            {
                if(cService_new.isEmpty())
                {
                    if(String.isNotBlank(ast.LG_MACAddress__c))
                    {
                       Update ast;
                       hidefn=false;
                       enableSendEmail=true;
                       myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Details are successfully saved. Please note MAC Address will not be displayed on the Welcome Pack since IP Service is not available' );
                       ApexPages.addMessage(myMsg);
                    }
                    else{
                       myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'MAC Address should not be blank');
                       ApexPages.addMessage(myMsg); 
                    }
                }
                else
                {
                    if(String.isNotBlank(ast.LG_MACAddress__c) && String.isNotBlank(ast.LG_IPAddress__c))
                    {
                    Update ast;
                    hidefn=false;//added for SFOM-2428
                    enableSendEmail=true;
                    myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'IP Address : ' + ast.LG_IPAddress__c + ' and MAC Address : ' + ast.LG_MACAddress__c +' are successfully saved. Please verify the changes and click on Send Email button to Re-Send Welcome Pack.' );
                    ApexPages.addMessage(myMsg);
                 }
                    else
                    {
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LG_resendEmailBlankMAC_IP);
                    ApexPages.addMessage(myMsg);                
                 }
            // }
             /*else{
                 enableSendEmail= true;
             }*/
        }
            }
        else{
            enableSendEmail= false;
        }
        }catch(Exception e){
            System.debug('Error in asset update: ' + e.getMessage());
    }
    }
   
    /**
    * Desc: This method is called from LG_ResendWelcomePackEmail page. This updates the Asset object and Solution details.
    **/    
    public void sendEmail()
    {
        Boolean check = true;
        ApexPages.Message myMsg;
        Try{
            if(!kundenService){
            //Start of SFOM-2428
                if(ast.LG_MACAddress__c != macAddress || ast.LG_IPAddress__c != ipAddress){
                    if(ast.LG_MACAddress__c == '' && ast.LG_MACAddress__c == NULL && ast.LG_IPAddress__c == '' && ast.LG_IPAddress__c == NULL){
                        myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LG_resendEmailBlankMAC_IP);
                        ApexPages.addMessage(myMsg);
                    }
                    else{
                        check = false;
                    }
                }
            }
            //end of SFOM-2428
            if(!check || kundenService){
                objSubOrder.LG_ReSendEmailCheck__c = True;
                update objSubOrder;
                if(objSubOrder.LG_Suppress_Welcome_Pack__c==false && objSubOrder.csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c.containsIgnoreCase('Email')){
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO,System.Label.LG_resendEmailSuccess);
                ApexPages.addMessage(myMsg);
                }
                else{
                
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO,System.Label.LG_resendEmailSuppressCheck);
                ApexPages.addMessage(myMsg);
                
                }
            }
            else{
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LG_resendEmailSuppressCheck);
                ApexPages.addMessage(myMsg);                
            }
            
            
            disablesendEmail=true;
            
            
        }
        Catch(Exception e){
            system.debug(e.getMessage());
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error occured, please raise incident. Error: '+e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }   
}