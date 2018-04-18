/**
 *  Test helper class for Account object.
 *  @author Petar Miletic
 *  @since 02/02/2016
 */
@isTest
public with sharing class uth_Account {

    public static Account Create()
    {
        return Create('Test',  false);
    }
    
    public static Account Create(boolean insertRecord) {
        return Create('Test', insertRecord);
    }

    public static Account Create(string accName, Boolean insertRecord)
    {
        Account a = new Account(Name = accName, LG_ChamberOfCommerceNumber__c = '99999999', LG_Footprint__c = 'Zigo Test');
        if(insertRecord) {
            insert a;
        }
        
        return a;
    }
}