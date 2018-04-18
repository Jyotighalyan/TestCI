/**
 * 
 * Control Panel/Service Console related stuf (configs, items and so on)
 * 
 * @author Petar Miletic
 * @ticket SFOM-1396
 * @since  07/08/2017
*/
public with sharing class Milestone_QueryHelper {

	static Map<String, String> OPERATORS = new Map<String, String> {
		'$eq' => '=',
		'$ne' => '!=',
		'$lt' => '<',
		'$gt' => '>',
		'$lk' => 'LIKE',
		'$nlk' => 'NOT LIKE'
	};

	static Map<String, String> CONJUNCTIONS = new Map<String, String> {
		'$or' => 'OR',
		'$and' => 'AND'
	};

	static final Integer MAX_STEPS = 30000;

	/**
	 *
	 * Validate lookup relationship on CSPOFA__Orchestration_Process__c object
	 *
	 * @author Petar Miletic
	 * @ticket SFOM-373
	 * @since  07/04/2017
	*/

	public static Boolean isLocalOrderRelPresent(Milestone_NavigatorConfig config) {

		String lookup = config.tabs.orders.OrchestrationProcessLookup;

		// If not empty validate
		if (!String.isBlank(lookup)) {

			return Milestone_QueryHelper.validateRel(lookup);
		}

		return false;
	}

	/**
	 *
	 * Validate lookup relationship on CSPOFA__Orchestration_Process__c object
	 *
	 * @author Petar Miletic
	 * @ticket SFOM-373
	 * @since  07/04/2017
	*/

	public static Boolean isLocalSolutionRelPresent(Milestone_NavigatorConfig config) {
	
		String lookup = config.tabs.solutions.OrchestrationProcessLookup;

		// If not empty validate
		if (!String.isBlank(lookup)) {

			return Milestone_QueryHelper.validateRel(lookup);
		}

		return false;	
	}

	/**
	 *
	 * Validate lookup
	 *
	 * @author Petar Miletic
	 * @ticket SFOM-373
	 * @since  07/04/2017
	*/

	public static Boolean validateRel(String lookup) {

		return CSPOFA__Orchestration_Process__c.sObjectType.getDescribe().fields.getMap().containsKey(lookup);
	}


	public static final Boolean isLocalOrderRelPresent = CSPOFA__Orchestration_Process__c.sObjectType.getDescribe().fields.getMap().containsKey('order__c');
	public static final Boolean isLocalStepStartTimePresent = CSPOFA__Orchestration_Step__c.sObjectType.getDescribe().fields.getMap().containsKey('start_date_time__c')
															&& CSPOFA__Orchestration_Step__c.sObjectType.getDescribe().fields.getMap().containsKey('end_date_time__c')
															&& CSPOFA__Orchestration_Step__c.sObjectType.getDescribe().fields.getMap().containsKey('estimated_time_to_complete__c');
	public static final Boolean isLocalRagStatusPresent = CSPOFA__Orchestration_Step__c.sObjectType.getDescribe().fields.getMap().containsKey('rag_status__c')
															&& CSPOFA__Orchestration_Step__c.sObjectType.getDescribe().fields.getMap().containsKey('rag_status_message__c');

	public static final Boolean isLocalProcessRagStatusPresent = CSPOFA__Orchestration_Process__c.sObjectType.getDescribe().fields.getMap().containsKey('rag_status__c')
															&& CSPOFA__Orchestration_Process__c.sObjectType.getDescribe().fields.getMap().containsKey('rag_status_message__c');

	public static final Boolean isMultiCurrency = csord__subscription__c.sObjectType.getDescribe().fields.getMap().containsKey('currencyisocode');

	public static String getProcessesQuery(String condition, Map<String, Set<String>> fieldSetMap, Milestone_NavigatorConfig setup) {
		if (fieldSetMap == null) {
			fieldSetMap = new Map<String, Set<String>>();
		}

		String procJson = Milestone_ServiceUIController.getConfig('Milestone View Config');
		Milestone_ProcessViewConfig processSetup = Milestone_UtilityHelper.getProcesViewConfiguration(procJson, true);

		System.debug('getProcessesQuery: fieldSetMap: ' + JSON.serializePretty(fieldSetMap));

		String orderQuery = isLocalOrderRelPresent
				? 'Order__c, ' + buildFieldString(fieldSetMap.get('csord__order__c'), 'Order__r.', ', ')
				: '';

		String stepStartTimeQuery = isLocalStepStartTimePresent
				? 'start_date_time__c, end_date_time__c, estimated_time_to_complete__c, '
				: '';

		String ragStatusQuery = isLocalRagStatusPresent
				? 'rag_status__c, rag_status_message__c, '
				: '';

		String processRagStatusQuery = isLocalProcessRagStatusPresent
				? 'rag_status__c, rag_status_message__c, '
				: '';

		System.debug('-> ' + fieldSetMap);
		System.debug('--> ' + buildFieldString(fieldSetMap.get('cspofa__orchestration_process__c'), null, ', '));

		String query = '';

		// processSetup.getFullQuery() + ', ' +
		if (processSetup.isValidSuborder()) {

			System.debug('---> valid!');

			List<String> conditions = new List<String>();

			addIfNotEmpty(conditions, condition);
			//addIfNotEmpty(conditions, processSetup.getSuborderInfoCondition());

			query =  'SELECT CSPOFA__Process_On_Hold__c, ' + processRagStatusQuery + 
						buildFieldString(fieldSetMap.get('cspofa__orchestration_process__c'), null, ', ') +
						'csordtelcoa__Service__c, ' + 
						buildFieldString(fieldSetMap.get('csord__service__c'), 'csordtelcoa__Service__r.', ', ') + 
                        buildFieldString(fieldSetMap.get('csord__order__c'), 'csordtelcoa__Service__r.LG_RootOrder__r.', ', ') + 
						buildFieldString(fieldSetMap.get('csord__subscription__c'), 'csordtelcoa__Service__r.csord__Subscription__r.', ', ') +
						'csordtelcoa__Subscription__c, '+ 
						buildFieldString(fieldSetMap.get('csord__subscription__c'), 'csordtelcoa__Subscription__r.', ', ') + 
						buildFieldString(fieldSetMap.get('csord__order__c'), 'csordtelcoa__Subscription__r.csord__Order__r.', ', ') +
						processSetup.getFullQuery() + 
						processSetup.getInflightButtons('order') + 
						processSetup.getSuborderInfo() +
						orderQuery +
						'(SELECT Name, ' + stepStartTimeQuery + ragStatusQuery + 'CSPOFA__Milestone__c, CSPOFA__Milestone_Label__c, CSPOFA__Milestone_Description__c, CSPOFA__Orchestration_Process__c, ' +
							'CSPOFA__Step_Order__c, CSPOFA__Status__c, CSPOFA__Jeopardy_Created_Flag__c, CSPOFA__Task_Assigned_To__c, CSPOFA__Task_Due_Date__c, CSPOFA__Type__c, ' + 
							'CSPOFA__Message__c, CSPOFA__Progress__c ' +
							'FROM CSPOFA__Orchestration_Steps__r ' +
							'ORDER BY CSPOFA__Step_Order__c ASC) ' +
						'FROM CSPOFA__Orchestration_Process__c ' +
						'WHERE ' + String.join(conditions, ' AND ') + ' ' +
						'ORDER BY createdDate DESC';

            System.debug('query -> ' + query);

		} else {

			System.debug('---> !valid!');

			query =  'SELECT CSPOFA__Process_On_Hold__c, ' + processRagStatusQuery + 
						buildFieldString(fieldSetMap.get('cspofa__orchestration_process__c'), null, ', ') +
						'csordtelcoa__Service__c, ' + 
						buildFieldString(fieldSetMap.get('csord__service__c'), 'csordtelcoa__Service__r.', ', ') + 
                        buildFieldString(fieldSetMap.get('csord__order__c'), 'csordtelcoa__Service__r.LG_RootOrder__r.', ', ') + 
						buildFieldString(fieldSetMap.get('csord__subscription__c'), 'csordtelcoa__Service__r.csord__Subscription__r.', ', ') +
						'csordtelcoa__Subscription__c, '+ 
						buildFieldString(fieldSetMap.get('csord__subscription__c'), 'csordtelcoa__Subscription__r.', ', ') + 
						buildFieldString(fieldSetMap.get('csord__order__c'), 'csordtelcoa__Subscription__r.csord__Order__r.', ', ') +
						processSetup.getInflightButtons('order') + ' ' +
						orderQuery +
						'(SELECT Name, ' + stepStartTimeQuery + ragStatusQuery + 'CSPOFA__Milestone__c, CSPOFA__Milestone_Label__c, CSPOFA__Milestone_Description__c, CSPOFA__Orchestration_Process__c, ' +
							'CSPOFA__Step_Order__c, CSPOFA__Status__c, CSPOFA__Jeopardy_Created_Flag__c, CSPOFA__Task_Assigned_To__c, CSPOFA__Task_Due_Date__c, CSPOFA__Type__c, ' + 
							'CSPOFA__Message__c, CSPOFA__Progress__c ' +
							'FROM CSPOFA__Orchestration_Steps__r ' +
							'ORDER BY CSPOFA__Step_Order__c ASC) ' +
						'FROM CSPOFA__Orchestration_Process__c ' +
						'WHERE ' + condition + ' ' +
						'ORDER BY createdDate DESC';
		}

		System.debug('--+> ' + query);

		return query;
	}

	public static void addIfNotEmpty(List<String> values, String value) {

		if (String.isNotBlank(value)) {
			values.add(value);
		}
	}

	public static Map<String, Set<String>> getFieldSetMap(String fieldJson) {

		System.debug('getFieldSetMap -> ' + fieldJson);

		Set<String> processFields = new Set<String>(new String[]{
			'name', 'cspofa__account__c', 'cspofa__account__r.name', 'cspofa__jeopardy_created_flag__c',
			'cspofa__opportunity__c', 'cspofa__opportunity__r.name', 'cspofa__progress__c', 'cspofa__status__c',
			'estimated_time_to_complete__c', 'start_date_time__c', 'end_date_time__c'
		});
		Set<String> orderFields = new Set<String>(new String[]{
			'name', 'csord__status__c', 'csord__status2__c', 'csord__order_number__c', 'csord__solution__c', 'csord__solution__r.name'
		});
		Set<String> subsFields = new Set<String>(new String[]{
			'name', 'csord__account__c', 'csord__account__r.name', 'csord__order__c', 'csord__solution__c'
		});
		Set<String> serviceFields = new Set<String>(new String[]{
            'name', 'LG_RootOrder__c', 'csord__subscription__c', 'csord__service__c'
		});
		Set<String> solutionFields = new Set<String>(new String[]{
			'name', 'csord__order__c'
		});
		Set<String> taskFields = new Set<String>(new String[]{

		});
		Set<String> caseFields = new Set<String>(new String[]{

		});

		if (isMultiCurrency) {
			orderFields.add('currencyisocode');
			subsFields.add('currencyisocode');
			serviceFields.add('currencyisocode');
			solutionFields.add('currencyisocode');
		}

		Map<String, Set<String>> fieldSetMap = new Map<String, Set<String>>{
			'cspofa__orchestration_process__c' => processFields,
			'csord__order__c' => orderFields,
			'csord__subscription__c' => subsFields,
			'csord__service__c' => serviceFields,
			'csord__solution__c' => solutionFields,
			'task' => taskFields,
			'case' => caseFields
		};

		if (fieldJson != null) {
			try {
				List<Object> fields = (List<Object>) JSON.deserializeUntyped(fieldJson);
				for (Object fieldSpec : fields) {
					Map<String, Object> mp = (Map<String, Object>) fieldSpec;
					Object fieldObj = mp.get('field');
					System.debug(mp);
					System.debug(fieldObj);
					if (fieldObj instanceof String) {
						String fieldRef = (String) mp.get('field');
						String[] parts = fieldRef != null ? fieldRef.split('\\.') : new String[]{''};
						String obj = parts[0].toLowerCase();
						String field = obj != '' ? fieldRef.substring(fieldRef.indexOf('.') + 1) : null;
						addField(fieldSetMap, obj, field);
					} else {
						if (fieldObj instanceof Map<String, Object>) {
							Map<String, Object> fieldRefMap = (Map<String, Object>) fieldObj;
							for (String obj : fieldRefMap.keySet()) {
								addField(fieldSetMap, obj, (String) fieldRefMap.get(obj));
							}
						}
					}
					
				}
			} catch (Exception e) {
				System.debug(e + '\n' + e.getStackTraceString());

			}
		}

		System.debug('getFieldSetMap:end -> ' + fieldJson);

		return filterValidFields(fieldSetMap);
	}

	public static String buildControlPanelItemsQuery(Map<String, Set<String>> fieldSetMap, String filterJson, String orderBy, Integer max) {
		if (fieldSetMap == null) {
			fieldSetMap = new Map<String, Set<String>>();
		}

		String query =  'SELECT Id, Name, CSPOFA__Jeopardy_Created_Flag__c, CSPOFA__Milestone__c, CSPOFA__Milestone_Label__c, CSPOFA__Milestone_Description__c, ' +
						'CSPOFA__Orchestration_Process__c, CSPOFA__Related_Object_Id__c, CSPOFA__Status__c, CSPOFA__Step_Order__c, ' +
						'CSPOFA__Task_Assigned_To__c, CSPOFA__Task_Due_Date__c, cspofa__Task_Subject__c, CSPOFA__Type__c ' +
						'FROM CSPOFA__Orchestration_Step__c ';

		if (filterJson != null && filterJson != '') {
			Milestone_QueryHelper.FilterSpec filter = Milestone_QueryHelper.deserializeFilter(filterJson);
			if (!filter.isEmpty()) {
				query += 'WHERE ' + filter.toQueryFragment() + ' ';
			}
		}

		if (orderBy != null && orderBy != '') {
			query += 'ORDER BY ' + String.escapeSingleQuotes(orderBy) + ' ';
		}
		query += 'LIMIT ' + MAX_STEPS;

		return query;        
	}

	public static void addField(Map<String, Set<String>> fieldSetMap, String obj, String field) {
		if (field == null) return;

		Set<String> fieldSet = fieldSetMap.get(obj);
		if (fieldSet == null) {
			fieldSet = new Set<String>();
			fieldSetMap.put(obj, fieldSet);
		}
		fieldSet.add(field.toLowerCase());
	}

	public static String buildFieldString(Set<String> fields) {
		return buildFieldString(fields, null, null);
	}

	public static String buildFieldString(Set<String> fields, String prefix, String suffix) {
		if (fields == null) {
			return '';
		}
		if (prefix == null) {
			prefix = '';
		}
		if (suffix == null) {
			suffix = '';
		}

		return prefix + (String.join(new List<String>(fields), ', ' + prefix)) + suffix;
	}

	/*
	 * Returns a new map derived from the one supplied, containing only entries for those objects and fields
	 * which are accessible in the org, and converted to lower case.
	 */

	public static Map<String, Set<String>> filterValidFields(Map<String, Set<String>> supplied) {
		Map<String, Set<String>> filtered = new Map<String, Set<String>>();
		Map<String, Schema.sObjectType> globalDescribe = Schema.getGlobalDescribe();

		for (String objName : supplied.keySet()) {
			Schema.sObjectType type = globalDescribe.get(objName.toLowerCase());
			if (type == null) {
				System.debug(LoggingLevel.WARN, 'Could not identify fieldSetMap type ' + objName + ', ignoring');
				continue;
			}
			Map<String, Schema.sObjectField> fields = type.getDescribe().fields.getMap();

			Set<String> suppliedFields = supplied.get(objName);
			if (suppliedFields == null) {
				continue;
			}
			Set<String> filteredFields = new Set<String>();

			for (String name : suppliedFields) {
				// TODO validate relationships, include for now by default
				if (fields.containsKey(name.toLowerCase()) || name.contains('.')) {
					filteredFields.add(name.toLowerCase());
				} else {
					System.debug('Filtering out field ' + name.toLowerCase());
				}
			}
			filtered.put(objName.toLowerCase(), filteredFields);
		}

		return filtered;
	}

	public static FilterSpec deserializeFilter(String filterJson) {
		Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(filterJson);
		FilterSpec spec = new FilterSpec();
		spec.conjunction = 'AND';
		return buildFilterSpec(spec, m);
	}

	public static FilterSpec buildFilterSpec(FilterSpec spec, Map<String, Object> m) {
		for (String key : m.keySet()) {
			Object o = m.get(key);
			List<Object> values;
	
			if (o instanceof List<Object>) {
				values = (List<Object>) o;
			} else {
				values = new List<Object>{o};
			}
	
			for (Object value : values) {
				FilterSpec child = new FilterSpec();
				spec.subClauses.add(child);
	
				if (key.startsWith('$')) {
					child.conjunction = CONJUNCTIONS.get(key);
					buildFilterSpec(child, (Map<String, Object>) value);
				} else {
					child.criterion = buildCriterion(key, value);
				}
			}
		}

		return spec;
	}

	public static Criterion buildCriterion(String k, Object v) {
		Criterion c = new Criterion();
		c.field = k;
		Object value;
		if (v instanceof Map<String, Object>) {
			Map<String, Object> m = (Map<String, Object>) v;
			String op = new List<String>(m.keySet()).get(0);
			c.operator = OPERATORS.get(op);
			value = m.get(op);
		} else {
			c.operator = '=';
			value = v;
		}
		c.value = interpretValue(value);
		return c;
	}

	public static Object interpretValue(Object v) {
		Object value;
		if (v instanceof String) {
			String str = ((String) v).toLowerCase();

			if (str == '$user.id') {
				value = UserInfo.getUserId();

			} else if (str == '$user.username') {
				value = UserInfo.getUserName();

			} else if (str == '$user.profileId') {
				value = UserInfo.getProfileId();

			} else if (str == '$user.roleId') {
				value = UserInfo.getUserRoleId();

			} else if (str == '$user.name') {
				value = UserInfo.getName();

			} else {
				value = v;
			}
			
		} else {
			value = v;
		}

		return value;
	}

	public class FilterSpec {
		public List<FilterSpec> subClauses;
		public Criterion criterion;
		public String conjunction;

		public FilterSpec() {
			this.subClauses = new List<FilterSpec>();
		}

		public Boolean isEmpty() {
			return this.subClauses == null || this.subClauses.size() == 0;
		}

		public String toQueryFragment() {
			if (criterion != null) {
				return criterion.toString();
			}
			if (this.isEmpty()) {
				return '';
			}
			String query = '(';
			String conj = '';
			for (FilterSpec fs : this.subClauses) {
				query += conj + fs.toQueryFragment();
				conj = ' ' + conjunction + ' ';
			}
			query += ')';
			
			return query;
		}
	}

	public class Criterion {
		public String field;
		public String operator;
		public Object value;

		public override String toString() {
			return field + ' ' + operator + ' ' + quoteValue(value);
		}

		public String quoteValue(Object v) {
			if (v instanceof String) {
				if (v == null) {
					return '\'\'';
				}
				return '\'' + String.escapeSingleQuotes((String) v) + '\'';
			} else {
				return String.valueOf(v);
			}
		}
	}
}