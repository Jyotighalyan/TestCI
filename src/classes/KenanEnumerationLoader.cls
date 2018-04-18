/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Enumeration Loader is an Interface to load all types of Metadata into Salesforce from Kenan.
*/
public interface KenanEnumerationLoader {
	
	void executeLoad(String userSession, KenanEnumeration enumeration, Boolean loadData);

}