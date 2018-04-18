@isTest
public class TestWidgetStyleController {

	static testmethod void testController() {
		WidgetStyleController cont = new WidgetStyleController();
		cont.iWantMyJSValues();
		cont.dum();
		ApexPages.StandardController controller = new ApexPages.StandardController(new Account(Name = 'Test'));
		cont = new WidgetStyleController(controller);
	}
}