public interface LG_AddressValidation {
    
    void retrieveSearchSettings(String objectName, String country);
    void findAddress();
    void findAddressLocal();
    void sequenceSearch();
    
    pageReference setAddress();
    pageReference cancel();
}