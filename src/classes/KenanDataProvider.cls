/**
* TODO: ApexDoc.
*/
public class KenanDataProvider extends DataSource.Provider{

    public override DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams){
        KenanDataConnection extCon = new KenanDataConnection();

        return extCon;
    }
    
    public override List<DataSource.AuthenticationCapability> getAuthenticationCapabilities(){
            
        List<DataSource.AuthenticationCapability> capabilities = new List<DataSource.AuthenticationCapability>();
        capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);

        return capabilities;
    }
    
    public override List<DataSource.Capability> getCapabilities(){

        List<DataSource.Capability> capabilities = new List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.ROW_QUERY);
        capabilities.add(DataSource.Capability.ROW_CREATE);
        capabilities.add(DataSource.Capability.ROW_UPDATE);
        capabilities.add(DataSource.Capability.ROW_DELETE);
        //capabilities.add(DataSource.Capability.SEARCH);
        
        return capabilities;
    }
}