/****************************************************************************************************************
* OwnershipChangeScheduler
* 
* 2017/07/06 V 1.0 Matthias Pfaff UMR-2093 Scheduled Job to run an ownership change according to partner accounts
*                                 Opps and Accounts are handled seperately and also direct from indirect sales
*                                 Match is working on user role name --> partner account name for indirect sales
*                                 User Name --> partner account name on indirect sales
*
*
*****************************************************************************************************************/


public class OwnershipChangeScheduler implements Schedulable 
{
   
       public void execute(SchedulableContext SC)
       {
       ///get mapping for partner users with partner accounts

            User[] pUsers = [Select id, UserRole.Name from User where isactive = true and isportalenabled = true and profile.name = 'UM_Partner'];

            Set<String> pAccountNames = new Set<String>();
            for (User pU:pUsers)
            {
                pAccountNames.add(pU.UserRole.Name.split(' Partner User')[0]);
            }
            System.Debug(pAccountNames);

            Map<String, Account> pAccounts = new Map<String, Account>();
            for(Account a: [Select Name, Id from Account where Name in : pAccountNames and RecordType.Name = 'Partner'])
            pAccounts.put(a.Name,a);
            System.debug(pAccounts);

            // create mapping for partner Users
            Map<String,String> userAccountMap = new Map<String,String>();

            // only map actual users - if there are none no ownership change is necessary
            for(User pU:pUsers)
            {
                String tmpAccountName = pU.UserRole.Name.split(' Partner User')[0];
    
                system.debug(tmpAccountName);
                Account a = pAccounts.get(tmpAccountName);
                // if someone created a partner user for a non partner account, do nothing
                if(a != null)
                {
                    String accId = a.id;
                    //map Account --> User
                    userAccountMap.put(accId,pU.id);
                }
    
            }

            system.debug(userAccountMap);


            //// get mapping for direct sales user with their partner accounts
            pAccounts.clear();
            for(Account a: [Select Name, Id from Account where RecordType.Name = 'Partner'])
            {
                pAccounts.put(a.Name,a);
            }
            pAccountNames.clear();
            pAccountNames = pAccounts.keyset();

            system.debug(pAccountNames);
            //Only get non portal Users --> PAMs or AMs
            pUsers = [Select id, Name  from User where isactive = true and isportalenabled = false and name in : pAccountNames];
            system.debug(pUsers);
            // as no check is done if the account is already present, PAM overrides the partner user.
            // this is wanted because for PAM partner accounts no user should be present
            for(User pU:pUsers)
            {
                Account a = pAccounts.get(pU.Name);
                userAccountMap.put(a.id,pU.id);
            }

            system.debug(userAccountMap);

            // initialize for Accounts and Opportunities
            List<BatchIterator> BIArray = new List<BatchIterator>();
            for (Id accId : userAccountMap.keySet()) 
            {

                Id userId = userAccountMap.get(accId);

                // new account batch with query Select id, Ownerid from Account where Partner_lookup__c =: accId and OwnerId != : userId for every entry
                // new opportunity batch with query select id, Ownerid from Opportunity where UM_PartnerAccount__c =: accId and OwnerId != : userId
                
                BatchIterator biAcc = new BatchIterator('Account', 'Partner_lookup__c',userId, accId, 'OwnerId', userId);
                BatchIterator biOpp = new BatchIterator('Opportunity', 'UM_PartnerAccount__c',userId, accId, 'OwnerId', userId);
                BatchIterator biBill = new BatchIterator('csconta__Billing_Account__c', 'csconta__Account__r.Partner_lookup__c', userId, accId, 'OwnerId', userId);
                
                BIArray.add(biAcc);
                BIArray.add(biOpp);
                BIArray.add(biBill);
            }

            system.debug('####Array before start of batch :' + BIArray);
            if(BIArray.size() > 0)
            {
                UpdateBatch batch = new UpdateBatch(BIArray,0);
                Database.executeBatch(batch);
            }
       }
       
}