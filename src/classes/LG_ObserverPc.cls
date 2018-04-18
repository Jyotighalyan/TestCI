/**
* Since: 06/Dec/2017 
* Used  as a Observer implementation class for creating the persistent ids for Product configurations
* using Simple Select, Clone, Advanced Clone.
*/

global with sharing class LG_ObserverPc implements csbb.ObserverApi.IObserver {

    global LG_ObserverPc(){ 
    }
   global void execute (csbb.ObserverApi.Observable o, Object arg) {
       csbb.ProductConfigurationObservable observable = (csbb.ProductConfigurationObservable)o;
       String context = observable.getContext();
       csbb__Product_Configuration_Request__c pcr = observable.getProductConfigurationRequest();
       LG_ObserverPcUtil.updatePersistentId(observable.getProductConfiguration());
	}
}