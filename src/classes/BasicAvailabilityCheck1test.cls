@isTest
public class BasicAvailabilityCheck1test {
    public static testmethod void availabilitytest(){
        test.startTest();
        BasicAvailabilityCheck1.doWork('11111');
        
        test.stopTest();
    }
    public static testmethod void availtest(){
        test.startTest();
        
        BasicAvailabilityCheck1.doWork('11');
        
        test.stopTest();
    }
}