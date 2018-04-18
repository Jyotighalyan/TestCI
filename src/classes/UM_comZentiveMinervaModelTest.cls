/**
 *Test Class for UM_comZentiveMinervaModelWebserviceDat
 * 
 * @author Preetha N
 * @since  24/10/2017
*/
@isTest
public class UM_comZentiveMinervaModelTest {
    public static testmethod void modtest(){
        test.startTest();
        
        UM_comZentiveMinervaModelWebserviceDat webdat=new UM_comZentiveMinervaModelWebserviceDat();
        UM_comZentiveMinervaModelWebserviceDat.saleUPCList sal=new UM_comZentiveMinervaModelWebserviceDat.saleUPCList();
        UM_comZentiveMinervaModelWebserviceDat.serviceGroup grp=new UM_comZentiveMinervaModelWebserviceDat.serviceGroup();
        UM_comZentiveMinervaModelWebserviceDat.serviceGroups_element ele=new UM_comZentiveMinervaModelWebserviceDat.serviceGroups_element();
        UM_comZentiveMinervaModelWebserviceDat.upcSale salup=new UM_comZentiveMinervaModelWebserviceDat.upcSale();
        test.stopTest();
        
    }

}