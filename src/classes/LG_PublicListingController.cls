/*
***************************************************************************************************
* File Name     :  LG_PublicListingController
* Description   :  This is a controller class for Public Listing changes

* @author       :   Tomislav Blazek
* @modified by  :   Alisha and Godson
******************************************************************************************************
*/


public with sharing class LG_PublicListingController {

    public static final Integer pageSize = 15;
    public String searchWord {get; set;}
    public String searchWordPublic {get; set;}
    public Boolean showNextBtn {get; set;}
    public Boolean showNextBtnPublic {get; set;}
    public Integer offset {get; set;}
    public Integer offsetPublic {get; set;}
    public Account account {get; set;}
    public cscfga__Product_Basket__c basket {get; set;}
    public Case cs{get; set;}
    public Id returnId {get; set;}
    private Boolean basketContext;
    private Boolean isAccount {get; set;}
    private Boolean isCase {get; set;}
    public List<Asset> numberList {get; set;}
    //  public List<wrapperAsset> Asts{get; set;}
    public List<Asset> selectedAsset {get; set;}
    public List<NumberLine> result {get; set;}
    public Asset assetToSelect {get; set;}
    public Integer rowVal {get; set;}
    public boolean displayPopup {get; set;}
    public Decimal numberblocksize{get;set;}
    public Id telephoneconfig{get; set;}
    public String retUrl{get;set;}
    public Date fDate { get; set; }
    public String errorMessage {get; set;}

    public LG_PublicListingController() {
        
        returnId = ApexPages.currentPage().getParameters().get('id');
        retURL = ApexPages.currentPage().getParameters().get('retURL');

        if (String.isBlank(returnId)) {
            errorMessage = System.Label.LG_ErrorReturnIdParameter;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,errorMessage));
        } else {

            if (Schema.cscfga__Product_Basket__c.SObjectType == returnId.getSObjectType()) {
                basketContext = true;
                isAccount=false;
                isCase=false;
            } 
            else if (Schema.Case.SObjectType == returnId.getSObjectType()) {
                isCase = true;
                basketContext = false;
                isAccount=false;
            } 
            else{
                isAccount = true;
                isCase = false;
                basketContext = false;
                
            } 
            if (basketContext) {
                basket = [SELECT Id, Name, csbb__Account__c, csbb__Account__r.Name
                          FROM cscfga__Product_Basket__c WHERE Id = :returnId];
                account = new Account(Id = basket.csbb__Account__c, Name = basket.csbb__Account__r.Name);
            } 
           else if(isAccount) {
                account = [SELECT Id, Name FROM Account WHERE Id = :returnId];
            }
          else  if(isCase) {
                cs= [SELECT Id,CaseNumber, LG_Solution__c FROM Case WHERE Id = :returnId];
                
            }
            else
            {  
            errorMessage = System.Label.LG_ErrorReturnIdParameterMultiple;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,errorMessage));

            }
            
            // initializing control variables
            this.searchWord       = null;
            this.searchWordPublic = null;
            this.offset           = 0;
            this.offsetPublic     = 0;
        }
        refreshListValues();
        getnumberBlockSize();
    }
    
    
    public List<NumberLine> getPublicNumbers()
    {
        return getNumbers(true);
    }
    public String getNmbrAsset() {
        return null;
    }
    public String getAsset() {
        return null;
    }
    
    public List<NumberLine> editNonPublicNumbersList{get; set;}
    public List<NumberLine> getEditNonPublicNumbers(){
        this.editNonPublicNumbersList = getNumbers(false);
        return this.editNonPublicNumbersList;
    }
    public List<NumberLine> nonPublicNumbersList{get; set;}
    public List<NumberLine> getNonPublicNumbers(){
        this.nonPublicNumbersList = getNumbers(false);
        return this.nonPublicNumbersList;
    }

    public List<NumberLine> getNumbers(Boolean onlyPublic){
        result = new List<NumberLine>();
        String filterNumber = onlyPublic ? searchWordPublic : searchWord;
        Integer offsetNmbr  = onlyPublic ? offsetPublic : offset;

        String query = 'SELECT LG_PhoneNumber__c,LG_PublicListingName__c ,LG_Published__C ,LG_NumberRangeType__c,'
                        +' LG_Asset__r.LG_NumberRangeSize__c , LG_InstallationAddress__c, LG_PortInWishDate__c ,LG_PortInOperator__c,' +'LG_TelephonyProductConfiguration__r.LG_Address__c, LG_TelephonyProductConfiguration__r.LG_Address__r.name,'
                        +'LG_TelephonyProductConfiguration__r.Name, LG_NumberRangeSize__c,LG_PortInHouseNumber__c,LG_PortInHouseNumberExtension__c , ' +'LG_TelephonyService__c,LG_PublicListingDescription__c,LG_PublicListingCompanyName__c,LG_Entry_Format__c,LG_Fax__c,LG_PortInCity__c,'
                        +'LG_Number_Type__c,LG_PostalCode__c,LG_House_Number__c,LG_SubHeader__c,LG_PublicListingAddress__c,'
                        +'LG_ListingType__c,LG_NumberActivationCeaseDate__c, '
                        + 'LG_InDirectory__c FROM Asset WHERE RecordType.Name = \'Phone Number\' AND LG_InDirectory__c = '
                        + onlyPublic;

        if (basketContext){
            query = query + ' AND LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c = \'' + returnId + '\'';
        } 
        else if (isCase){
            query = query + ' AND csord__Order__r.csord__Solution__c= \'' + this.cs.LG_Solution__c + '\'';
        }
        else{
            query = query + ' AND AccountId = \'' + returnId + '\'';
        }
    
        if (String.isNotBlank(filterNumber)) {
            query = query + ' AND LG_PhoneNumber__c LIKE \'%' + filterNumber + '%\'';
        }

        query = query + ' ORDER BY LG_PhoneNumber__c';

        if (String.isBlank(filterNumber)) {
            query = query + ' LIMIT ' + pageSize + ' OFFSET ' + offsetNmbr;
        }
        system.debug('query=='+query);
        numberList = (Asset[]) Database.query(query);
        if (String.isBlank(filterNumber)) {
            Boolean showButton = numberList.size() == pagesize;
            if (onlyPublic) {
                this.showNextBtnPublic = showButton;
            } else {
                this.showNextBtn = showButton;
            }
        }
        for (Asset nmbrAsset : numberList) {
            result.add(new NumberLine(false, nmbrAsset));
        }
         return result;
    }

    public void nextPage(){
        this.searchWord = null;
        this.offset    += pagesize;
    }

    public void prevPage(){
        this.searchWord = null;
        this.offset    -= pagesize;
    }

    public void nextPagePublic(){
        this.searchWordPublic = null;
        this.offsetPublic    += pagesize;
    }

    public void prevPagePublic(){
        this.searchWordPublic = null;
        this.offsetPublic    -= pagesize;
    }

    // defines whether the number has already been selected or not
    public class NumberLine {
        public Boolean checked {get; set;}
        public Asset nmbrAsset {get; set;}

        public NumberLine(Boolean checked, Asset nmbrAsset){
            this.checked   = checked;
            this.nmbrAsset = nmbrAsset;
        }
    }

    //back to return Id
    public PageReference redirectToReturnId() {
       // PageReference newocp = new PageReference(LG_Util.getSalesforceBaseUrl() + '/' + returnId+'/e?retURL=%2F'+returnId);
        PageReference pageRef;
        if(retURL != null){
            pageRef = new PageReference(retURL);
        }
       return pageRef;

    }

    public void assetAltered() {
            //Assigning the table list to the popup list to avoid mismatch in field values
            editNonPublicNumbersList = nonPublicNumbersList;
            selectedAsset = new List<Asset>();
            for (NumberLine w : nonPublicNumbersList) {
                System.debug('w LG_InDirectory__c-->'+w.nmbrAsset.LG_InDirectory__c);
                System.debug('w.nmbrAsset.LG_PhoneNumber__c-->'+w.nmbrAsset.LG_PhoneNumber__c);
                if ((w.nmbrAsset.LG_InDirectory__c == true ||w.checked==true)) {
                    selectedAsset.add(w.nmbrAsset); 
                }
                
           }
            //selectedAsset = new List<Asset>();
            //NumberLine numberValue = nonPublicNumbersList.get(rowVal);
            //numberValue.nmbrAsset.LG_InDirectory__c = true;
            //update nonPublicNumbersList;
        
        displayPopup = false;
   }
    
    public void assetEditAltered() {
        nonPublicNumbersList = editNonPublicNumbersList;
        selectedAsset = new List<Asset>();
        for (NumberLine num : editNonPublicNumbersList) {
            System.debug('num LG_InDirectory__c-->'+num.nmbrAsset.LG_InDirectory__c);
            System.debug('num.LG_PhoneNumber__c-->'+num.nmbrAsset.LG_PhoneNumber__c);
            if ((num.nmbrAsset.LG_InDirectory__c == true ||num.checked==true)) {
                    selectedAsset.add(num.nmbrAsset); 
             }
        }
        
        displayPopup = false;
    }
    
    
    public void assetSelectRow(){
    }
    
    public void showPopup()
    {
        displayPopup = true;
    }

    public void closePopup() {
        displayPopup = false;
    }
    
    public Decimal getnumberBlockSize(){
     for (NumberLine w : nonPublicNumbersList) {
            numberblocksize=w.nmbrAsset.LG_Asset__r.LG_NumberRangeSize__c;
            telephoneconfig=w.nmbrAsset.LG_TelephonyProductConfiguration__c;
            }
        system.debug('numberBlockSize=='+numberBlockSize+' ==telephoneconfig=='+telephoneconfig);
        return numberBlockSize;
    }
    
   public PageReference save() {
      
        try {
            
        for(Asset s:selectedAsset){
        s.LG_InDirectory__c=true;
        s.LG_Published__c=true;
        s.LG_UnPublished__c=false;
        update s;
        refreshListValues();
        }
        }
        catch (Exception e) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
      }
         
           if(retURL != null){
          Pagereference  pageRef = new PageReference(retURL);
            return pageRef;
            }
            else 
            return null;
         }
    
    public void refreshListValues(){
        getEditNonPublicNumbers();
        getNonPublicNumbers();
    }
        
    public List<Schema.FieldSetMember> getFields() {
        System.debug('getFields-->'+SObjectType.Asset.FieldSets.OM_Portin.getFields());
        return SObjectType.Asset.FieldSets.OM_Portin.getFields();
    }


   
}