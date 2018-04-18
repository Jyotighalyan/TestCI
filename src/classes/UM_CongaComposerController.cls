public class UM_CongaComposerController {
    
    private HTTPResponse response;
    private String oppId;
    private Opportunity opp;
    private String url;
    private String myMsg;
    private String congaResponse = '';
    private String congaResponseBody = '';
    private Boolean flagSuccess=false;
    private Boolean flagError=false;
    public Attachment congaAttachedSf{get;set;}
    
    public UM_CongaComposerController () {                    
        callConga();   
    }
    
    public void callConga() {
        if(Apexpages.currentPage().getParameters().get('id') != null) {
            Id userId = userinfo.getUserId();
            User userDetails =[SELECT Id, Profile.Name, UserRole.Name FROM User where Id=:userId ];
            system.debug('Profile Name:' + userDetails.Profile.Name);
            system.debug('Role Name:' + userDetails.UserRole.Name);
            DateTime todayDate = Date.Today() ;
            String dateStr =  todayDate .format('dd.MM.yyyy') ;
            oppId = Apexpages.currentPage().getParameters().get('id');
            /* UM query */
            String query = 'Select Id, um_createquoteurl__c,UM_Approval__c,UM_Product_Categories__c,Account.LG_AccountNumber__c  from Opportunity Where Id=\'' + oppId + '\'';
            opp= Database.query(query);
            url = 'https://composer.congamerge.com/composer8/index.html?SessionId=' + UserInfo.getSessionId() + '&ServerURL=' + LG_EnvironmentVariables__c.getOrgDefaults().LG_SalesforceBaseURL__c+'/services/Soap/u/29.0/' + UserInfo.getOrganizationId() +'&id='+opp.Id +
                        '&QueryId=[Query02]'+LG_EnvironmentVariables__c.getOrgDefaults().LG_CongaQueryID5__c+
                        '&QueryId=[Query03]'+LG_EnvironmentVariables__c.getOrgDefaults().LG_CongaQueryID6__c+
                        '&QueryId=[ConRole]'+LG_EnvironmentVariables__c.getOrgDefaults().LG_CongaQueryID7__c+
                        '&QueryId=[BillSer]'+LG_EnvironmentVariables__c.getOrgDefaults().LG_CongaQueryID8__c+
                        '&QueryId=[Owner]'+LG_EnvironmentVariables__c.getOrgDefaults().LG_CongaQueryID9__c+
                        '&TemplateId='+LG_EnvironmentVariables__c.getOrgDefaults().LG_CongaTemplateID__c+
                        '&SelectTemplates=0&DefaultPDF=1&OFN=Unitymedia_Angebot_'+opp.Account.LG_AccountNumber__c+'_'+dateStr+ 
                        '&FP0='+LG_Congatemplates__c.getOrgDefaults().LG_BinaryValueOne__c+
                        '&DS2='+LG_Congatemplates__c.getOrgDefaults().LG_BinaryValueOne__c+
                        '&DS3='+LG_Congatemplates__c.getOrgDefaults().LG_BinaryValueOne__c+
                        '&DS7='+LG_Congatemplates__c.getOrgDefaults().LG_BinaryValueOne__c+
                        '&SC0='+LG_Congatemplates__c.getOrgDefaults().LG_BinaryValueOne__c+
                        '&SC1=Attachments'+
                        '&APIMode='+LG_Congatemplates__c.getOrgDefaults().LG_BinaryValueOne__c;
            try{
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(url);           
                request.setMethod('GET');
                request.setTimeout(60000);    
                response = http.send(request);
                
                congaResponse = response.getStatus() + ':' + response.getStatusCode();
                congaResponseBody = response.getBody();
                congaAttachedSf=[Select id,name from Attachment where id=:congaResponseBody];           
                System.debug(response.getStatus() + ':' + response.getStatusCode());
                if(congaResponseBody.equalsIgnoreCase(congaAttachedSf.id))
                {                   
                    flagSuccess=True;
                    myMsg='Sucessfully Quote Created and attached to Opportunity with Attachment ID: '+congaAttachedSf.id;
                }
                else
                {
                    flagError=true;
                    myMsg='Conga Composer Response: '+congaResponseBody; 
                }   
            }
            catch(Exception e)
            {
                flagError=true;
                myMsg='Unable to Perform Operation -Exception :'+ e.getMessage() ;
            }            
        }
    }  
    public String getMyMsg(){
    return myMsg;
    }
    public Boolean getFlagSuccess()
        {return flagSuccess;}
    public Boolean getFlagError()
        {return flagError;}    
    public boolean getSuccessResponse() {
        if(congaResponseBody.subString(0,5) == 'error') {
            return false;
        } else {
            return true;
        }
    }
}