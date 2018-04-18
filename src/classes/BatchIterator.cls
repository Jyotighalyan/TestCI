/*********************************************************************************
* BatchIterator
*
* 2017/07/06 V 1.0. UMR-2093 Matthias Pfaff Helper Class for OwnershipChangeScheduler
*
*
*
*
*********************************************************************************/


public class BatchIterator
{
    public String query;
    public String objectname;
    public String field;
    public String value;
    
    public BatchIterator(string obj, string pfieldname, string userId, string accId, string fie, string val)
    {
       query = 'Select id, Ownerid from ' +obj+' where '+pfieldname+' = \''+ accId +'\' and OwnerId != \''+ userId+'\'';
       objectname = obj;
       field = fie;
       value = val;
    }
    


}