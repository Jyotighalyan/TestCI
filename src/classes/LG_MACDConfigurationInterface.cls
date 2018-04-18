/**
 * Interface used for MACD Configuration pages.
 *
 * @author Tomislav Blazek
 * @since  10/7/2017
 */
public interface LG_MACDConfigurationInterface {

	/**
	 * Fires the RFS Check for the Address/Site and returns the status code and the body of the response
	 *
	 * @param  String siteId - site Id (addressId)
	 * @param  Boolean isMove - if changeType is Move, the selected move site has to be RFS checked
	 * @return HttpResponseRemoting - custom class as with a http status code and a response body
	 * @author Tomislav Blazek
	 * @ticket
	 * @since  23/2/2016
	 */
	LG_MACDConfigurationController.HttpResponseRemoting rfsCheck(String siteId, Boolean isMove);

	/**
	 * Fires the RFS Check for the Address/Site and returns the status code and the body of the response
	 *
	 * @param  String sitesJson - a list of selected sites and the related subscriptions from the VF Page
	 *                              list is provided from the VF page as a json object
	 * @param  String changeTypeName - MACD change type i.e. Change, Move - provided from the VF Page
	 * @param  String accountId - id of the Account
	 * @return String - returns the MACD Opportunity Id to redirect the user to
	 * @author Tomislav Blazek
	 * @ticket
	 * @since  23/2/2016
	 */
	String createMacdOppAndBasket(String sitesJson, String changeTypeName, String accountId, String services, String moveInMoveOutDates, Boolean isDowngrade);

	/**
	 * Updates the Product Configurations attributes with the appropriate values of the RFS Check
	 * Currently only Product Configurations of the Internet Family Type are updated.
	 * It also updates:
	 * - Product Configurations change type
	 * - if 'Move'  - upserts the selected address and saves the Id of that address to the premise attribute
	 *                of the product configuration(s)
	 *
	 * @param  Id basketId - Id of the basket for which the Attributes of the related Product Configurations
	 *                          should be updated
	 * @param  Map<String, String> siteToRfsCommonResponse - siteToRfsCommon response map
	 *                                                      for getting the RFS Check results per Site
	 * @param  String changeTypeName - MACD change type i.e. Change, Move - provided from the VF Page
	 * @param Id accountId
	 * @param Set<Id> migratedServices - SFOM-401 set of replaced services Ids so that we know cloned configs to
	 * delete in case of migrate
	 * @author Tomislav Blazek
	 * @ticket
	 * @since  25/2/2016
	 */
	void updateProductConfigurationAttributes(Id basketId, Map<String, String> siteToRfsCommonResponse,
											  String changeTypeName, Id accountId, Set<Id> migratedServices, List<Map<Id, Date>> moveInMoveOutDateList);
}