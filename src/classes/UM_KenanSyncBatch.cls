global class UM_KenanSyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    global String className;
    global String query;
    global list<sObject> records;
    
    global UM_KenanSyncBatch(list<sObject>pRecords,String pQuery, String pClassName){
        records = pRecords;
        className = pClassName;
        query = pQuery;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){        
        try{
            Type t = Type.forName(className);
            System.debug('*** className ='+className + ' and type t: '+t);
            if(t!=null){
                IServiceConnect sc = (IServiceConnect) t.newInstance();
                sc.execute(scope);
            }
        }catch (exception e){
            System.debug('*** Error: '+e.getMessage() + ' stack trace: '+e.getStackTraceString());
            LG_Util.SendAdminEmail(e,e.getStackTraceString());
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
    global interface IServiceConnect{
    	void execute(list<sObject> servicesList);            
    }                
    
}