/**
 * Used to place an order in Cama via spider
 * and receive acknowledgemnt from SPider
 * @author Alisha
 * @ticket SFOM-672
 * @since  17/6/2017
 */
global class UM_PlaceOrder {
    public static string add, Msg='false';
    static Integer counter = 1,Size=10, leadingZeroes;
    public static Account accList ;
    public static List<csord__Service__c> serviceList ;
    public static List<csord__Solution__c> currentSolutions = new List<csord__Solution__c>();
    public static List<csord__Solution__c> updatedSolutions = new List<csord__Solution__c>();
    public static UM_minervawsUnitymediaCom.asyncTransaction res;
    static UM_MinervaConnection__c  connection = UM_MinervaConnection__c.getInstance();
        public static string packagName;
        public static set<id> replacedServiceID=new set<id>();
        public static set<id> serviceIDs=new set<id>();
        public static map<id,csord__Service__c > upcServiceListMap=new map<id,csord__Service__c >();
        public static string pAcctno;
        
    
    @future(callout=true)
    public static void checkServices(Set<Id> processesIds,Set<Id> stepListIds) {
        List<CSPOFA__Orchestration_Step__c> stepList;
        List<sObject> result = new List<sObject>();

        //custom setting to store the limit value
        UM_MinervaConnection__c  connection = UM_MinervaConnection__c.getInstance();

        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                LG_Solution__r.csord__Account__c, LG_Solution__r.csord__Account__r.NumberOfEmployees, LG_Solution__r.csord__Account__r.LG_ChamberOfCommerceNumber__c, LG_Solution__r.csord__Account__r.UM_IndustryClassification__c,
                LG_Solution__r.LG_Address__c, LG_Solution__r.LG_Address__r.cscrm__State_Province__c,  LG_Solution__r.LG_Address__r.LG_AddressID__c, LG_Solution__c,
                LG_Solution__r.csord__Status__c,
                    LG_Solution__r.id,
                    LG_Solution__r.LG_ProvisioningAccountNo__c,
                    LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,
                LG_Solution__r.csord__Order__c
                , csordtelcoa__Service__r.LG_ProvisioningCode__c
                FROM CSPOFA__Orchestration_Process__c
                WHERE Id IN :processesIds AND LG_Solution__c != null]) {

            // Populate records
            currentSolutions.add(process.LG_Solution__r);
            system.debug(' currentSolutions: ' + currentSolutions);
        }
        if(stepListIds!=null){
        stepList=[select Id,Name,RecordTypeId,CSPOFA__Class__c,CSPOFA__Orchestration_Process__c,
                                                        CSPOFA__Jeopardy_Created_Flag__c,CSPOFA__Milestone__c,
                                                        CSPOFA__Orchestration_Step_Template__c,CSPOFA__Outside_OLA__c,
                                                        CSPOFA__Status__c,CSPOFA__Step_On_Hold__c,CSPOFA__Step_Order__c,
                                                        CSPOFA__Supports_Cancel__c,CSPOFA__Task_Account_Name_in_Subject__c,
                                                        CSPOFA__Type__c,CSPOFA__Completed_Date__c  from CSPOFA__Orchestration_Step__c where Id IN :stepListIds];
                                                        
                              
        system.debug('stepList='+stepList);
                              }   
        if (!currentSolutions.isEmpty()) {
            try
            {
            Msg = createOrder(currentSolutions[0]);
            system.debug('Msg in check services=='+msg);
            if (Msg.equalsIgnoreCase('true') || Msg.equalsIgnoreCase('Tries Exceeded')){
                 
                 for (CSPOFA__Orchestration_Step__c step : stepList) {

                    System.debug('---> Alisha 1-- step--'+step );
                    //mark step Status, Completed Date 
                    step.CSPOFA__Status__c         = 'Complete';
                    step.CSPOFA__Completed_Date__c = Date.today();
                    result.add(step);
                    }
                                        System.debug('---> Alisha 2-- result--'+result);

                    update result;
                }
                
                else
                {
                system.debug('orch processs in progress');
                }
                
            }
            catch (Exception e) {
            system.debug('error in check service method==' + e.getMessage());
                }
        }
    }

   
