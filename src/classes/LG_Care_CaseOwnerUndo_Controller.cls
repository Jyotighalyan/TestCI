public class LG_Care_CaseOwnerUndo_Controller {
    public List<Case> caseList {get;set;}
    public List<caseWrapper> caseWrapperList {get;set;}
    private Id currentUserId {get;set;}
        
    public LG_Care_CaseOwnerUndo_Controller(){
        currentUserId = UserInfo.getUserId();
        
        findcases();
        
    }
    
    private void findcases()
    {
        
        List<UM_Care_Queue__mdt> listOfDevelopersmdt = new List<UM_Care_Queue__mdt>();
        List<string> listOfDeveloperNamesmdt = new List<string>();
        listOfDevelopersmdt = [SELECT Id, developername from UM_Care_Queue__mdt];
        for(UM_Care_Queue__mdt ldv : listOfDevelopersmdt)
            {
                listOfDeveloperNamesmdt.add(String.ValueOf(ldv.DeveloperName));
            }
        
        List<group> listOfDeveloperNames = new List<group>();
        listOfDeveloperNames = [select id,name,developername from group where type = 'queue' and developername in :listOfDeveloperNamesmdt];
        
        List<string> listOfDeveloperNamesId = new List<string>();
        Map<Id,string> mapOfDeveloperNames = new Map<Id,string>();
        for(group ldn : listOfDeveloperNames)
            {
                listOfDeveloperNamesId.add(ldn.id);
                mapOfDeveloperNames.put(String.ValueOf(ldn.id),String.ValueOf(ldn.name));
            }
        
        list<User> listOfUsers = new List<User>();
        listOfUsers = [select id, name from user];
        
        
        List<string> listOfUserId = new List<string>();
        Map<Id,string> mapOfUser = new Map<Id,string>();
        for(User lu : listOfUsers)
        {
            listOfUserId.add(lu.id);
            mapOfUser.put(String.ValueOf(lu.id),String.valueOf(lu.name));
        }
        
        
        
        List<string> developerUserList = new List<string>();
        for(string i : listOfDeveloperNamesId)
        {
            developerUserList.add(i);
            
        }
        
        for(string j : listOfUserId)
        {
           developerUserList.add(j); 
        }
        
        
        
        List<case> modifiedCasesList = new List<case>();
        
        modifiedCasesList = [select id, casenumber,status,CreatedDate,LastModifiedDate from case where lastModifiedById =: currentUserId order by casenumber desc];
        
        List<string> modifiedCasesIdList = new List<string>();
        
        for(case mcl : modifiedCasesList)
            {
                if(String.ValueOf(mcl.Status) != 'Closed' && String.ValueOf(mcl.Status) != 'Resolved')
                {
                    modifiedCasesIdList.add(mcl.id);
                }
                
            }
                    
        List<casehistory> caseHistoryList = new List<casehistory>();
        
        caseHistoryList = [select CaseId, OldValue, NewValue from CaseHistory where caseid in :modifiedCasesIdList order by createddate desc];
        
        List<casehistory> semiFilteredCaseHistorylist = new List<casehistory>();
        List<string> semiFilteredCaseHistoryIdlist = new List<string>();
        Set<string> semiFilteredCaseHistoryIdSet = new Set<string>();
        List<string> semiFilteredCaseHistoryIdlistFinal = new List<string>();
        List<casehistory> filteredCaseHistorylist = new List<casehistory>();
        List<casehistory> filteredCaseHistorylistFinal = new List<casehistory>();
        
        for(casehistory chl : caseHistoryList)
        {   
            
            if((chl.caseId!=null && chl.OldValue!=null && chl.NewValue!=null) && (String.ValueOf(chl.OldValue).startsWith('00G') || String.ValueOf(chl.OldValue).startsWith('005')) && (String.ValueOf(chl.NewValue).startsWith('00G') || String.ValueOf(chl.NewValue).startsWith('005')))
            {
                semiFilteredCaseHistorylist.add(chl);
                semiFilteredCaseHistoryIdlist.add(chl.CaseId);
            }
            
        }  
        
        semiFilteredCaseHistoryIdSet.addAll(semiFilteredCaseHistoryIdlist);
        semiFilteredCaseHistoryIdlistFinal.addAll(semiFilteredCaseHistoryIdSet);
        
        for(string sfchilf : semiFilteredCaseHistoryIdlistFinal)
        {  
            Integer counter = 0;
            for(casehistory sfchl : semiFilteredCaseHistorylist)
            {
                if(sfchl.CaseId == sfchilf && counter == 0)
                {   
                    counter = counter + 1;
                    filteredCaseHistorylist.add(sfchl);
                }
                
            }
            
        }
        
        for(casehistory fchls: filteredCaseHistorylist)
        {
            if(String.ValueOf(fchls.OldValue).startsWith('00G') && (String.ValueOf(fchls.NewValue).startsWith('005')||String.ValueOf(fchls.NewValue).startsWith('00G')))
            {
                filteredCaseHistorylistFinal.add(fchls);
            }
        }
        
        Map<Id, Case> caseIdMap = new Map<Id, Case>();
        
        for(Case cim : [select Id, CaseNumber from Case where id in : semiFilteredCaseHistoryIdlistFinal])
        {
            caseIdMap.put(cim.Id, cim);
        }
        
        Map<Id, String> caseIdCreatedMap = new Map<Id, String>();
        for(Case cicm : [select Id, CreatedDate from Case where id in : semiFilteredCaseHistoryIdlistFinal])
        {
            caseIdCreatedMap.put(cicm.Id, String.ValueOf(cicm.CreatedDate));
        }
        
        Map<Id, String> caseIdModifiedMap = new Map<Id, String>();
        for(Case cimm : [select Id, LastModifiedDate from Case where id in : semiFilteredCaseHistoryIdlistFinal])
        {
            caseIdModifiedMap.put(cimm.Id, String.ValueOf(cimm.LastModifiedDate));
        }
        
        caseWrapperList = new List<caseWrapper>();
        for(casehistory fchl : filteredCaseHistorylistFinal)
            {
                for(string i : developerUserList)
                {
                    if(String.valueOf(fchl.OldValue) == i && String.valueOf(fchl.OldValue) != String.valueOf(fchl.NewValue))
                    {
                        caseWrapper wrapper = new caseWrapper();
                        
                        wrapper.selected = false;
                        
                        List<Case> tempListForCaseObject = new List<Case>();
                        tempListForCaseObject.add(caseIdMap.get(fchl.CaseId));
                        List<case> caseobject = tempListForCaseObject;
                        wrapper.caseObj = caseobject[0];
                        
                        wrapper.oldOwnerId = String.valueOf(fchl.OldValue);
                        
                        if(String.ValueOf(fchl.OldValue).startsWith('00G'))
                        {
                            
                            wrapper.oldOwner = mapOfDeveloperNames.get(String.ValueOf(fchl.OldValue));
                        
                        }
                        
                        else if(String.ValueOf(fchl.OldValue).startsWith('005'))
                        {
                            wrapper.oldOwner = mapOfUser.get(String.ValueOf(fchl.OldValue));
                        }
                        
                        
                        if(String.ValueOf(fchl.NewValue).startsWith('00G'))
                        {
                            wrapper.newOwner = mapOfDeveloperNames.get(String.ValueOf(fchl.NewValue));
                        }
                        
                        else if(String.ValueOf(fchl.NewValue).startsWith('005')) 
                        {
                            wrapper.newOwner = mapOfUser.get(String.ValueOf(fchl.NewValue));
                        }
                        
                        
                        wrapper.CreatedDate = caseIdCreatedMap.get(String.ValueOf(fchl.caseId));
                        
                        wrapper.LastModifiedDate = caseIdModifiedMap.get(String.ValueOf(fchl.caseId));
                        
                        caseWrapperList.add(wrapper);
                                               
                    }
                }
            }
       
    }
    
    
    public void undoCaseOwner(){
        List<case> caseUndoList = new List<case>();
        List<caseWrapper> caseWrapperListTemp = new List<caseWrapper>();
        
        for(caseWrapper wrapper : caseWrapperList){
            if(wrapper.selected == true){
                Case caseInstance = new Case();
                caseInstance.Id = wrapper.caseObj.Id;
                caseInstance.ownerId = wrapper.oldOwnerId;
                
                caseUndoList.add(caseInstance);
            }
            else{
                caseWrapperListTemp.add(wrapper);
            }
        }
        if(caseUndoList.size() > 0){
            update caseUndoList;
        }
        else if(caseUndoList.size() == 0)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.B2B_Care_vfPage_CaseUndo1));
        }
        
        caseWrapperList.clear();
        caseWrapperList.addAll(caseWrapperListTemp);
    }
    
    public class caseWrapper{
        public case caseObj {get;set;}
        public Boolean selected {get;set;}
        public String oldOwner {get;set;}
        public String oldOwnerId {get;set;}
        public String newOwner {get;set;}
        public String CreatedDate {get;set;}
        public String LastModifiedDate {get;set;}
    }
    
    
}