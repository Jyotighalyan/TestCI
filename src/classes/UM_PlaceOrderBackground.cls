/*
* Used to place an order in Cama via spider
* and receive acknowledgemnt from SPider
* @author Alisha
* @ticket SFOM-672
* @since  17/6/2017
*/
global class UM_PlaceOrderBackground 
{
    public String address,transactionId;
    Boolean Msg=false;
    Integer counter = 1, size=10, leadingZeroes;
    public  Account account ;
    public  List<csord__Service__c> serviceList ;
    public  List<csord__Solution__c> currentSolutions = new List<csord__Solution__c>();
    public  List<csord__Solution__c> updatedSolutions = new List<csord__Solution__c>();
    public  UM_minervawsUnitymediaCom.asyncTransaction res;
    UM_MinervaConnection__c  connection = UM_MinervaConnection__c.getInstance();
    public  String packageName;
    public  Set<Id> replacedServiceID = new Set<Id>();
    public  Set<Id> serviceIDs = new Set<Id>();
    public  Map<Id,csord__Service__c> upcServiceListMap = new Map<Id,csord__Service__c >();
    public  String pAcctno;
    
    public String createOrder(Csord__Solution__c currentSolution) 
    {    
        try
        {
            csord__Solution__c solo = [SELECT csord__Order__r.csordtelcoa__Opportunity__c,UM_No_of_Tries__c 
                                       FROM csord__Solution__c WHERE id = :currentSolution.id];
            
            Id oppId    = solo.csord__Order__r.csordtelcoa__Opportunity__c;
            
            serviceList = [SELECT Id, csord__Activation_Date__c, csord__Status__c,LG_Quantity__c,LG_ProvisioningCode__c,
                           csord__Service__r.name , csord__Service__c,csord__Service__r.LG_ProvisioningAccountNo__c, csordtelcoa__Replaced_Service__r.LG_Action__c,
                           LG_ProvisioningAccountNo__c, LG_Action__c, UM_DependsOnService__c,UM_DependsOnService__r.LG_ProvisioningAccountNo__c,LG_AdditionalInformation__c 
                           FROM csord__Service__c WHERE LG_Suborder__c = :currentSolution.Id];
            
            account     = [SELECT id, name, NumberOfEmployees, LG_ChamberOfCommerceNumber__c, UM_IndustryClassification__c 
                           FROM account WHERE id = :currentSolution.csord__Account__c];
            
            List<cscfga__Product_Configuration__c> prodConfList = [SELECT Id,name, LG_Address__r.LG_TechnicalContact__c, LG_Address__r.LG_TechnicalContact__r.Name FROM cscfga__Product_Configuration__c 
                                                                   WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c =:oppId AND cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = true];
            
            Set<id> techContactIds  = new Set<id>();
            
            for(cscfga__Product_Configuration__c pb : prodConfList)
            {
                techContactIds.add(pb.LG_Address__r.LG_TechnicalContact__c);
            }
            
            List<Contact> techContacts = [SELECT id, LG_SalutationLocal__c, LG_Role__c, firstName, 
                                          LastName, Email, phone, title From contact where id in:techContactIds ];
            
            String provAccountNumber;
            
            if(!serviceList.isEmpty())
            {
                for (csord__Service__c srv : serviceList)
                { 
                    if(String.isNotBlank(srv.LG_ProvisioningAccountNo__c))
                    {
                        packageName='Upgrade';
                        //procAcctNo.add(s.LG_ProvisioningAccountNo__c);
                        provAccountNumber = srv.LG_ProvisioningAccountNo__c;
                        break;
                    }
                    else if(String.isNotBlank(srv.UM_DependsOnService__c) && String.isNotBlank(srv.UM_DependsOnService__r.LG_ProvisioningAccountNo__c))
                    {
                        packageName='Upgrade';
                        //procAcctNo.add(s.UM_DependsOnService__r.LG_ProvisioningAccountNo__c);
                        provAccountNumber = srv.UM_DependsOnService__r.LG_ProvisioningAccountNo__c; 
                        break;
                    }
                    else
                    {
                        packageName ='Install';
                    }
                }
                System.debug('****packagName-->' + packageName);
                System.debug('-----procAcctNo-->'+ provAccountNumber);
            }
            
            UM_minervawsUnitymediaCom.MinervaWSPort  pbWebservice = new UM_minervawsUnitymediaCom.MinervaWSPort();
            
            res = new  UM_minervawsUnitymediaCom.asyncTransaction();
            
            UM_metaWebserviceMinervaZentiveCom.placeOrderRequest param = new UM_metaWebserviceMinervaZentiveCom.placeOrderRequest();
            
            if(packageName == 'Install')
            {
                UM_metaWebserviceMinervaZentiveCom.customerDetails custDetails = new UM_metaWebserviceMinervaZentiveCom.customerDetails();
                
                List<UM_metaWebserviceMinervaZentiveCom.customerDetails> customerDetailsFromSF = new List<UM_metaWebserviceMinervaZentiveCom.customerDetails>();
                
                UM_metaWebserviceMinervaZentiveCom.b2BContactDetails contDetail = new UM_metaWebserviceMinervaZentiveCom.b2BContactDetails();
                
                UM_metaWebserviceMinervaZentiveCom.customerName custName = new UM_metaWebserviceMinervaZentiveCom.customerName();
                
                UM_metaWebserviceMinervaZentiveCom.customerBillingDetails custBillingDetails = new UM_metaWebserviceMinervaZentiveCom.customerBillingDetails();
                
                UM_metaWebserviceMinervaZentiveCom.flexibleFormatAddress billingAddress = new UM_metaWebserviceMinervaZentiveCom.flexibleFormatAddress();
                
                if (techContacts.size() != 0 || !techContacts.isEmpty()) 
                {
                    for (Contact c : techContacts ) 
                    {
                        contDetail.title = c.LG_SalutationLocal__c;
                        contDetail.firstName = c.firstName;
                        contDetail.lastName = c.lastName;
                        contDetail.emailAddress = c.email;
                        
                        String formattedPhone;          
                        if(String.isNotBlank(c.phone))
                            formattedPhone= string.valueof(c.phone).replace('(','').replace(')','').replace('-','').replace('+','').replace(' ',''); 
                        
                        System.debug('formattedPhone==' + formattedPhone);            
                        
                        if((String.valueOf(c.Phone).substring(0,1)) != '0')
                            contDetail.telephoneNumber = '0' + formattedPhone;
                        
                        else
                            contDetail.telephoneNumber = formattedPhone;
                    }
                    System.debug('b2bContactDetails==' + contDetail);
                    System.debug('contDetail.telephoneNumber==' + contDetail.telephoneNumber);
                    
                    param.b2bContactDetails = contDetail; 
                }
                //setting customer details along with name ,trade branch and sub trade branch
                custName.nameFormat = Label.LG_CamaCustNameFormat;
                custName.title = Label.LG_CamaCustNameTitle;
                custName.FirstName = Label.LG_CamaCustFirstName;
                custName.LastName = account.name;
                system.debug('customerName==' + custName);
                
                custDetails.customerName = custName;
                custDetails.tradeBranch = Label.LG_CamaCustTradeBranch;
                custDetails.tradeSubBranch = Label.LG_CamaCustTradeSubBranch;
                custDetails.emailAddress = connection.UM_Email_Address__c;
                customerDetailsFromSF.add(custDetails);
                
                param.CustomerCategory = Label.LG_CamaCustCategory;
                
                billingAddress.nameFormat = Label.LG_CamaBillingAddrNameFormat;
                billingAddress.title      = Label.LG_CamaBillingAddrTitle;
                billingAddress.firstName  = Label.LG_CamaBillingAddrFirstName;
                billingAddress.lastName   = Label.LG_CamaBillingAddrLastName;
                billingAddress.postCode   = Label.LG_CamaBillingAddrPostCode;
                billingAddress.city       = Label.LG_CamaBillingAddrCity;
                billingAddress.street     = Label.LG_CamaBillingAddrStreet;
                billingAddress.houseNumber= Label.LG_CamaBillingAddrHouseNo;
                System.debug('Billing Address: ' + billingAddress);
                
                custBillingDetails.paymentMethod = Label.LG_CamaCustPaymentMethod;
                custBillingDetails.billingAddress = billingAddress;
                System.debug('CustomerBillingDetails: ' + custBillingDetails);
                
                param.customerBillingDetails = custBillingDetails;
                param.customerDetails = custDetails;
                
                address = currentSolution.LG_Address__r.LG_AddressID__c;
                
                if(address!=null){
                    leadingZeroes=size-address.length();
                    if(leadingZeroes>0){
                        for(Integer i=0;i<leadingZeroes;i++){
                            address='0'+address;                
                        }
                        system.debug('add=='+address);
                    }
                    else if(leadingZeroes==0){
                        system.debug('no change in add=='+address);
                    }
                    else{
                        system.debug('error: addressId>10=='+address);
                    }
                }
                param.buildingId = address;
                system.debug('param.buildingId=' + param.buildingId); 
                
                param.region = currentSolution.LG_Address__r.cscrm__State_Province__c;
                
                List<UM_metaWebserviceMinervaZentiveCom.upcObject> listUpcd = new List<UM_metaWebserviceMinervaZentiveCom.upcObject>();
                for (csord__Service__c s : serviceList) {
                    UM_metaWebserviceMinervaZentiveCom.upcObject upcd = new UM_metaWebserviceMinervaZentiveCom.upcObject();
                    // for defect OMB-825
                    String newUpc;
                    if (s.csord__Service__r.name == 'WLAN' && s.LG_ProvisioningCode__c == 'WIFIAP_4_90') {
                        newUpc = String.valueof(s.LG_Quantity__c)+(s.LG_ProvisioningCode__c);
                    }
                    if (newUpc != null) {
                        upcd.upc = newUpc;
                        system.debug('newUpc ==' + newUpc );  
                    } else {
                        upcd.upc = s.LG_ProvisioningCode__c;
                    }            
                    listUpcd.add(upcd);
                    system.debug('upcd==' + upcd.upc+' s=='+s);
                }
                
                UM_metaWebserviceMinervaZentiveCom.upcList_element upcle = new UM_metaWebserviceMinervaZentiveCom.upcList_element();
                upcle.upcObject = listUpcd;
                
                system.debug('listUpcd==' + listUpcd);
                UM_metaWebserviceMinervaZentiveCom.installPackage insPkg = new UM_metaWebserviceMinervaZentiveCom.installPackage();
                insPkg.upcList =  upcle ;
                
                List<UM_metaWebserviceMinervaZentiveCom.installPackage> insPkgList = new List<UM_metaWebserviceMinervaZentiveCom.installPackage>();
                insPkgList.add(insPkg);
                
                UM_metaWebserviceMinervaZentiveCom.installPackageList insList = new UM_metaWebserviceMinervaZentiveCom.installPackageList();
                insList.installPackage = insPkgList;
                
                UM_metaWebserviceMinervaZentiveCom.orderDetails orDet = new UM_metaWebserviceMinervaZentiveCom.orderDetails();
                orDet.installPackages = insList;
                
                param.OrderDetails = orDet;
                
                System.debug('ord details==' + orDet);
            }
            
            else if(packageName == 'Upgrade')
            {
                UM_metaWebserviceMinervaZentiveCom.upgradePackage upgradePkg = new UM_metaWebserviceMinervaZentiveCom.upgradePackage ();
                
                System.debug('** Entered Upgrade');
                for(csord__Service__c s : serviceList)
                { 
                    if( s.LG_Action__c != 'Delete' && s.LG_ProvisioningCode__c != null) 
                    { 
                        serviceIDs.add(s.id);
                        upcServiceListMap.put(s.id,s);
                        system.debug('-----upcServiceListMap'+upcServiceListMap);
                        if(s.csordtelcoa__Replaced_Service__r.id != null)
                        {
                            replacedServiceID.add(s.csordtelcoa__Replaced_Service__r.id);
                        } 
                    }
                }
                
                List<csord__Service__c> upcServiceList = new List<csord__Service__c  >([SELECT Id,UM_DependsOnService__r.LG_ProvisioningAccountNo__c ,csord__Solution__c,csordtelcoa__Replaced_Service__c,csord__Solution__r.id,csord__Activation_Date__c, LG_Action__c,csord__Status__c, LG_ProvisioningCode__c, csord__Service__c, LG_ProvisioningAccountNo__c, UM_DependsOnService__c, LG_AdditionalInformation__c
                                                                                          FROM csord__Service__c
                                                                                          WHERE LG_ProvisioningAccountNo__c = :provAccountNumber AND
                                                                                          LG_Action__c != 'Delete' AND LG_ProvisioningCode__c != null and LG_ServiceStatus__c = 'Active' and Id not in:replacedServiceID and Id not in :serviceIDs]);
                if(upcServiceList.size()>0)
                {
                    for(csord__Service__c  srv : upcServiceList)
                    {
                        upcServiceListMap.put(srv.id,srv);
                    }
                }
                
                system.debug('--upcServiceListMap'+upcServiceListMap);
                
                if(upcServiceListMap.values() != null  )
                {
                    List<UM_metaWebserviceMinervaZentiveCom.upcObject> listUpcd = new List<UM_metaWebserviceMinervaZentiveCom.upcObject>();
                    
                    for (csord__Service__c s : upcServiceListMap.values())
                    {
                        UM_metaWebserviceMinervaZentiveCom.upcObject upcd = new UM_metaWebserviceMinervaZentiveCom.upcObject();
                        System.debug('**actchk' + upcServiceListMap.get(s.id).LG_ProvisioningAccountNo__c);
                        System.debug('**actchk2'+ upcServiceListMap.get(s.id).UM_DependsOnService__c + '--' + upcServiceListMap.get(s.id).UM_DependsOnService__r.LG_ProvisioningAccountNo__c );
                        
                        if (String.isNotBlank(upcServiceListMap.get(s.id).LG_ProvisioningAccountNo__c))
                            param.AccountNumber = upcServiceListMap.get(s.id).LG_ProvisioningAccountNo__c;
                        
                        else if (String.isNotBlank(upcServiceListMap.get(s.id).UM_DependsOnService__c) && String.isNotBlank(upcServiceListMap.get(s.id).UM_DependsOnService__r.LG_ProvisioningAccountNo__c))
                        {
                            System.debug('Its an old customer');
                            param.AccountNumber = upcServiceListMap.get(s.id).UM_DependsOnService__r.LG_ProvisioningAccountNo__c;
                        }

                        // code for sfom-2581(OMB-2270) to include additional information in the order request in case of upgrade
                        if (String.isNotBlank(upcServiceListMap.get(s.id).LG_AdditionalInformation__c))
                            param.orderComments = upcServiceListMap.get(s.id).LG_AdditionalInformation__c;
                            
                            String newUpc;
                            if (s.csord__Service__r.name == 'WLAN' && s.LG_ProvisioningCode__c == 'WIFIAP_4_90') {
                                newUpc = String.valueof(upcServiceListMap.get(s.id).LG_Quantity__c)+(upcServiceListMap.get(s.id).LG_ProvisioningCode__c);
                            }
                            if (newUpc != null) {
                                upcd.upc = newUpc;
                                system.debug('newUpcUpgrade ==' + newUpc );  
                            } else {
                                upcd.upc = upcServiceListMap.get(s.id).LG_ProvisioningCode__c;
                            }  
                        
                            listUpcd.add(upcd);
                            system.debug('upcdUpgrade==' + listUpcd +' s=='+s);
                    }
                    
                    UM_metaWebserviceMinervaZentiveCom.upcList_element upcle = new UM_metaWebserviceMinervaZentiveCom.upcList_element();
                    upcle.upcObject = listUpcd;

                    upgradePkg.upcList =  upcle ;

                    List<UM_metaWebserviceMinervaZentiveCom.upgradePackage> upgradePkgList = new List<UM_metaWebserviceMinervaZentiveCom.upgradePackage >();
                    upgradePkgList.add(upgradePkg );
                    
                    UM_metaWebserviceMinervaZentiveCom.upgradePackageList upList= new UM_metaWebserviceMinervaZentiveCom.upgradePackageList ();
                    upList.upgradePackage= upgradePkgList;
                    
                    UM_metaWebserviceMinervaZentiveCom.orderDetails orDet = new UM_metaWebserviceMinervaZentiveCom.orderDetails();
                    orDet.upgradePackages= upList;
                    
                    param.OrderDetails = orDet;
                }
                
                if(upcServiceListMap.values().isempty() || upcServiceListMap.values()==null ||
                   upcServiceListMap == null  || upcServiceListMap.isEmpty() )
                {
                    system.debug('****packagName  : NoPackagelist since its Terminate');
                    List<csord__Service__c> terminatedServiceList = new  List<csord__Service__c>([Select Id,UM_DependsOnService__r.LG_ProvisioningAccountNo__c,csord__Activation_Date__c, LG_Action__c,csord__Status__c, LG_ProvisioningCode__c, csord__Service__c, LG_ProvisioningAccountNo__c, UM_DependsOnService__c from csord__Service__c where LG_Suborder__c = :currentSolution.Id ]);
                    for(csord__Service__c ser : terminatedServiceList )
                    {        
                        if (String.isNotBlank(ser.LG_ProvisioningAccountNo__c))
                            param.AccountNumber = ser.LG_ProvisioningAccountNo__c;
                        
                        else if (String.isNotBlank(ser.UM_DependsOnService__c) && String.isNotBlank(ser.UM_DependsOnService__r.LG_ProvisioningAccountNo__c))
                            param.AccountNumber = ser.UM_DependsOnService__r.LG_ProvisioningAccountNo__c;
                    }
                }
                
                upgradePkg.serviceGroup='B';
                upgradePkg.id='1';
                
                param.region = currentSolution.LG_Address__r.cscrm__State_Province__c;
                param.CustomerCategory = 'B';
                //param.buildingId = address;
                // system.debug('param.buildingId Upgrade=' + param.buildingId);
            }
            
            //set systemLetterPreference and commercialRegister
            param.systemLetterPreference = connection.System_Letter_Preference__c;
            
            if(String.isNotBlank(account.LG_ChamberOfCommerceNumber__c)){
                param.commercialRegister = account.LG_ChamberOfCommerceNumber__c;
            }
            else{
                param.commercialRegister = Label.LG_CamaCommericalRegister;
            }
            
            system.debug('param--' + JSON.serializePretty(param));
            
            //setting endpoints and auth tokens
            pbWebservice.endpoint_x = connection.Connection_URL__c;
            pbWebservice.inputHttpHeaders_x = new Map<String, String>();
            pbWebservice.inputHttpHeaders_x.put('Authorization', connection.Authentication_Token__c);
            system.debug('connection--' + connection);
            
            if (connection.Session_Timeout__c != null) {
                system.debug('connection is not null--' + connection);
                pbWebservice.timeout_x = Integer.valueOf(connection.Session_Timeout__c);
            }
            
            system.debug('111111==' + connection.Authentication_Token__c);
            system.debug('22222-=' + param);
            
            //call place order method with param and auth values
            res = pbWebservice.placeOrder(param, connection.Authentication_Token__c);
            system.debug('res--' + JSON.serializePretty(res));
            system.debug('res.transactionId==' + res.transactionId);
            
            if(res.transactionId != null){
                transactionId = String.valueOf(res.transactionId);
            }
            
            Msg = res.success;
            
            //update based on result
            for(Integer i=1;i<4;i++){
                if(!Msg)
                {
                    res     = pbWebservice.placeOrder(param, connection.Authentication_Token__c);
                    counter = i;
                    if(res.success)
                    {
                        transactionId = String.valueOf(res.transactionId);
                        Msg = res.success;
                        break;
                    }
                }
            }
        }
        catch (Exception e) 
        {
            transactionId = e.getMessage();
            system.debug('error in Cama class==' + e.getMessage()); 
        }
        
        return transactionId;
    }
}