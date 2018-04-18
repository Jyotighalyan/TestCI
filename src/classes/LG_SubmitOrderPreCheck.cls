/**
 * Class for Validation before SUbmit Order
 * called (on click of Validate order Button on Oppty Detail Page.
 *part of SFOM-81 
 * @author Alisha
 * @since  27/02/2017
 */


global class LG_SubmitOrderPreCheck{
    //added as part of sfom-81
    public static LG_ValidateOpportunityUtil validatorClass=null;
    public static LG_ValidateOpportunity__c val = LG_ValidateOpportunity__c.getInstance(UserInfo.getUserId());
    public static string getClass_name(){
      if(val!=null &&val.Class_Name__C!=null){
          Type appropriateClass = Type.forName(val.Class_Name__C);
          validatorClass= (LG_ValidateOpportunityUtil) appropriateClass.newInstance();
         
          system.debug('validator=='+validatorClass);
            }
        return null;
    }
    webservice static Integer countOrder(Id recId){
        Integer orderCount =0;
        System.debug('------Method called on button click.....');
        orderCount=[select count() from csord__Order__c where csordtelcoa__Opportunity__c=:recId];
    
        return orderCount;
    }

   
    webservice static Integer prodBaksetPresent(Id recId){
       getClass_name(); 
       Integer prodBasketCount=1; 
       prodBasketCount=validatorClass.checkProductBasket(recId);
       
       system.debug('prodBasketCount=='+prodBasketCount);
       
       return prodBasketCount;

    }
}