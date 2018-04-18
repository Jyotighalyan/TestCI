global with sharing class WidgetStyleController {

	public String params {get; set;}
	public String col1 {get; set;}
	public WidgetStyle__c ws ;

	public WidgetStyle__c ws1;

	public String valueOne { get; set; }
	public String valueTwo { get; set; }
	public String valueThree { get; set; }
	public String valueFour { get; set; }
	public String valueFive { get; set; }

	public String darkc {get; set;}
	public String lightc {get; set;}
	public String hoverc {get; set;}
	public String panelc {get; set;}
	public String panelsuccessc {get; set;}

	public String flag {get; set;}

	WidgetStyle__c wid;

	public WidgetStyleController(ApexPages.StandardController controller) {
		init();
	}

	public WidgetStyleController() {
		init();
	}

	void init(){
		ws = WidgetStyle__c.getOrgDefaults();
		//ws = WidgetStyle__c.getValues(UserInfo.getUserId());
		ws1 = WidgetStyle__c.getInstance();

		darkc = ws1.dark__c;
		lightc = ws1.light__c;
		hoverc = ws1.hover__c;
		panelc = ws1.panel__c;
		panelsuccessc = ws1.panelsuccess__c;
	}

	public PageReference iWantMyJSValues() {
		valueOne = Apexpages.currentPage().getParameters().get('one');
		valueTwo = Apexpages.currentPage().getParameters().get('two');
		valueThree = Apexpages.currentPage().getParameters().get('three');
		valueFour = Apexpages.currentPage().getParameters().get('four');
		valueFive = Apexpages.currentPage().getParameters().get('five');

		if (ws == null) {
			ws = new WidgetStyle__c();
			ws.dark__c = valueOne;
			ws.light__c = valueTwo;
			ws.hover__c = valueThree;
			ws.panel__c = valueFour;
			ws.panelsuccess__c = valueFive;
			upsert ws;
		}
		else {
			System.debug('@@CW	ELSE');
			ws.dark__c = '#' + valueOne;
			ws.light__c = '#' + valueTwo;
			ws.hover__c = '#' + valueThree;
			ws.panel__c = '#' + valueFour;
			ws.panelsuccess__c = '#' + valueFive;
			upsert ws;
		}
		//return null;
		PageReference acctPage = new PageReference('/apex/colorpicker');

		//acctPage.setRedirect(true);
		return acctPage;

	}

	public PageReference dum() {
		return null;
	}

}