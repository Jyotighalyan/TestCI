public class LG_OpportunityStageCache 
{
	private static Map<String,Double> mapStageNameDefaultPercentage;
	
	static
    {
    	string Key;
    	string KeyDeveloper;
    	string Value;
    	
    	if (mapStageNameDefaultPercentage==null)
    	{
    		List<OpportunityStage>  lstOpportunityStage=[select DefaultProbability, Id, IsActive, IsClosed, IsWon, MasterLabel from OpportunityStage];
    		
    		mapStageNameDefaultPercentage = new Map<string,double>();
    		
    		
    		for (OpportunityStage tmpOS : lstOpportunityStage)
    		{    			    
    			mapStageNameDefaultPercentage.put(tmpOS.MasterLabel ,tmpOS.DefaultProbability);
    		}	
    	}
    }
    
    public static double DefaultProbability(string StageName)
    {
    	double result=0;
    	
    	if (mapStageNameDefaultPercentage.containsKey(StageName))
    	{
    		result=mapStageNameDefaultPercentage.get(StageName);
    	}
    	
    	return 	result;
    }
}