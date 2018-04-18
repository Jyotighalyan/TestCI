/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Service Interface is the defined Interface all Kenan Services must implement.
*/
public interface KenanServiceInterface {

	/**
	* Accepts a QueryContext to retrieve data from the Kenan API 
	* @param context DataSource.QueryContext
	* @return DataSource.TableResult with the results from the API
	*/
    DataSource.TableResult query(DataSource.QueryContext context);

	/**
	* Accepts a Table Description and a Search Phrase to execute a search on the Kenan API
	* @param context DataSource.TableSelection
	* @param searchPhrase String
	* @return DataSource.TableResult with the results from the API
	*/
    DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase);

	/**
	* Accepts an UpsertContext to insert or update data via the Kenan API 
	* @param context DataSource.UpsertContext
	* @return DataSource.UpsertResult with the results from the API
	*/
    List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context);
    
    /**
	* Accepts a DeleteContext to delete data via the Kenan API 
	* @param context DataSource.DeleteContext
	* @return DataSource.DeleteResult with the results from the API
	*/
	List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context);
    
    /**
	* Accepts a KenanObject to insert data via the Kenan API 
	* @param context KenanObject
	* @param method String
	* @return KenanObject
	*/
    KenanObject insertRow(KenanObject contextAccount, String method, String action);

    /**
	* Accepts a KenanObject to insert data via the Kenan API 
	* @param context KenanObject
	* @param method String
	* @return KenanObject
	*/
    KenanObject updateRow(KenanObject contextAccount, String method, String action);

    /**
	* Accepts a KenanObject to delete data via the Kenan API 
	* @param context KenanObject
	* @return Boolean
	*/
    Boolean deleteRow(KenanObject contextAccount);
}