public static string createOrder(Csord__Solution__c currentSolution) {

        csord__Solution__c solo = [select csord__Order__r.csordtelcoa__Opportunity__c from csord__Solution__c where id = :currentSolution.id];
        Id oppId = solo.csord__Order__r.csordtelcoa__Opportunity__c;
        //added by ankur
        List<cscfga__Product_Configuration__c> prodConfList =[SELECT Id,name, LG_Address__r.LG_TechnicalContact__c, LG_Address__r.LG_TechnicalContact__r.Name FROM cscfga__Product_Configuration__c 
                          WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c =:oppId AND cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = true];
        Set<id> techContactIds  = new Set<id>();
        for(cscfga__Product_Configuration__c pb : prodConfList){
            techContactIds.add(pb.LG_Address__r.LG_TechnicalContact__c);
        }
        List<Contact> techContacts = [SELECT id, LG_SalutationLocal__c, LG_Role__c, firstName, 
                                     LastName, Email, phone, title From contact where id in:techContactIds ];
            system.debug('techContacts='+techContacts);
            serviceList = [select Id, csord__Activation_Date__c,LG_Action__c,csordtelcoa__Replaced_Service__r.id, csord__Status__c,LG_Quantity__c, LG_ProvisioningCode__c,csord__Service__r.name , csord__Service__c,csord__Service__r.LG_ProvisioningAccountNo__c, LG_ProvisioningAccountNo__c, UM_DependsOnService__c, UM_DependsOnService__r.LG_ProvisioningAccountNo__c from csord__Service__c where LG_Suborder__c = :currentSolution.Id];
            accList = [select id, name, NumberOfEmployees, LG_ChamberOfCommerceNumber__c, UM_IndustryClassification__c from account where id = :currentSolution.csord__Account__c];
            
            set<string> procAcctNo=new set<string>();


        //custom setting to get auth values
        //UM_MinervaConnection__c  connection = UM_MinervaConnection__c.getInstance();

        UM_minervawsUnitymediaCom.MinervaWSPort  pbWebservice = new UM_minervawsUnitymediaCom.MinervaWSPort();
          res= new  UM_minervawsUnitymediaCom.asyncTransaction();

        UM_metaWebserviceMinervaZentiveCom.placeOrderRequest param = new UM_metaWebserviceMinervaZentiveCom.placeOrderRequest();


            if(serviceList.size()>0)
            {
                    for (csord__Service__c s : serviceList)
                    { 
                    
                      if(s.LG_ProvisioningAccountNo__c!=null   )
                      {
                           packagName='Upgrade';
                           procAcctNo.add(s.LG_ProvisioningAccountNo__c);
                           pAcctno=s.LG_ProvisioningAccountNo__c;
                          

                      }
                      else if(s.UM_DependsOnService__c!=null && s.UM_DependsOnService__r.LG_ProvisioningAccountNo__c!=null)
                      {
                           packagName='Upgrade';
                           procAcctNo.add(s.UM_DependsOnService__r.LG_ProvisioningAccountNo__c);
                           pAcctno=s.UM_DependsOnService__r.LG_ProvisioningAccountNo__c;
                           
                      }
                      else
                      {
                          packagName='Install';
                      }
                      system.debug('****packagName'+packagName);
                      if( s.LG_Action__c!='Delete' && s.LG_ProvisioningCode__c!=null && packagName=='Upgrade') {
                      
                      serviceIDs.add(s.id);
                      system.debug('-----serviceIDs'+serviceIDs);
                      
                      upcServiceListMap.put(s.id,s);
                      system.debug('-----upcServiceListMap'+upcServiceListMap);
                      if(s.csordtelcoa__Replaced_Service__r.id!=null)
                      {
                       replacedServiceID.add(s.csordtelcoa__Replaced_Service__r.id);
                      }
                        
                        }

                    }


                    if(packagName=='Install')
                    {

                    system.debug('** Entered Install');
        UM_metaWebserviceMinervaZentiveCom.customerDetails a = new UM_metaWebserviceMinervaZentiveCom.customerDetails();

        List<UM_metaWebserviceMinervaZentiveCom.customerDetails> customerDetailsFromSF = new List<UM_metaWebserviceMinervaZentiveCom.customerDetails>();

        UM_metaWebserviceMinervaZentiveCom.b2BContactDetails contDetail = new UM_metaWebserviceMinervaZentiveCom.b2BContactDetails();

        UM_metaWebserviceMinervaZentiveCom.customerName custName = new UM_metaWebserviceMinervaZentiveCom.customerName();
       
    /*added by ankur*/
     if (techContacts.size() != 0) {
        for (Contact c : techContacts ) {
            contDetail.title = c.LG_SalutationLocal__c;
            contDetail.firstName = c.firstName;
            contDetail.lastName = c.lastName;
            contDetail.emailAddress = c.email;
            contDetail.telephoneNumber = c.phone;
            
            if((String.valueOf(c.Phone).substring(0,1))!='0'){
                 contDetail.telephoneNumber ='0'+c.phone;
                 system.debug('contDetail.telephoneNumber=='+contDetail.telephoneNumber);
            }
            else
                   contDetail.telephoneNumber =c.phone;
         
        }
        system.debug('b2bContactDetails==' + contDetail);
        param.b2bContactDetails = contDetail;
        
    }
        //setting customer details along with name ,trade branch and sub trade branch
        custName.nameFormat = 'B';

        /**Cant find first name and last name in class Customer name **/
        custName.title = 'Firma';
        custName.FirstName = 'MLE KOAX';
        custName.LastName = accList.name;
        a.customerName = custName;
        system.debug('customerName==' + custName);
        a.tradeBranch = 'Industrie';
        a.tradeSubBranch = 'Kleinstunternehmen (2-9)';
        customerDetailsFromSF.add(a);

        param.CustomerCategory = 'B';



        system.debug('serviceList== ' + serviceList );
                                            for (UM_metaWebserviceMinervaZentiveCom.customerDetails c : customerDetailsFromSF )
                                            {
                    param.customerDetails = c;
                }
                add=currentSolution.LG_Address__r.LG_AddressID__c;
                if(add!=null){
                leadingZeroes=size-add.length();
                if(leadingZeroes>0){
                for(Integer i=0;i<leadingZeroes;i++){
                add='0'+add;                
                }
                system.debug('add=='+add);
                }
                else if(leadingZeroes==0){
                system.debug('no change in add=='+add);
                
                }
                else
                {
                system.debug('error: addressId>10=='+add);
                }}
                param.buildingId = add;
                system.debug('param.buildingId=' + param.buildingId);

                                            if(currentSolution.LG_Address__r.cscrm__State_Province__c!=null)
                                            {
                                            param.region = currentSolution.LG_Address__r.cscrm__State_Province__c;
                                            }

                                            else{
                                            system.debug('Address State is null');
                                            }

        //set upccode
        //UM_metaWebserviceMinervaZentiveCom.upcDefinition upcd = new UM_metaWebserviceMinervaZentiveCom.upcDefinition();
        //List<UM_metaWebserviceMinervaZentiveCom.upcDefinition> listUpcd = new List<UM_metaWebserviceMinervaZentiveCom.upcDefinition>();

        
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
                                              system.debug('upcd==' + upcd.upc);
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

                       }

                       else if(packagName=='Upgrade')
                       {           system.debug('** Entered Upgrade');
                           
                            
                            
                             
                                   
                                   list<csord__Service__c  > upcServiceList=new list<csord__Service__c  >([SELECT Id,csord__Solution__c,csordtelcoa__Replaced_Service__c,csord__Solution__r.id,csord__Activation_Date__c, LG_Action__c,csord__Status__c, LG_ProvisioningCode__c, csord__Service__c, LG_ProvisioningAccountNo__c, UM_DependsOnService__c
                                                                               FROM csord__Service__c
                                                                               WHERE LG_ProvisioningAccountNo__c in :procAcctNo AND
                                                                               LG_Action__c!='Delete' AND LG_ProvisioningCode__c!=null and LG_ServiceStatus__c='Active' and Id not in:replacedServiceID and Id not in :serviceIDs]);
                                    if(upcServiceList.size()>0)
                                    {
                                      for(csord__Service__c  ss:upcServiceList)
                                      {
                                          upcServiceListMap.put(ss.id,ss);
                                      }
                                    }
                                  
                                  
                                  param.region = currentSolution.LG_Address__r.cscrm__State_Province__c;
                                  param.CustomerCategory = 'B';
                                  system.debug('--upcServiceListMap'+upcServiceListMap);
                                if(upcServiceListMap.values()!=null)
                                {
                                  List<UM_metaWebserviceMinervaZentiveCom.upcObject> listUpcd = new List<UM_metaWebserviceMinervaZentiveCom.upcObject>();
                                  for (csord__Service__c s : upcServiceListMap.values())
                                  {
                                         UM_metaWebserviceMinervaZentiveCom.upcObject upcd = new UM_metaWebserviceMinervaZentiveCom.upcObject();
                                         system.debug('**actchk'+ upcServiceListMap.get(s.id).LG_ProvisioningAccountNo__c);
                                         system.debug('**actchk2'+ upcServiceListMap.get(s.id).UM_DependsOnService__c+'   '+upcServiceListMap.get(s.id).UM_DependsOnService__r.LG_ProvisioningAccountNo__c );

                                         if (upcServiceListMap.get(s.id).LG_ProvisioningAccountNo__c!= null)
                                         {

                                            param.AccountNumber = upcServiceListMap.get(s.id).LG_ProvisioningAccountNo__c;
                                          }
                                          else if (upcServiceListMap.get(s.id).UM_DependsOnService__c != null && upcServiceListMap.get(s.id).UM_DependsOnService__r.LG_ProvisioningAccountNo__c!=null)
                                          {
                                            system.debug('Its an old customer');
                                            param.AccountNumber = upcServiceListMap.get(s.id).UM_DependsOnService__r.LG_ProvisioningAccountNo__c;
                                          }
                                           upcd.upc =upcServiceListMap.get(s.id).LG_ProvisioningCode__c; //'1PLAY150B';
                                                 listUpcd.add(upcd);

                                           }
                                            UM_metaWebserviceMinervaZentiveCom.upcList_element upcle = new UM_metaWebserviceMinervaZentiveCom.upcList_element();
                                            upcle.upcObject = listUpcd;

                                            UM_metaWebserviceMinervaZentiveCom.upgradePackage upgradePkg = new UM_metaWebserviceMinervaZentiveCom.upgradePackage ();
                                            upgradePkg.upcList =  upcle ;
                                            upgradePkg.serviceGroup='B';
                                            upgradePkg.id='1';

                                            List<UM_metaWebserviceMinervaZentiveCom.upgradePackage> upgradePkgList = new List<UM_metaWebserviceMinervaZentiveCom.upgradePackage >();
                                            upgradePkgList.add(upgradePkg );

                                            UM_metaWebserviceMinervaZentiveCom.upgradePackageList upList= new UM_metaWebserviceMinervaZentiveCom.upgradePackageList ();
                                            upList.upgradePackage= upgradePkgList;


                                            UM_metaWebserviceMinervaZentiveCom.orderDetails orDet = new UM_metaWebserviceMinervaZentiveCom.orderDetails();
                                            orDet.upgradePackages= upList;

                                            param.OrderDetails = orDet;
                               }

                           if(upcServiceListMap.values().isempty() || upcServiceListMap==null || upcServiceListMap.values()==null || upcServiceListMap.isEmpty() )
                        {
                                system.debug('****packagName  : NoPackagelist since its Terminate');
                                List<csord__Service__c> terminatedServiceList =new  List<csord__Service__c>([select Id,UM_DependsOnService__r.LG_ProvisioningAccountNo__c,csord__Activation_Date__c, LG_Action__c,csord__Status__c, LG_ProvisioningCode__c, csord__Service__c, LG_ProvisioningAccountNo__c, UM_DependsOnService__c from csord__Service__c where LG_Suborder__c = :currentSolution.Id ]);
                                for(csord__Service__c ser:terminatedServiceList )
                                {        if (ser.LG_ProvisioningAccountNo__c!= null)
                                         {
                                             param.AccountNumber = ser.LG_ProvisioningAccountNo__c;
                                         }
                                         else if (ser.UM_DependsOnService__c != null && ser.UM_DependsOnService__r.LG_ProvisioningAccountNo__c!=null)
                                          {

                                            param.AccountNumber = ser.UM_DependsOnService__r.LG_ProvisioningAccountNo__c;
                                             }
                                }
                                UM_metaWebserviceMinervaZentiveCom.upgradePackage upgradePkg = new UM_metaWebserviceMinervaZentiveCom.upgradePackage ();
                                            //upgradePkg.upcList =  upcle ;
                                            upgradePkg.serviceGroup='B';
                                            upgradePkg.id='1';
                              //param.buildingId = add;
                                            param.region = currentSolution.LG_Address__r.cscrm__State_Province__c;

                         }


                   }
       }

        //set systemLetterPreference and commercialRegister
        param.systemLetterPreference = 'BOTH';
            if(String.isNotBlank(accList.LG_ChamberOfCommerceNumber__c)){
        param.commercialRegister = accList.LG_ChamberOfCommerceNumber__c;
            }
            else{
                param.commercialRegister = 'DUMHR99';
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

        try {
            system.debug('111111==' + connection.Authentication_Token__c);
            system.debug('22222-=' + param);
            //call place order method with param and auth values
            res = pbWebservice.placeOrder(param, connection.Authentication_Token__c);
            system.debug('res--' + JSON.serializePretty(res));
            system.debug('res.transactionId==' + res.transactionId);
            Msg = String.valueOf(res.success);

            //update based on result

            } catch (Exception e) {
            Msg= e.getMessage();
            system.debug('error in Cama class==' + e.getMessage());

        }
              
            if (Msg.equalsIgnoreCase('true')) {

                currentSolution.LG_Integration_Status__c = 'Request Acknowledged';
                currentSolution.LG_Integration_Description__c = 'Success ';
                    if(pAcctno!=null && packagName=='Upgrade' && currentSolution.LG_ProvisioningAccountNo__c==null){
                    currentSolution.LG_ProvisioningAccountNo__c=pAcctno;
                    }
                currentSolution.LG_Provisioning_External_Id__c = String.valueOf(UM_PlaceOrder.res.transactionId);
                    counter = counter++;
                    currentSolution.UM_No_of_Tries__c = counter;
                update currentSolution;


            } else {
                system.debug('in else loop it has failed');

                currentSolution.LG_Integration_Status__c = 'Middleware Request Failed';
                     if(pAcctno!=null && packagName=='Upgrade' && currentSolution.LG_ProvisioningAccountNo__c==null){
                    currentSolution.LG_ProvisioningAccountNo__c=pAcctno;
                    }
                currentSolution.LG_Integration_Description__c = 'Spider ' + UM_PlaceOrder.res.errorMessage;
                Msg = UM_PlaceOrder.res.errorMessage;
                    counter = counter++;
                    currentSolution.UM_No_of_Tries__c = counter;
                update currentSolution;
                //re run create order if counter <no of tries
                    if (counter >connection.UM_No_of_Tries__c) {
                    Msg='Tries Exceeded';
                        system.debug('in else loop it has exceeded no. of retries');

                    for (csord__Solution__c sol : currentSolutions) {

                        sol.LG_Jeopardy__c = true;
                        sol.Jeopardy_Reason__c = 'MiddleWare Timeout';
                        sol.LG_JeopardyExplanation__c = Label.LG_Orch_Retries_Error;
                        updatedSolutions.add(sol);
                    }

                    update updatedSolutions;
                    system.debug('updatedSolution==' + updatedSolutions);

                }
               }
            system.debug('currentSolution==' + currentSolution);
            system.debug('Final result==' + Msg);
            system.debug('errorCode==' + UM_PlaceOrder.res.errorCode);
            system.debug('errorMsg==' + UM_PlaceOrder.res.errorMessage);
    
        return Msg;

    }
       
}