/**
* Custom Class for validating service status picklist values
*
* @author Godson Davidson Shanthini
* @story SFOM-245
* @since  20/01/2017
*/

public class LG_ConsoleSectionUtil {

    /*private List<RecordType> record {get; Set;}

    private List<RecordType> getRecordType(){
        if(this.record == null){
            this.record = getRecordTypeList();
        }

        return this.record;
    }*/

    public LG_ConsoleSectionUtil()
    {
        //getRecordType();
    }


    public List<SelectOption> getSelectOptionValues(String status, String recordType){
        List<SelectOption> options = new List<SelectOption>();
        boolean NativeRecord = false;
        if(status != null && status != ''){
            Map<String,List<String>> keyData = getKeyList();
            List<String> optionsList = keyData.get(recordType);
            //check record type exist or not
            if(optionsList !=null && optionsList.size() > 0){
                //Iterating the status list for the record type
                for(String option:optionsList){
                    if(option.equals(status)){
                        NativeRecord = true;
                    }
                    options.add(new SelectOption(option, option));
                }

                //if the status doesn't exist in the record type status list
                if(!NativeRecord){
                    //clear the list
                    options.clear();
                    //add only the input status in the selectoption list
                    options.add(new SelectOption(status, status));
                }

            }else{
                options.add(new SelectOption(status, status));
            }
        }else{
            options.add(new SelectOption('', 'None'));
        }

        return options;
    }


    /**
     * SFOM-356 To validate the service status
     */
    public  boolean validateServiceStatus(String status, String recordType){
        boolean flagStatus = false;
        //system.debug('recordType'+recordType);
        //system.debug('statu'+status);
        if(recordType == RECORD_PROVISION){
            flagStatus = validateStatus(status, provisionStatusList);
        }
        if(recordType == RECORD_ACTIVATESERVICE){
            flagStatus = validateStatus(status, ActivateStatusList);
        }
        if(recordType == RECORD_INSTALL){
            flagStatus = validateStatus(status, InstallStatusList);
        }
        if(recordType == RECORD_PROVISION_ONE_STEP){
            flagStatus = validateStatus(status, provisionOneStatusList);
        }
        return flagStatus;
    }

    /**
     * SFOM-578
     * Method to check any service is failed or not
     *
     **/
    public  boolean checkServiceFailed(String status, String recordType){
        boolean flagStatus = false;
        if(recordType == RECORD_PROVISION){
            flagStatus = validateStatus(status, provisionFailedList);
        }
        if(recordType == RECORD_ACTIVATESERVICE){
            flagStatus = validateStatus(status, ActivateFailedList);
        }
        if(recordType == RECORD_INSTALL){
            flagStatus = validateStatus(status, InstallFailedList);
        }//provisionOneFailedList 
        if(recordType == RECORD_PROVISION_ONE_STEP){
            flagStatus = validateStatus(status, provisionFailedList);
        }
        return flagStatus;
    }


    /**
     * SFOM-356 To validate the service status
     */
    private boolean validateStatus(String status, Integer[] allowedStatus){
        boolean statusFlag = false;
        for(Integer statusVal: allowedStatus){
            //System.debug('status'+status);
            //System.debug('statusList[statusVal]'+statusList[statusVal]);
            if(status == statusList[statusVal]){
                statusFlag = true;
                break;
            }
        }

        return statusFlag;
    }

    private Map<String,String[]> getKeyList(){
        Map<String,List<String>> keyMap = new Map<String,List<String>>();

        //Service status based on record type - Start
        //Record Type PROVISION
        List<String> provVal = new List<String>();
        provVal.add(statusList[REQUESTED]);
        provVal.add(statusList[TERMINATE_REQ]);//TERM_REQ added as a part of SFOM-750
        provVal.add(statusList[PROVISIONED]);
        provVal.add(statusList[PROVISIONINGFAILED]);
        //reqVal.add(statusList[CANCELLED]);
        keyMap.put(RECORD_PROVISION, provVal);

        //Record Type ACTIVATE SERVICE
        List<String> activatedVal = new List<String>();
        activatedVal.add(statusList[PROVISIONED]);
        activatedVal.add(statusList[ACTIVATED]);
        activatedVal.add(statusList[READYFORBILLING]);
        activatedVal.add(statusList[ACTIVATIONFAILED]);
        activatedVal.add(statusList[ACTIVE]);
        activatedVal.add(statusList[INACTIVE]);
        keyMap.put(RECORD_ACTIVATESERVICE, activatedVal);

        //Record Type INSTALL
        List<String> installVal = new List<String>();
        installVal.add(statusList[PROVISIONED]);
        installVal.add(statusList[ACTIVATED]);
        installVal.add(statusList[READYFORBILLING]);
        installVal.add(statusList[INSTALLATIONFAILED]);
        keyMap.put(RECORD_INSTALL, installVal);
        
        //Record Type PROVISION ONE STEP
        //Removed as a part of SFOM-1748
        /*List<String> provStepVal = new List<String>();
        //provStepVal.add(statusList[PROVISIONED]);
        provStepVal.add(statusList[REQUESTED]);
        provStepVal.add(statusList[READYFORBILLING]);
        //SFOM-1575
        provStepVal.add(statusList[ACTIVE]);
        provStepVal.add(statusList[INACTIVE]);
        keyMap.put(RECORD_PROVISION_ONE_STEP, provStepVal);*/

        /*//status READYFORBILLING
        List<String> rfBillVal = new List<String>();
        rfBillVal.add(statusList[READYFORBILLING]);
        rfBillVal.add(statusList[ACTIVE]);
        rfBillVal.add(statusList[INACTIVE]);
        rfBillVal.add(statusList[CANCELLED]);
        keyMap.put(STR_READYFORBILLING, rfBillVal);

        //status ACTIVE
        List<String> activelVal = new List<String>();
        activelVal.add(statusList[ACTIVE]);
        activelVal.add(statusList[CLOSEDREPLACED]);
        activelVal.add(statusList[CANCELLED]);
        keyMap.put(STR_ACTIVE, activelVal);*/

        //Service status based on record type - End

        return keyMap;
    }



