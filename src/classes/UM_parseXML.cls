global class UM_parseXML
{
    global static List<workOrderSummary> woSummaryparseXML(String xml)
    { 
        List<workOrderSummary> wosu = new List<workOrderSummary>();
        String accountNumber;
        String workOrderNumber;
        String status;
        String dateEntered;
        String startBillDate;
        String checkInDate;
        String scheduleDate;
        String category;
        String orderclass;
        String activationDate;
        String installationDate;
        String errors; 
        
        //instantiate the new dom parser & load request string
        Dom.Document doc = new Dom.Document();
        doc.load(xml);        
        
        for(Dom.XmlNode root: doc.getRootElement().getChildElements() )
        {
            for(Dom.XmlNode child : root.getchildelements())
            {
                system.debug('---name'+child.getName());
                if (child.getNamespace() == null &&  child.getName() == 'accountNumber') 
                {
                    accountNumber= child.getText();
                    system.debug('***accountNumber'+accountNumber);
                }            
                
                if (child.getNamespace() == null &&  child.getName() == 'workOrderSummary') 
                {
                    if(child.getChildElement('workOrderNumber',null)!=null)
                    {
                        workOrderNumber= child.getChildElement('workOrderNumber', null).getText();
                    }   system.debug('***workOrderNumber'+workOrderNumber);
                    
                    if(child.getChildElement('status',null)!=null)
                    {
                        status= child.getChildElement('status', null).getText();
                    }
                    if(child.getChildElement('dateEntered',null)!=null)
                    {
                        dateEntered= child.getChildElement('dateEntered', null).getText();
                    }
                    
                    system.debug('**dateEntered'+dateEntered);  
                    if(child.getChildElement('status',null)!=null)
                    {         
                        startBillDate= child.getChildElement('startBillDate', null).getText();
                    }
                    if(child.getChildElement('checkInDate',null)!=null)
                    {
                        checkInDate= child.getChildElement('checkInDate', null).getText();
                    }
                    
                    if(child.getChildElement('scheduleDate',null)!=null)
                    {          
                        scheduleDate= child.getChildElement('scheduleDate', null).getText();
                    }
                    system.debug('**scheduleDate'+scheduleDate);
                    if(child.getChildElement('category',null)!=null)
                    {
                        category= child.getChildElement('category', null).getText();
                    }
                    if(child.getChildElement('orderClass',null)!=null)
                    {
                        orderClass= child.getChildElement('orderClass', null).getText();
                    }
                    if(child.getChildElement('activationDate',null)!=null)
                    {
                        activationDate= child.getChildElement('activationDate', null).getText();
                    }
                    if(child.getChildElement('installationDate',null)!=null)
                    {
                        installationDate= child.getChildElement('installationDate', null).getText();
                    }
                    if(child.getChildElement('errors',null)!=null)
                    {
                        errors= child.getChildElement('errors', null).getText();
                    }
                    
                    //Adding values WorkorderSummary Wrapper
                    wosu.add(new workOrderSummary(workOrderNumber,status,dateEntered,startBillDate,checkInDate,scheduleDate,category,orderclass,activationDate,installationDate,errors));
                    system.debug('--wosu'+wosu);
                }
            }
        }
        
        return wosu;
    } 
    
    //method to get outletlist
    global static List<OutletEquipment> outletParseXML(String xml)
    {      
        List<OutletEquipment > outletList = new List<OutletEquipment >();        
        Map<String,List<OutletEquipment>> outletMap = new Map<String,List<OutletEquipment>>();
        String customerNumber;
        
        //instantiate the new dom parser & load request string
        Dom.Document doc = new Dom.Document();
        doc.load(xml); 
        
        for(Dom.XmlNode root : doc.getRootElement().getChildElements() )
        {         
            system.debug('**root'+ root.getname());
            Dom.XmlNode checkforCustomer = root.getChildElement('customerEquipment',null);
            if(checkforCustomer!=null)
            {
                for(Dom.XmlNode ch :  root.getChildElement('customerEquipment',null).getchildelements())
                {
                    system.debug('**chaname'+ch.getname());
                    if(ch.getname()=='customerNumber')
                    {
                        customerNumber= ch.getText();
                    }
                    system.debug('**customerNumber'+customerNumber);
                    outletList.addall(parseChildElement(customerNumber,ch));
                    system.debug('**outletList'+outletList);
                }  
            }   
        }
        
        return outletList;
    } 
    
    global static List<OutletEquipment> parseChildElement(String acctNo,dom.xmlnode nodes)
    {
        system.debug('**acctNo'+acctNo);
        system.debug('**nodes'+nodes);
        
        List<OutletEquipment > outWrapList = new List<OutletEquipment >();
        Map<string,list<OutletEquipment>> outMap = new Map<string,list<OutletEquipment>>();
        
        String accountNumber;
        String workOrderNumber;
        String status;
        String dateEntered;
        String startBillDate;
        String checkInDate;
        String scheduleDate;
        String category;
        String orderclass;
        String activationDate;
        String installationDate;
        String errors; 
        String customerNumber;
        String outletId;        
        String internetOccurence;
        String telcoPort1Occurence;
        String macAddressOccurence;
        String macAddressDateOccurence;
        String stbType;
        String stbSerialNumber;
        String stbLocation;
        String stbDescription;
        String hardPair;
        String fritzBoxInstallDate;
        String fritzBoxInternalOccurence;
        String mtacmSerialNumber;
        String mtaStaticIpAddress;
        String mtaIpSolution;
        String mtaIpSolutionDesc;
        String MTADescription;
        
        for( Dom.XmlNode child: nodes.getchildelements())
        {
            system.debug('**--*childname'+child.getname());
            
            for(Dom.XmlNode gchild: child.getchildelements())
            {
                system.debug('**--*gchildname'+gchild.getname());
                
                if(gchild.getname()=='outletId')
                {
                    outletId= gchild.getText();
                }
                if(gchild.getname()=='internetOccurence')
                {
                    internetOccurence= gchild.getText();
                } 
                system.debug('**--*internetOccurence'+internetOccurence);
                
                if(gchild.getname()=='telcoPort1Occurence')
                {
                    telcoPort1Occurence= gchild.getText();
                }
                if(gchild.getname()=='macAddressOccurence')
                {
                    macAddressOccurence= gchild.getText();
                }
                if(gchild.getname()=='macAddressDateOccurence')
                {
                    macAddressDateOccurence= gchild.getText();
                }
                if(gchild.getname()=='stbType')
                {
                    stbType= gchild.getText();
                }
                if(gchild.getname()=='stbSerialNumber')
                {
                    stbSerialNumber= gchild.getText();
                }
                if(gchild.getname()=='stbLocation    ')
                {
                    stbLocation= gchild.getText();
                }
                if(gchild.getname()=='stbDescription')
                {
                    stbDescription= gchild.getText();
                }
                if(gchild.getname()=='hardPair')
                {
                    hardPair= gchild.getText();
                }
                if(gchild.getname()=='fritzBoxInstallDate')
                {
                    fritzBoxInstallDate= gchild.getText();
                }
                if(gchild.getname()=='fritzBoxInternalOccurence')
                {
                    fritzBoxInternalOccurence= gchild.getText();
                } 
                
                if(gchild.getname()=='mtaStaticIpAddress')
                {
                    mtaStaticIpAddress= gchild.getText();
                }
                if(gchild.getname()=='mtaIpSolution')
                {
                    mtaIpSolution= gchild.getText();
                }
                if(gchild.getname()=='mtaIpSolutionDesc')
                {
                    mtaIpSolutionDesc= gchild.getText();
                }
                if(gchild.getname()=='MTADescription')
                {
                    MTADescription= gchild.getText();
                }  
            }
            outWrapList.add(new OutletEquipment(acctNo,outletId,internetOccurence,telcoPort1Occurence,macAddressOccurence,macAddressDateOccurence,stbType,stbSerialNumber,stbLocation,stbDescription,hardPair,fritzBoxInstallDate,fritzBoxInternalOccurence,mtacmSerialNumber,mtaStaticIpAddress,mtaIpSolution,mtaIpSolutionDesc,MTADescription)); 
        }
        
        system.debug('****outWrapList'+outWrapList);
        
        return outWrapList;
    }
    
    //wrapper for workorder summary nodes    
    global class workOrderSummary
    {
        public string workOrderNumber {set;get;}
        public string status          {set;get;}
        public string dateEntered     {set;get;}
        public string startBillDate   {set;get;}
        public string checkInDate     {set;get;}
        public string scheduleDate    {set;get;}
        public string category        {set;get;}
        public string orderclass      {set;get;}
        public string activationDate  {set;get;}
        public string installationDate{set;get;}
        public string errors          {set;get;}
        
        global workOrderSummary(String workOrderNumber, String status, String dateEntered, String startBillDate, 
                                String checkInDate, String scheduleDate, String category, String orderclass, 
                                String activationDate, String installationDate, String errors)
        {
            this.workOrderNumber = workOrderNumber; 
            this.status = status;            
            this.dateEntered = dateEntered;       
            this.startBillDate = startBillDate;     
            this.checkInDate   = checkInDate;  
            this.scheduleDate  = scheduleDate;
            this.category      = category;         
            this.orderclass    = orderclass;      
            this.activationDate = activationDate;     
            this.installationDate = installationDate;   
            this.errors = errors;      
        }
    }
    
    //wrapper class for outletEquipment
    global class OutletEquipment
    {       
        public String customerNumber 		  {set;get;}       
        public String outletId                {set;get;}
        public String internetOccurence       {set;get;}
        public String telcoPort1Occurence     {set;get;}
        public String macAddressOccurence     {set;get;}
        public String macAddressDateOccurence {set;get;}
        public String stbType                 {set;get;}
        public String stbSerialNumber         {set;get;}
        public String stbLocation             {set;get;}
        public String stbDescription          {set;get;}
        public String hardPair                {set;get;}
        public String fritzBoxInstallDate     {set;get;}
        public String fritzBoxInternalOccurence{set;get;}
        public String mtacmSerialNumber        {set;get;}
        public String mtaStaticIpAddress       {set;get;}
        public String mtaIpSolution            {set;get;}
        public String mtaIpSolutionDesc        {set;get;}
        public String MTADescription           {set;get;} 
        
        global OutletEquipment(String customerNumber, String outletId, String internetOccurence, String telcoPort1Occurence, 
                               String macAddressOccurence, String macAddressDateOccurence, String stbType,String stbSerialNumber, 
                               String stbLocation, String stbDescription, String hardPair, String fritzBoxInstallDate, 
                               String fritzBoxInternalOccurence, String mtacmSerialNumber, String mtaStaticIpAddress, 
                               String mtaIpSolution, String mtaIpSolutionDesc, String MTADescription)
        {
            this.customerNumber = customerNumber ;  
            this.outletId = outletId;
            this.internetOccurence = internetOccurence;
            this.telcoPort1Occurence = telcoPort1Occurence;
            this.macAddressOccurence = macAddressOccurence;
            this.macAddressDateOccurence = macAddressDateOccurence;
            this.stbType = stbType;
            this.stbSerialNumber = stbSerialNumber;
            this.stbLocation = stbLocation;
            this.stbDescription = stbDescription;
            this.hardPair = hardPair;
            this.fritzBoxInstallDate = fritzBoxInstallDate;
            this.fritzBoxInternalOccurence = fritzBoxInternalOccurence;
            this.mtacmSerialNumber = mtacmSerialNumber;
            this.mtaStaticIpAddress = mtaStaticIpAddress;
            this.mtaIpSolution = mtaIpSolution;
            this.mtaIpSolutionDesc = mtaIpSolutionDesc;
            this.MTADescription = MTADescription;
        } 
    }  
}