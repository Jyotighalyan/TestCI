@isTest
public class LG_EventSF1ControllerTest {
    
    public static testMethod void test1(){
        ApexPages.StandardController sc = new ApexPages.StandardController(prepareData().get(0));
        LG_EventSF1Controller controller = new LG_EventSF1Controller(sc);
        
                
        List<SelectOption> result1 = controller.getMenuOptions();
        system.assert(!result1.isEmpty());
        
        List<LG_EventSF1Controller.EventWrapper> result2;
        for(String s : controller.ViewList){
            controller.selectedVal = s;
            result2 = controller.getFilteredWEvents();
            system.assert(!result2.isEmpty());
        }
        
        Pagereference result3 = controller.go();
        system.assertEquals(null, result3);
        
    }
    
    private static List<Event> prepareData(){
        List<Event> le = new List<Event>();
        DateTime whenDate = DateTime.now();
        //past event
        le.add(new Event(OwnerId = UserInfo.getUserId(), StartDateTime = whenDate.addDays(-1), EndDateTime = whenDate.addDays(-1),Subject = 'Past event'));
        //today event 
        le.add(new Event(OwnerId = UserInfo.getUserId(), StartDateTime = whenDate, EndDateTime = whenDate, Subject = 'Today event'));
        //tomorrow event
        le.add(new Event(OwnerId = UserInfo.getUserId(), StartDateTime = whenDate.addDays(+1),EndDateTime = whenDate.addDays(+1),Subject = 'Future event'));
        insert le;
        return le;
    }
}