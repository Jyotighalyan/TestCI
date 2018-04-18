/**
 * Build UI + process (OMB-125 Complex change)
 *
 * @author Petar Miletic
 * @ticket SFOM-431
 * @since  02/03/2017
*/
global with sharing class LG_ComplexChangeUtil {

	/*
	 * Start Complex Change
	*/
	webservice static String ComplexChange(Id recordId) {
        
        if (recordId == null) {
            throw new LG_Exception(Label.LG_ErrorInvalidRecordId);
        }
        
        String returnType = Label.LG_ErrorUnableComplexChange;
        
        ComplexChangeData data = new ComplexChangeData(recordId);
        
        if (data.isValid()) {
            //SFOM-1740 Bug Fix
            try {
                csord__Order__c order = new csord__Order__c();
                String objectType = String.valueOf(recordId.getSobjectType());
                if (objectType == 'Case') {
                    recordId = [SELECT Id, LG_Solution__r.csord__Order__c FROM Case WHERE Id = :recordId].LG_Solution__r.csord__Order__c;
                }
                order = [SELECT csord__Status2__c FROM csord__Order__c WHERE Id = :recordId];
                order.csord__Status2__c = 'Change Requested';
                update order;                              
            }        
            catch(QueryException ex) {
                system.debug(ex);
            }
            returnType = createNewOpportunity(data);
        } 
        
        return returnType;
    }
    @TestVisible
    private static String createNewOpportunity(ComplexChangeData data) {
    
        String retval = '';

        try {

            // Create new Opportunity, Product Basket and Product Configurations
            retval = csordtelcoa.API_V1.createMacOpportunityFromSubscriptions(data.subscriptions, data.changeType, data.opp.RecordTypeId, data.opp.Name, null);
            
            setVersioningData(retval, data);
            cloneNumbersAndRelatedRecords(retval, data);
            LG_ComplexChangeUtil.handleConfirmedRequestCases(data.opp);

        } catch (Exception ex) {
            
            System.debug('ComplexChange -> createNewOpportunity: ' + ex.getMessage());
            return retval = Label.LG_ErrorChangeProcessing;
        }

        // Return new Opp Id for redirect
        return retval;
    }
    
    /*
     * Set versioning data
    */
    @TestVisible
    private static void setVersioningData(Id newOpportuntiyId, ComplexChangeData data) {
        
        // Query for new Opportunity
        Opportunity oppNew = [SELECT Id, LG_Version__c, 
                                    LG_ActiveVersion__c, 
                                    LG_OlderVersion__c, 
                                    LG_SoftDeleted__c, 
                                    csordtelcoa__Change_Type__c 
                                FROM Opportunity 
                                WHERE Id = :newOpportuntiyId];

        Opportunity oppOld = data.opp;
        oppOld.LG_SoftDeleted__c = true;
        oppOld.LG_ActiveVersion__c = false;
        oppOld.LG_NewerVersion__c = newOpportuntiyId;
        
        if (oppOld.LG_Version__c == null) {
            oppOld.LG_Version__c = 1;    
        }
        
        // Update versioning data on new Opportunity
        oppNew.LG_SoftDeleted__c = false;
        oppNew.LG_ActiveVersion__c = true;
        oppNew.LG_Version__c = oppOld.LG_Version__c + 1;
        oppNew.LG_OlderVersion__c = oppOld.Id;

        if (String.isNotBlank(oppOld.csordtelcoa__Change_Type__c)) {

        oppNew.csordtelcoa__Change_Type__c = oppOld.csordtelcoa__Change_Type__c;
        
        List<cscfga__Product_Basket__c> baskets = [SELECT Id, csordtelcoa__Change_Type__c 
                                                    FROM cscfga__Product_Basket__c 
                                                    WHERE cscfga__Opportunity__c = :newOpportuntiyId];

        for (cscfga__Product_Basket__c basket :baskets) {
            basket.csordtelcoa__Change_Type__c = oppOld.csordtelcoa__Change_Type__c;
        }

        if (!baskets.isEmpty()) {
            update baskets;
        }
        }

        // Soft delete Subscriptions and Services
        for (csord__Subscription__c obj :data.subscriptions) {
            obj.LG_SoftDeleted__c = true;
        }
        
        for (csord__Service__c obj :data.services) {
            obj.LG_SoftDeleted__c = true;
        }
        
        update data.subscriptions;
        update data.services;

        // Bulkify
        List<Opportunity> opportunities = new List<Opportunity> { oppOld, oppNew };

        // Update data
        update opportunities;
    }
    
    /**
     * Complex Change Cancelled
     *
     * @author Petar Miletic
     * @ticket SFOM-433
     * @since  06/07/2017
    */
    webservice static String cancelComplexChange(Id recordId) {
        
        if (recordId == null) {
            throw new LG_Exception(Label.LG_ErrorInvalidRecordId);
        }

        try {

            Opportunity obj = [SELECT Id, Name,
                                LG_Version__c,
                                LG_ActiveVersion__c,
                                LG_NewerVersion__c,
                                LG_SoftDeleted__c,
                                LG_OlderVersion__r.LG_Version__c,
                                LG_OlderVersion__r.LG_ActiveVersion__c,
                                LG_OlderVersion__r.OwnerId
                            FROM Opportunity 
                            WHERE Id = :recordId LIMIT 1];
                            
            // Mark latest Opportunity as inactive
            obj.LG_ActiveVersion__c = false;
            obj.LG_SoftDeleted__c = true;
            
            // Set older version as active
            Opportunity objOld = obj.LG_OlderVersion__r;
            objOld.LG_ActiveVersion__c = true;
            objOld.LG_SoftDeleted__c = false;
            
            /**
             * Conversion of Complex to Cancel Change - Cancel Case Handling
             * 
             * The automatically created Complex Change will be assigned to the same user who hit the button from Cancel Request screen
             *
             * @author Petar Miletic
             * @ticket SFOM-704
             * @since  08/05/2017
            */
            objOld.OwnerId = UserInfo.getUserId();
            
            // Update Opportunities
            Map<Id, Opportunity> objs = new Map<Id, Opportunity>();
            objs.put(obj.Id, obj);
            objs.put(objOld.Id, objOld);
            
            update objs.values();
            
            Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>();
            Map<Id, csord__Subscription__c> subscriptions = new Map<Id, csord__Subscription__c>();

            List<csord__Service__c> services = [SELECT 
                                                    Id, 
                                                    Name, 
                                                    LG_SoftDeleted__c,
                                                    csord__Subscription__c, 
                                                    csord__Subscription__r.LG_SoftDeleted__c,
                                                    csord__Order__c, 
                                                    LG_RootOrder__c,
                                                    LG_RootOrder__r.LG_SoftDeleted__c,
                                                    LG_RootOrder__r.csordtelcoa__Opportunity__c,
                                                    csord__Subscription__r.csord__Order__c
                                                FROM csord__Service__c
                                                WHERE LG_RootOrder__r.csordtelcoa__Opportunity__c IN :objs.keySet()];
                                                
            for (csord__Service__c item :services)  {

                csord__Order__c ord = item.LG_RootOrder__r;
                csord__Subscription__c sub = item.csord__Subscription__r;
                
                //SFOM-1740 Bug Fix
                ord.csord__Status2__c = 'Order Submitted';
                
                if (item.LG_RootOrder__r.csordtelcoa__Opportunity__c == objOld.Id) {
                    
                    // Activate Service
                    item.LG_SoftDeleted__c = false;
                    
                    // Activate Order
                    ord.LG_SoftDeleted__c = false;
                    orders.put(ord.Id, ord);
                    
                    // Activate Subscription
                    sub.LG_SoftDeleted__c = false;
                    subscriptions.put(sub.Id, sub);
            
                } else {
                    
                    // Deactivate Service
                    item.LG_SoftDeleted__c = true;
                    
                    // Deactivate Order
                    ord.LG_SoftDeleted__c = true;
                    orders.put(ord.Id, ord);
                    
                    // Deactivate Subscription
                    sub.LG_SoftDeleted__c = true;
                    subscriptions.put(sub.Id, sub);                  
                }
            }
            
            update orders.values();
            update subscriptions.values();
            update services;
                        
            //SFOM-376 Resume orchestration process
            LG_ResumePauseOrchestrator.cancelComplexChange(recordId);
            LG_ComplexChangeUtil.handleCancelRequestCases(objOld);
            
            sendNotificationEmail(objOld);
            
            return 'Success';

        } catch (Exception ex) {
            
            System.debug('ComplexChange -> createNewOpportunity: ' + ex.getMessage());
            return Label.LG_ErrorChangeProcessing;
        }
    }
    
    /**
     * Remap numbers to active version  
     *
     * @author Petar Miletic
     * @ticket SFOM-498
     * @since  20/03/2017
    */  
    @TestVisible
    private static void cloneNumbersAndRelatedRecords(Id newOpportuntiyId, ComplexChangeData data) {
        
        String[] types = new String[]{ 'Asset', 'LG_AssetProcessAssociation__c', 'LG_PortingProcess__c', 'LG_ProcessRequest__c' };
        
        Map<String, Set<String>> fieldMap = LG_ReflectionUtil.getObjectFieldsMap(types);

        String columnsAA = LG_ReflectionUtil.getColumns(fieldMap.get('LG_AssetProcessAssociation__c'), '');
        String columnsAs = LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), 'LG_Asset__r');
        String columnsPP = LG_ReflectionUtil.getColumns(fieldMap.get('LG_PortingProcess__c'), 'LG_Process__r');
        
        Id oppId = data.opp.Id;
        
        Map<Id, Asset> newAssets = new Map<Id, Asset>();
        
        // Get new Product Configurations
        List<cscfga__Product_Configuration__c> productConfigurations = [SELECT Id, 
                                                                            Name,
                                                                            csordtelcoa__Replaced_Product_Configuration__c,
                                                                            cscfga__Product_Basket__r.cscfga__Opportunity__c
                                                                        FROM cscfga__Product_Configuration__c 
                                                                        WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c = :newOpportuntiyId];
                                                                        
        List<Asset> assets = Database.query('SELECT ' + LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), '') + ' FROM Asset WHERE LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oppId OR LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oppId');

        // Prepare Asset Process Associations
        for (Asset obj :assets) {
            
            if (!newAssets.containsKey(obj.Id)) {
                Asset clone = obj.clone(false, true, false, false);
                
                 for (cscfga__Product_Configuration__c pc :productConfigurations) {
    
                    // If old PC is equal to replaced PC then update
                    if (obj.LG_TelephonyProductConfiguration__c == pc.csordtelcoa__Replaced_Product_Configuration__c) {
                        clone.LG_TelephonyProductConfiguration__c = pc.Id;
                    }
                    
                    if (obj.LG_NumberRangeProductConfiguration__c == pc.csordtelcoa__Replaced_Product_Configuration__c) {
                        clone.LG_NumberRangeProductConfiguration__c = pc.Id;
                    }
                }
                
                newAssets.put(obj.Id, clone);
            }
        }

        if (!newAssets.isEmpty()) {
            insert newAssets.values();
        }

        /**
         * Query is expanded to use LG_NumberRangeProductConfiguration__c as well
         *
         * @author Petar Miletic
         * @ticket SFOM-689
         * @since  28/04/2017
        */ 
        String columns = columnsAA + ', ' + columnsAs + ', ' + columnsPP;
        List<LG_AssetProcessAssociation__c> assetAssociations = Database.query('SELECT ' + columns + ' FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oppId OR LG_Asset__r.LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oppId');
        
        if (!assetAssociations.isEmpty()) {

            // Prepare data for cloning
            Map<Id, LG_PortingProcess__c> newPortingProcesses = new Map<Id, LG_PortingProcess__c>();

            // Prepare Asset Process Associations
        for (LG_AssetProcessAssociation__c obj :assetAssociations) {
                
                if (!newPortingProcesses.containsKey(obj.LG_Process__c)) {
                newPortingProcesses.put(obj.LG_Process__c, obj.LG_Process__r.clone(false, true, false, false));
            }
            }
            
            Set<Id> Ids = newPortingProcesses.keySet();
            
            // Get Process Requests
            String processRequestColumns = LG_ReflectionUtil.getColumns(fieldMap.get('LG_ProcessRequest__c'), '');
            List<LG_ProcessRequest__c> processRequests = Database.query('SELECT ' + processRequestColumns + ' FROM LG_ProcessRequest__c WHERE LG_Process__c IN :Ids');
            
            insert newPortingProcesses.values();

            // Clone junction
            List<LG_AssetProcessAssociation__c> newAssetAssociations = assetAssociations.deepClone(false, false, false);
            
            // Remap old Assets to new Asset Ids
            for (Id key :newAssets.keySet()) {
    
                Asset tmp = newAssets.get(key);
    
                // Remap associations
                for (LG_AssetProcessAssociation__c newAssociation :newAssetAssociations) {
                    
                    if (newAssociation.LG_Asset__c == key) {
                        newAssociation.LG_Asset__c = tmp.Id;
                    } 
                }
            }
            
            // Prepare list for new requests
            List<LG_ProcessRequest__c> newProcessRequests = new List<LG_ProcessRequest__c>();
            
            // Remap old Processes to new Process Ids
            for (Id key :newPortingProcesses.keySet()) {
    
                LG_PortingProcess__c tmp = newPortingProcesses.get(key);
    
                // Remap associations
                for (LG_AssetProcessAssociation__c newAssociation :newAssetAssociations) {
                    
                    if (newAssociation.LG_Process__c == key) {
                        newAssociation.LG_Process__c = tmp.Id;
                    } 
                }
                
                for (LG_ProcessRequest__c pr :processRequests) {
                    
                    LG_ProcessRequest__c newPR = pr.clone(false, true, false, false);
                    
                    if (newPR.LG_Process__c == key) {
                        newPR.LG_Process__c = tmp.Id;
                        
                        newProcessRequests.add(newPR);
                    }
                }
            }
            
            // Insert new junction object
            insert newAssetAssociations;
        
            // Insert requests
            insert newProcessRequests;
        }
    }
    
    /**
     * Resolved notification bug
     *
     * @author Petar Miletic
     * @ticket SFOM-520
     * @since  23/03/2017
    */
    
    public static void sendNotificationEmail(Opportunity opp) {
        
        csord__Order__c ord = [SELECT Id, Name, csord__Order_Number__c, OwnerId, Owner.Id, Owner.Name, Owner.LastName, Owner.Email FROM csord__Order__c WHERE csordtelcoa__Opportunity__c = :opp.Id LIMIT 1];
        
        if (ord != null) {

            EmailTemplate template = [SELECT Id, Name FROM EmailTemplate WHERE Name = 'Complex Change Notification' LIMIT 1];

            try {

                // setWhatId requires Contact. Owner does not work
                Contact tmp = new Contact(email = ord.Owner.Email, firstName = ord.Owner.Name, lastName = ord.Owner.LastName);
                insert tmp;

                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(tmp.Id);
                message.setWhatId(ord.Id);
                message.setTemplateId(template.Id);

                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                
                /// Celan up Contact
                delete tmp;
                
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
                
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }
        }
    }
    
    /**
     * Conversion of Complex to Cancel Change - Cancel Case Handling
     * 
     * When the Complex Change is confirmed, it will automatically find the Cancel Request related to the same Order / Opportunity and close it.
     *
     * @author Petar Miletic
     * @ticket SFOM-704
     * @since  08/05/2017
    */
    public static void handleConfirmedRequestCases(Opportunity opp) {
        
        Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>([SELECT Id 
                                                                            FROM csord__Order__c 
                                                                            WHERE csordtelcoa__Opportunity__c = :opp.Id]);

        List<Case> cases = LG_ComplexChangeUtil.getCasesForStatus(new Set<Id> { opp.Id }, orders.keySet(), new List<String> { 'New' });
        
        /*
         * System will create a comment on the Cancel Request "Complex Change [number] was raised by [name] on [date]
        */
        String userName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        List<CaseComment> comments = new List<CaseComment>();

        Integer versionNumber = Integer.valueOf(opp.LG_Version__c) + 1;

        for (Case obj :cases) {
            
            obj.Status = 'On Hold';

            CaseComment comment = new CaseComment();
            comment.ParentId = obj.Id;
            comment.CommentBody = 'Complex Change ' + versionNumber + ' was raised by ' + userName  +  ' on ' + Date.today().format() + ', Cancel Request put on hold.';
            
            comments.add(comment);
        }
        
        if (!cases.isEmpty()) {
            update cases;
            insert comments;
        }
    }
    
    /**
     * Conversion of Complex to Cancel Change - Cancel Case Handling
     * 
     * When the Complex Change is cancelled, it will automatically find the Cancel Request related to the same Order / Opportunity and reopen it.
     *
     * @author Petar Miletic
     * @ticket SFOM-704
     * @since  08/05/2017
    */
    public static void handleCancelRequestCases(Opportunity opp) {
        
        Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>([SELECT Id 
                                                                            FROM csord__Order__c 
                                                                            WHERE csordtelcoa__Opportunity__c = :opp.Id]);

        List<Case> cases = LG_ComplexChangeUtil.getCasesForStatus(new Set<Id> { opp.Id }, orders.keySet(), new List<String> { 'Closed', 'On Hold' });
        
        for (Case obj :cases) {
            
            obj.Status = 'New';
        }
        
        if (!cases.isEmpty()) {
            update cases;
        }
    }
    
    /**
     * Conversion of Complex to Cancel Change - Cancel Case Handling
     * 
     * When the Complex Change is commited, it will automatically find the Cancel Request related to the same Order / Opportunity and close it.
     *
     * @author Petar Miletic
     * @ticket SFOM-704
     * @since  08/05/2017
    */
    public static void handleCloseRequestCases(Set<Id> opportunityIds) {
        
        Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>([SELECT Id 
                                                                            FROM csord__Order__c 
                                                                            WHERE csordtelcoa__Opportunity__c IN :opportunityIds]);

        List<Case> cases = LG_ComplexChangeUtil.getCasesForStatus(opportunityIds, orders.keySet(), new List<String> { 'New', 'On Hold' });
        
        for (Case obj :cases) {
            
            obj.Status = 'Closed';
        }
        
        if (!cases.isEmpty()) {
            update cases;
        }
    }
    
    /**
     * Get Cases for Order / Opportunity with statuses in list of statuses
     *
     * @author Petar Miletic
     * @ticket SFOM-704
     * @since  08/05/2017
    */
    private static List<Case> getCasesForStatus(Set<Id> opportuntiyIds, Set<Id> ordersIds, List<String> status) {
        
        return [SELECT Id, Status, LG_Opportunity__c, LG_Order__c 
                                FROM CASE 
                                WHERE RecordType.Name IN ('Order Cancel Request') AND 
                                    (LG_Opportunity__c IN :opportuntiyIds OR 
                                        LG_Order__c = :ordersIds) AND
                                        Status IN :status];
    }
    
    /*
     * Encapsulates Opportunity data and related Order -> Subscriptions
    */
    @TestVisible
    private class ComplexChangeData {
        
        public Opportunity opp { get; set; }
        public csordtelcoa__Change_Types__c changeType { get; set; } 
        public List<csord__Subscription__c> subscriptions { get; set; }
        public List<csord__Service__c> services { get; set; }
        public List<cscfga__Product_Configuration__c> productConfigurations { get; set; }
        
        public ComplexChangeData(Id recordId) {
            
            changeType = csordtelcoa__Change_Types__c.getAll().get('Clone');
            
            String returnType = '';
            String objectType = String.valueOf(recordId.getSobjectType());
            
            if (objectType == 'Case') {
                returnType = objectType;
                
                getChangeDataForCaseId(recordId);
            } 
            else if (objectType == 'csord__Order__c') {
                returnType = objectType;
                
                getChangeDataForOrderId(recordId);
            } 
            else {
                throw new LG_Exception(Label.LG_UnsupportedRecordId);
            }
        }
        
        // Is valid, all items must be populated
        public Boolean isValid() {
            return (opp != null && subscriptions.size() > 0);
        }

        /*
         * Get change data using Case Id
        */
        private void getChangeDataForCaseId(Id recordId) {
            
            /**
             * Resolved List has no rows for assignment to SObject bug
             * Query is expanded to query data via Order and Opportunity
             *
             * @author Petar Miletic
             * @ticket SFOM-660
             * @since  07/04/2017
            */
            List<Case> objs = [SELECT Id, 
                                LG_Opportunity__c,
                                LG_Opportunity__r.RecordTypeId,
                                LG_Opportunity__r.Name,
                                LG_Opportunity__r.LG_Version__c,
                                LG_Opportunity__r.LG_ActiveVersion__c,
                                LG_Opportunity__r.LG_OlderVersion__c,
                                LG_Opportunity__r.LG_NewerVersion__c,
                                LG_Opportunity__r.LG_SoftDeleted__c,
                                LG_Opportunity__r.csordtelcoa__Change_Type__c,
                                LG_Order__c, 
                                LG_Order__r.csordtelcoa__Opportunity__c,
                                LG_Order__r.csordtelcoa__Opportunity__r.RecordTypeId,
                                LG_Order__r.csordtelcoa__Opportunity__r.Name,
                                LG_Order__r.csordtelcoa__Opportunity__r.LG_Version__c,
                                LG_Order__r.csordtelcoa__Opportunity__r.LG_ActiveVersion__c,
                                LG_Order__r.csordtelcoa__Opportunity__r.LG_OlderVersion__c,
                                LG_Order__r.csordtelcoa__Opportunity__r.LG_NewerVersion__c,
                                LG_Order__r.csordtelcoa__Opportunity__r.LG_SoftDeleted__c,
                                LG_Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,
                                LG_Solution__c, 
                                LG_Solution__r.csord__Order__c,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__c,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.RecordTypeId,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.Name,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_Version__c,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_ActiveVersion__c,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_OlderVersion__c,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_NewerVersion__c,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_SoftDeleted__c,
                                LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c
                            FROM Case 
                            WHERE Id = :recordId AND RecordType.Name IN ('Jeopardy', 'Inflight Cancel', 'Order Cancel Request') LIMIT 1];
            
            /**
             * Resolved List has no rows for assignment to SObject bug
             *
             * @author Petar Miletic
             * @ticket SFOM-604
             * @since  18/04/2017
            */
            Case obj = null;

            if (!objs.isEmpty()) {
                obj = objs[0];
            }
            
            if (obj != null && obj.LG_Opportunity__c != null) {
                
                this.opp = obj.LG_Opportunity__r;
                this.decomposeRelatedData(getRelatedOpportunityRecords(obj.LG_Opportunity__c));
                
            } else if (obj != null &&
                       obj.LG_Order__c != null && 
                       obj.LG_Order__r.csordtelcoa__Opportunity__c != null) {
                
                this.opp = obj.LG_Order__r.csordtelcoa__Opportunity__r;
                this.decomposeRelatedData(getRelatedRecords(obj.LG_Order__c));

            } else if (obj != null && obj.LG_Solution__r != null && obj.LG_Solution__r.csord__Order__r != null && obj.LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__c != null) {

                this.opp = obj.LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r;
                this.decomposeRelatedData(getRelatedRecords(obj.LG_Solution__r.csord__Order__c));
            }
        }
        
        /*
         * Get change data using Order Id
        */
        private void getChangeDataForOrderId(Id recordId) {
            
            // Get Opportunity data by querying Order object
            List<csord__Order__c> objs = [SELECT Id, 
                                        csordtelcoa__Opportunity__c,
                                        csordtelcoa__Opportunity__r.RecordTypeId,
                                        csordtelcoa__Opportunity__r.Name,
                                        csordtelcoa__Opportunity__r.LG_Version__c,
                                        csordtelcoa__Opportunity__r.LG_ActiveVersion__c,
                                        csordtelcoa__Opportunity__r.LG_OlderVersion__c,
                                        csordtelcoa__Opportunity__r.LG_NewerVersion__c,
                                        csordtelcoa__Opportunity__r.LG_SoftDeleted__c,
                                        csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c
                                    FROM csord__Order__c 
                                    WHERE Id = :recordId LIMIT 1];
            
            /**
             * Resolved List has no rows for assignment to SObject bug
             *
             * @author Petar Miletic
             * @ticket SFOM-604
             * @since  18/04/2017
            */
            csord__Order__c obj = null;
            
            if (!objs.isEmpty()) {
                obj = objs[0];
            }
            
            if (obj != null && obj.csordtelcoa__Opportunity__c != null) {
                
                this.opp = obj.csordtelcoa__Opportunity__r;
                
                this.decomposeRelatedData(getRelatedRecords(obj.Id));
            }
        }
        
        /*
         * Retrieve Subscriptions data by Order Id
        */
        private List<csord__Service__c> getRelatedRecords(Id recordId) {
            
            if (String.valueOf(recordId.getSobjectType()) != 'csord__Order__c') {
                throw new LG_Exception(Label.LG_ErrorInvalidRecordId);
            } 
            
            return [SELECT Id, 
                        Name,
                        LG_SoftDeleted__c,
                        csord__Subscription__r.Id, 
                        csord__Subscription__r.Name, 
                        csord__Subscription__r.csord__Account__c,
                        csord__Subscription__r.LG_SoftDeleted__c,
                        csordtelcoa__Product_Configuration__c, 
                        csordtelcoa__Product_Configuration__r.Name
                    FROM csord__Service__c 
                    WHERE csord__Subscription__r.csord__Order__c = :recordId];
        }
        
        private List<csord__Service__c> getRelatedOpportunityRecords(Id recordId) {
            
            if (String.valueOf(recordId.getSobjectType()) != 'Opportunity') {
                throw new LG_Exception(Label.LG_ErrorInvalidRecordId);
            } 
            
            return [SELECT Id, 
                        Name,
                        LG_SoftDeleted__c,
                        csord__Subscription__r.Id, 
                        csord__Subscription__r.Name, 
                        csord__Subscription__r.csord__Account__c,
                        csord__Subscription__r.LG_SoftDeleted__c,
                        csordtelcoa__Product_Configuration__c, 
                        csordtelcoa__Product_Configuration__r.Name
                    FROM csord__Service__c 
                    WHERE csord__Subscription__r.csord__Order__r.csordtelcoa__Opportunity__c = :recordId];
        }
        
        private void decomposeRelatedData(List<csord__Service__c> services) {
            
            Set<csord__Subscription__c> suSet = new Set<csord__Subscription__c>();
            Set<cscfga__Product_Configuration__c> pcSet = new Set<cscfga__Product_Configuration__c>();
            
            for (csord__Service__c obj :services) {
                
                suSet.add(obj.csord__Subscription__r);
                pcSet.add(obj.csordtelcoa__Product_Configuration__r);
            }
            
            this.subscriptions = new List<csord__Subscription__c>(suSet);
            this.services = services;
            this.productConfigurations = new List<cscfga__Product_Configuration__c>(pcSet);
        }
    }
}