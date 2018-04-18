/*********************************************************************************
* UpdateBatch
*
* 2017/07/06 V 1.0. Matthias Pfaff UMR-2093 Helper Class for OwnershipChangeScheduler
*
*
*
*
*********************************************************************************/


public class UpdateBatch implements Database.Batchable<sObject>
{
   public final String Query;
   public final String Field;
   public final String Value;
  // not needed yet
   public final String objectname; 
   
   private Integer index;
   private BatchIterator[] biArr;  

   public UpdateBatch(BatchIterator[] biArray,Integer i)
   {
     
      biArr =  biArray;
      BatchIterator bi = biArr[i];
      
      Query=bi.query; 
      Field=bi.field;
      Value=bi.value;
      objectname = bi.objectname;
      index = i;
   }
   
   public UpdateBatch(String q, String f, String v, String o)
   {
        Query = q;
        Field = f;
        Value = v;
        objectname = o;
   }

   public Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext BC, List<sObject> scope)
   {
         //with object optionally also on object cast can be done. to be implemented still
         for(sobject s : scope)
         {
            s.put(Field,Value); 
         }
        update scope;
   }

   public void finish(Database.BatchableContext BC)
   {
        //start new update job if the queue from the array was not yet finished
         ++index;
        if(index < biArr.size())
        {
           UpdateBatch batch = new UpdateBatch(biArr, index);
           Database.executeBatch(batch);
        }
   }
}