    //Key value for Service status
    private integer REQUESTED = 0;
    private integer PROVISIONINGFAILED = 1;
    private integer PROVISIONED = 2;
    private integer ACTIVATIONFAILED = 3;
    private integer INSTALLATIONFAILED = 4;
    private integer ACTIVATED = 5;
    private integer READYFORBILLING = 6;
    private integer ACTIVE = 7;
    private integer INACTIVE = 8;
    private integer CLOSEDREPLACED = 9;
    private integer CANCELLED = 10;
    //SFOM-750
    private integer TERMINATE_REQ = 11;

    //Status
    private String STR_REQUESTED = 'Requested';
    private String STR_PROVISIONINGFAILED = 'Provisioning Failed';
    private String STR_PROVISIONED = 'Provisioned';
    private String STR_ACTIVATIONFAILED = 'Activation Failed';
    private String STR_INSTALLATIONFAILED = 'Installation Failed';
    private String STR_ACTIVATED = 'Activation Completed';
    private String STR_READYFORBILLING = 'Ready for Billing';
    private String STR_ACTIVE = 'Active';
    private String STR_INACTIVE = 'Inactive';
    private String STR_CLOSEDREPLACED = 'Closed Replaced';
    private String STR_CANCELLED = 'Cancelled';
    //SFOM-750
    private String STR_TERMINATIONREQUESTED = LG_Util.getServiceRequestDeactivateStatus();


    //Record types
    private String RECORD_PROVISION = 'Provision';
    private String RECORD_ACTIVATESERVICE = 'Activate Service';
    private String RECORD_INSTALL = 'Install';
    private String RECORD_ACCESSPLANNING = 'Access Planning';
    private String RECORD_NUMBERPORTING = 'Number Port';
    private String RECORD_PROVISION_ONE_STEP = 'Provision One Step';


    //Status List
    private String[] statusList = new String[]{STR_REQUESTED,STR_PROVISIONINGFAILED,STR_PROVISIONED,
        STR_ACTIVATIONFAILED,STR_INSTALLATIONFAILED,STR_ACTIVATED,STR_READYFORBILLING,
        STR_ACTIVE,STR_INACTIVE,STR_CLOSEDREPLACED,STR_CANCELLED,STR_TERMINATIONREQUESTED};

    //Allowed Service status for Record type
    private Integer[] provisionStatusList = new Integer[]{PROVISIONINGFAILED,PROVISIONED};
    private Integer[] provisionOneStatusList = new Integer[]{READYFORBILLING,ACTIVE,INACTIVE};
    private Integer[] ActivateStatusList = new Integer[]{ACTIVATED,ACTIVATIONFAILED,READYFORBILLING,INSTALLATIONFAILED,ACTIVE,INACTIVE};
    private Integer[] InstallStatusList = new Integer[]{INSTALLATIONFAILED,READYFORBILLING,ACTIVATIONFAILED};

    //Allowed Service faliure status for Record type
    private Integer[] provisionFailedList = new Integer[]{PROVISIONINGFAILED};
    private Integer[] provisionOneFailedList = new Integer[]{PROVISIONINGFAILED};
    private Integer[] ActivateFailedList = new Integer[]{ACTIVATIONFAILED, PROVISIONINGFAILED, INSTALLATIONFAILED};
    private Integer[] InstallFailedList = new Integer[]{INSTALLATIONFAILED, PROVISIONINGFAILED, ACTIVATIONFAILED};









}