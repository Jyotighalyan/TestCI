/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Service for use in Salesforce Kenan Connection Service
*/
public class KenanPaymentProfileService implements KenanServiceInterface {
	
	private KenanServiceConnection__c kenanSettings;
	private JSONGenerator jsonGen;
	private KenanPaymentProfileMapper paymentMapper;
	private String endpoint;

	public KenanPaymentProfileService(){
		paymentMapper = new KenanPaymentProfileMapper();
		jsonGen = JSON.createGenerator(true);
		kenanSettings = KenanServiceConnection__c.getInstance();	
	}

	public KenanObject insertRow(KenanObject contextPaymentProfile,  String method, String action){
		KenanPaymentProfile kProfile = (KenanPaymentProfile) contextPaymentProfile;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		Map<String, Object> itemMap = paymentMapper.getEnumeratedValues(kProfile);
		String jsonString = JSON.serialize(itemMap);
		String endpoint = '/accounts/' + kProfile.accountExternalId + '.' + kProfile.accountExternalIdType + '/profile';
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
		KenanPaymentProfile kaResponse;
		if (String.isEmpty(response.getBody())){
			
		} else {
			Map<String, Object> actMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			kaResponse = deserializePaymentProfile(actMap);
		}
		
		return kaResponse;
	}

	public KenanObject updateRow(KenanObject contextAccount,  String method, String action){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanPaymentProfileService.updateRow has not been implemented';
    	ke.errorMessage = 'KenanPaymentProfileService.updateRow has not been implemented';
    	throw ke;
	}

    public Boolean deleteRow(KenanObject contextAccount){
 		KenanException ke = new KenanException();
    	ke.errorName = 'KenanPaymentProfileService.deleteRow has not been implemented';
    	ke.errorMessage = 'KenanPaymentProfileService.deleteRow has not been implemented';
    	throw ke;
    }

	public DataSource.TableResult query(DataSource.QueryContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanPaymentProfileService.query has not been implemented';
    	ke.errorMessage = 'KenanPaymentProfileService.query has not been implemented';
    	throw ke;
	}

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanPaymentProfileService.search has not been implemented';
    	ke.errorMessage = 'KenanPaymentProfileService.search has not been implemented';
    	throw ke;

    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanPaymentProfileService.upsertRows has not been implemented';
    	ke.errorMessage = 'KenanPaymentProfileService.upsertRows has not been implemented';
    	throw ke;
    }
    
	public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanPaymentProfileService.deleteRows has not been implemented';
    	ke.errorMessage = 'KenanPaymentProfileService.deleteRows has not been implemented';
    	throw ke;
	}

    private KenanPaymentProfile deserializePaymentProfile(Map<String, Object> profileMap){
    	KenanPaymentProfile profile = paymentMapper.getDisplayValues(profileMap);
		return profile;
    }
}