/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Connector Service is the main point of entry for the API.
*/
public class KenanConnectorService {

	public KenanConnectorService(){
	}

	/**
	* Accepts a KenanAccount that will be created in the Kenan Billing System
	* @param kAccount KenanAccount 
	* @return KenanAccount with all the Kenan Id fields populated
	*/
	public KenanAccount accountCreate(KenanAccount kAccount){
		KenanAccountService acctServ = new KenanAccountService();
		return (KenanAccount)acctServ.insertRow(kAccount, 'POST', 'CREATE');
	}

	/**
	* Accepts a KenanAccount that will be updated in the Kenan Billing System
	* @param kAccount KenanAccount 
	* @return KenanAccount with all the Kenan Id fields populated
	*/
	public KenanAccount accountUpdate(KenanAccount kAccount){
		KenanAccountService acctServ = new KenanAccountService();
		return (KenanAccount)acctServ.updateRow(kAccount, 'PUT', 'MODIFY');
	}

	/**
	* Accepts a KenanAccount that will be ceased or closed in the Kenan Billing System
	* @param kAccount KenanAccount 
	* @return Boolean
	*/
	public Boolean accountCease(KenanAccount kAccount){
		KenanAccountService acctServ = new KenanAccountService();
		return acctServ.deleteRow(kAccount);
	}
 	
 	/**
	* Accepts a List of KenanAccount that will create an Account Hierarchy
	* @param accountList List<KenanAccount> 
	* @return List<KenanAccount>
	*/
	public List<KenanAccount> accountHierarchyCreate(List<KenanAccount> accountList){
		KenanAccountService acctServ = new KenanAccountService();
		return acctServ.insertHierarchy(accountList);
	}
	
	/**
	* Accepts a KenanService that will be created in the Kenan Billing System
	* You must include the following information as part of the extData Map
	* extData.put(4, Contract Number);
	* extData.put(5, contract Datetime); 
	* extData.put(7, contract Start Datetime); 
	* extData.put(8, contract expiration Datetime);
	* extData.put(10, "1"); // must be valid contract display on invoice values
	* @param service KenanService
	* @return KenanService
	*/
	public KenanService serviceCreate(KenanService service){
		KenanServiceService kservice = new KenanServiceService();
		return (KenanService) kservice.insertRow(service, 'POST', 'CREATE');
	}
	
	/**
	* Accepts a KenanService that will be created in the Kenan Billing System
	* @param service KenanService
	* @return KenanService
	*/
	public KenanService serviceModify(KenanService service){
		KenanServiceService kservice = new KenanServiceService();
		return (KenanService) kservice.updateRow(service, 'PUT', 'MODIFY');
	}
	
	/**
	* Accepts a KenanService that will be ceased in the Kenan Billing System
	* @param service KenanService
	* @return KenanService
	*/
	public Boolean serviceCease(KenanService service){
		KenanServiceService kservice = new KenanServiceService();
		return kservice.deleteRow(service);
	}
	
	/**
	* Accepts a KenanServiceItem that will be created in the Kenan Billing System
	* The only property on the KenanService that must be populated is the salesforceObjectId that was used as the external Id type 2 when the service was created.
	* @param item KenanServiceItem
	* @return List of KenanServiceItem
	*/
	public List<KenanServiceItem> serviceItemCreate(KenanServiceItem item){
		KenanServiceItemService kservice = new KenanServiceItemService();
		return (List<KenanServiceItem>) kservice.insertRowAlternate(item, 'POST', 'CREATE');
	}
	
	/**
	* Accepts a KenanServiceItem that will be ceased in the Kenan Billing System
	* @param item KenanServiceItem
	* @return KenanServiceItem
	*/
	public Boolean serviceItemCease(KenanServiceItem item){
		KenanServiceItemService kservice = new KenanServiceItemService();
		return kservice.deleteRow(item);
	}
	
