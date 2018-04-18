public class LG_TerminateSubDetailsController {

	private List<csord__Service_Line_Item__c> serviceLineItems { get; set; }

	public List<csord__Service_Line_Item__c> getServiceLineItems() {

		if (this.serviceLineItems == null) {
			this.serviceLineItems = getServiceLineItemRecords();
		}

		return this.serviceLineItems;
	}

	public class Service {
		public csord__Service__c service {get; set;}
		public String numbers {get; set;}
	}

	public List<Service> getServiceItems() {
		return getServiceRecords();
	}

	private Id subId;

	public LG_TerminateSubDetailsController () {

		subId = ApexPages.currentPage().getParameters().get('subId');
	}

	private List<Service> getServiceRecords() {

		List<csord__Service__c> objs = [SELECT Id, Name, csord__Status__c, LG_ServiceExternalId__c, (SELECT LG_PhoneNumber__c From LG_Assets__r WHERE RecordType.Name = 'Phone Number' ORDER BY LG_PhoneNumber__c),
										(SELECT LG_PhoneNumber__c From Assets1__r WHERE RecordType.Name = 'Phone Number' ORDER BY LG_PhoneNumber__c)
										FROM csord__Service__c WHERE csord__Subscription__c = :this.subId];
		List<Service> services = new List<Service>();
		for (csord__Service__c service : objs) {
			Service serv = new Service();
			serv.service = service;
			if (service.LG_Assets__r!= null && !service.LG_Assets__r.isEmpty()) {
				String numbers = '';
				for (Asset asst : service.LG_Assets__r) {
					numbers += asst.LG_PhoneNumber__c + ', ';
				}
				serv.numbers = numbers.substring(0, numbers.length()-2);
			}
			if (service.Assets1__r!= null && !service.Assets1__r.isEmpty()) {
				String numbers = '';
				for (Asset asst : service.Assets1__r) {
					numbers += asst.LG_PhoneNumber__c + ', ';
				}
				serv.numbers = numbers.substring(0, numbers.length()-2);
			}
			services.add(serv);
		}

		return services;
	}

	private List<csord__Service_Line_Item__c> getServiceLineItemRecords() {

		List<csord__Service_Line_Item__c> objs = [SELECT Id, Name, csord__Start_Date__c, csord__End_Date__c FROM csord__Service_Line_Item__c WHERE csord__Service__r.csord__Subscription__c = :this.subId];

		return objs;
	}
}