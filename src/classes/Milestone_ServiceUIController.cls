/**
 *
 * Controller for Milestone view
 *
 * @author Petar Miletic
 * @ticket SFOM-1396
 * @since  07/08/2017
*/
global with sharing class Milestone_ServiceUIController {

	public static final String JEOPARDY_STATUS = 'Jeopardy';
	public static final String WARNING_STATUS = 'Warning';
	public static final String ERROR_STATUS = 'Error';
	public static final String IN_PROGRESS_STATUS = 'In Progress';
	public static final String COMPLETE_STATUS = 'Complete';
	public static final String RED_RAG_STATUS = 'Red';
	public static final String AMBER_RAG_STATUS = 'Amber';
	public static final String GREEN_RAG_STATUS = 'Green';

	public Account account { get; private set; }

	public Id recId {
		public get;
		public set {
			if (recId == null) {
				recId = value;
				account = Milestone_UtilityHelper.loadAccount(value);
			}
		}
	}

	public String recordType {

		get {

			if (this.recId == null) {
				this.recId = ApexPages.currentPage().getParameters().get('Id');
			}

			return Milestone_UtilityHelper.getObjectType(this.recId).toLowerCase();
		}
	}

	public String related {
		get {
			if (String.isBlank(this.related)) {
				Id recordId = this.recId;
				if (recordId != null) {
					String objectName = String.valueOf(recordId.getSObjectType());
					List<SObject> objects = Database.query(
						String.format(
							'select id, name from {0} where id = :recordId',
							new String [] { objectName }
						)
					);
					if (!objects.isEmpty()) {
						this.related = JSON.serialize(objects[0]);
					}
				}
				if (String.isBlank(this.related)) {
					this.related = 'null';
				}
			}
			return this.related;
		}
		private set;
	}

	/**
	 * <p>Returns the user's locale in lower case, separated by a hyphen rather than underscore, to match the Angular i18n file naming pattern.</p>
	 * <p>E.g. The locale 'en_GB' is returned as 'en-gb'.</p>
	 * <p><b>Update 2016-06</b>: Since some Angular i18n files are named only with language codes and not country codes, this
	 * has been changed to strip the _XX suffix. So 'en_GB' is now returend as simple 'en';
	 */
	public String userAngularLocale {
		public get {
			//return UserInfo.getLocale().toLowerCase().replaceAll('_', '-');
			return UserInfo.getLocale().toLowerCase().replaceAll('_\\w\\w', '');
		}
		private set;
	}

	/**
	 * <p>Returns the user's currency identifier as an HTML entity, e.g. '&#839;' for Sterling.</p>
	 */
	public String userCurrencySymbol {
		public get {
			return Milestone_LocaleHelper.getCurrencySymbolHtmlEntity(UserInfo.getDefaultCurrency());
		}
		private set;
	}

	/**
	 * <p>Returns the user's currency identifier as a three letter code, e.g. 'GBP' for Sterling.</p>
	 */
	public String userCurrencyCode {
		public get {
			return UserInfo.getDefaultCurrency();
		}
		private set;
	}

	/* Constructors */

	global Milestone_ServiceUIController() {

	}

	global Milestone_ServiceUIController(ApexPages.StandardController c) {

	}

	/* Remote Actions */

	/**
	 * <p>Returns the lowest priority visible Service_Console_Component_Config__c record for given type and current user, or the empty string.</p>
	 */
	@RemoteAction
	global static String getConfig(String type) {
		return Milestone_ControlPanel.getConfiguration(type);
	}

	/*
	 * Deprecated method
	*/
	@RemoteAction
	global static List<CSPOFA__Orchestration_Process__c> getProcesses(Id recordId) {
		return getProcesses2(recordId, null);
	}

	/*
	 * Returns Orchestration Processes for given record id
	*/
	@RemoteAction
	global static List<CSPOFA__Orchestration_Process__c> getProcesses2(Id recordId, String fieldJson) {
		return Milestone_OrchestrationProcessFacade.getData(recordId, fieldJson);
	}

	/**
	 *
	 * Return Suborders
	 *
	 * @author Petar Miletic
	 * @ticket SFOM-373
	 * @since  07/04/2017
	*/
	@RemoteAction
	global static List<CSPOFA__Orchestration_Process__c> getSuborders(Id recordId, Integer pageOffset, Integer pageLimit) {
		// Integer pageOffset = 0;
		// Integer pageLimit = 25;
		return Milestone_OrchestrationProcessFacade.getSuborderData(recordId, pageOffset, pageLimit, null);
	}

	/**
	 *
	 * Start pauses orchestrator process
	 *
	 * @author Petar Miletic
	 * @ticket SFOM-373
	 * @since  07/04/2017
	*/
	@RemoteAction
	global static String startPauseProcess(Id recordId) {

		return Milestone_UtilityHelper.startPauseProcess(recordId);
	}
}