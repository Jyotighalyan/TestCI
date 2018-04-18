/**
* TODO: ApexDoc.
*/
public class KenanDataConnection extends DataSource.Connection {

	public override List<DataSource.Table> sync(){       
        List<DataSource.Table> tables = KenanDataConnectionObjects.getTables();
        
        return tables;
    }

    public override DataSource.TableResult query(DataSource.QueryContext context){
        KenanServiceInterface service = getService(context.TableSelection.tableSelected);
        return service.query(context);
    }

    public override List<DataSource.TableResult> search(DataSource.SearchContext context){
        List<DataSource.TableResult> searchResults = new List<DataSource.TableResult>();
        String searchPhrase = context.searchPhrase;
        for (DataSource.TableSelection selection : context.tableSelections){
            KenanServiceInterface service = getService(selection.tableSelected);
            searchResults.add(service.search(selection, searchPhrase));    
        }
        return searchResults;
    }
    
    public override List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
        system.debug('upsertRows context:' + context);
        KenanServiceInterface service = getService(context.tableSelected);
        List<DataSource.UpsertResult> results = new List<DataSource.UpsertResult>();
        results = service.upsertRows(context);
        
        return results;
    }
    
    
    public override List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
        KenanServiceInterface service = getService(context.tableSelected);
        List<DataSource.DeleteResult> results = new List<DataSource.DeleteResult>();
        results = service.deleteRows(context);
        return results;
    }

    private KenanServiceInterface getService(String tableName){
        String externalTableName = tableName.remove('__x');
        External_Data_Service__mdt extDataService = [SELECT Apex_Service_Class__c FROM External_Data_Service__mdt WHERE DeveloperName = :externalTableName LIMIT 1];
        KenanServiceInterface service = (KenanServiceInterface) Type.forName(extDataService.Apex_Service_Class__c).newInstance();
        return service;
    }

}