	/**
	* Accepts a List of KenanService that will be created in the Kenan Billing System
	* @param services list of KenanService
	* @return List of KenanService
	*/
	public List<KenanService> orderCreate(List<KenanService> services){
		KenanServiceService kservice = new KenanServiceService();
		return (List<KenanService>) kservice.insertRows(services, 'POST', 'CREATE');
	}
	
	/**
	* Accepts a KenanServiceExternalId that will be added to an existing Service in the Kenan Billing System
	* You must populate the salesforceObjectId that was used to create the service in the Kenan Billing System 
	* @param item KenanServiceExternalId
	* @return KenanServiceExternalId
	*/
	public KenanServiceExternalId serviceIdCreate(KenanServiceExternalId item){
		KenanServiceExternalIdService kservice = new KenanServiceExternalIdService();
		return (KenanServiceExternalId) kservice.insertRow(item, 'POST', 'CREATE');
	}

	/**
	* Accepts a KenanServiceExternalId that will be removed from an existing Service in the Kenan Billing System
	* You must populate the salesforceObjectId that was used to create the service in the Kenan Billing System 
	* You also need to supply the ServiceExternalId and Type of the External Id to be removed along with an inactive DateTime
	* @param item KenanServiceExternalId
	* @return KenanServiceExternalId
	*/
	public Boolean serviceIdCease(KenanServiceExternalId item){
		KenanServiceExternalIdService kservice = new KenanServiceExternalIdService();
		return kservice.deleteRow(item);
	}
	
	/**
	* Accepts a KenanServiceExternalId that will be swapped with an existing External Id on an existing Service in the Kenan Billing System
	* You must populate the salesforceObjectId that was used to create the service in the Kenan Billing System 
	* You also need to supply the oldServiceExternalId, oldServiceExternalIdType and inactiveDate of the External Id to be removed.
	* You must also supply a new serviceExternalId, serviceExternalIdType and activeDate for the new Id to be added to the existing Service in the Kenan Billing System.
	* @param item KenanServiceExternalId
	* @return KenanServiceExternalId
	*/
	public KenanServiceExternalId serviceIdSwap(KenanServiceExternalId item){
		KenanServiceExternalIdService kservice = new KenanServiceExternalIdService();
		return (KenanServiceExternalId) kservice.updateRow(item, 'PUT', 'SWAP');
	}

	/**
	* Accepts a KenanAddress that will be changed in the Kenan system
	* @param item KenanAddress
	* @return KenanAddress
	*/
	public KenanAddress changeServiceAddress(KenanAddress item){
		KenanAddressService kservice = new KenanAddressService();
		return (KenanAddress) kservice.insertRow(item, 'POST', 'CREATE');
	}
	
	/**
	* Accepts a KenanPaymentProfile that will be changed in the Kenan system
	* @param item KenanPaymentProfile
	* @return KenanPaymentProfile
	*/
	public KenanPaymentProfile paymentProfileCreate(KenanPaymentProfile item){
		KenanPaymentProfileService kservice = new KenanPaymentProfileService();
		return (KenanPaymentProfile) kservice.insertRow(item, 'POST', 'CREATE');
	}

	/**
	* Accepts a KenanAccountItem that will be created in the Kenan Billing System
	* The only property on the KenanService that must be populated is the salesforceObjectId that was used as the external Id type 2 when the service was created.
	* @param kenanAccountItem KenanAccountItem
	* @return List of KenanAccountItem
	*/
	public List<KenanAccountItem> accountItemCreate(KenanAccountItem kenanAccountItem) {
		KenanAccountItemService kservice = new KenanAccountItemService();
		return (List<KenanAccountItem>) kservice.insertRowAlternate(kenanAccountItem, 'POST', 'CREATE');
	}

	/**
	* Accepts a KenanAccountItem that will be ceased in the Kenan Billing System
	* @param kenanAccountItem KenanAccountItem
	* @return Boolean
	*/
	public Boolean accountItemCease(KenanAccountItem kenanAccountItem) {
		KenanAccountItemService kservice = new KenanAccountItemService();
		return kservice.deleteRow(kenanAccountItem);
	}

}