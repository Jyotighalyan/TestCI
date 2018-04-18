public class LG_OpenCloudSenseController 
{
    public String pageTitle {get;set;}
    public String leadID {get;set;}
    public String redirectUrl {public get; private set;}


    public ApexPages.StandardController standardController {get; set;}

    public LG_OpenCloudSenseController(ApexPages.StandardController controller) 
    {
        this.leadID = ApexPages.currentPage().getParameters().get('id');
        pageTitle = 'Open Cloudsense Anywhere'; 
        this.redirectUrl = 'cloudsenseanywhere://entity/viewDetails?id=' + this.leadID;
    }
    


    public PageReference openCloudsense() 
    {
        PageReference cloudsenseAnywhereApp = new PageReference('cloudsenseanywhere://entity/viewDetails?id=' + this.leadID);
        //PageReference cloudsenseAnywhereApp = new PageReference('http://www.google.com/q?=' + this.leadID);
        cloudsenseAnywhereApp.setRedirect(true);
        return cloudsenseAnywhereApp;
    }

}