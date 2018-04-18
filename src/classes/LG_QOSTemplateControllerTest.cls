@isTest 
public class LG_QOSTemplateControllerTest 
{
	static testMethod void testMethod1() 
	{
		LG_QOS_Template__c  qos = new LG_QOS_Template__c();
        qos.Product_Definition_Name__c='BDS Standort';
		qos.Qos_Type__c	='Classic';

		insert qos;
		
		Test.StartTest(); 

			ApexPages.currentPage().getParameters().put('id', String.valueOf(qos.Id));
			LG_QOSTemplateController  testqostemp = new LG_QOSTemplateController();
			testqostemp.getStandortqosList();
			

		Test.StopTest();
	}
}