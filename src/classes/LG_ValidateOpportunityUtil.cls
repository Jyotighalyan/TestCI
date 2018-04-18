/**
* 
* abstract Class to call all opportunity validations as part of SFOM-81
* @author Alisha
* @since  27/02/2017
*
*/

public abstract class LG_ValidateOpportunityUtil{

public  abstract Boolean ValidateOpportunityUtil(Opportunity OppObj);
public  abstract Integer checkProductBasket(Id recId);
public  abstract Boolean ValidateAdminContact(Opportunity OppObj);
public  abstract String DDmandateCheck(Opportunity OppObj);
public  abstract integer servicecasecheck(Id recId);
public  abstract integer SCCategorycheck(Id recId);
public  abstract list<case> getSCCase(Id recId);
public  abstract Boolean ValidatePrimaryContact(Opportunity OppObj);

 }