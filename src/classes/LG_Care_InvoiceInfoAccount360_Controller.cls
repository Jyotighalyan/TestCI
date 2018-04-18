/************************************************************************************************************************************
*        Class: LG_Care_InvoiceInfoAccount360_Controller 
*     Program : B2B CARE CATALYST PROGRAM
*  Description: controller Class for vf page displayed on account layout as console component .
*    Author(s): Rishi Kapoor (Infosys Limited)
* Created Date: 06-JUNE-2017
*   Test Class: LG_Care_InvoiceInfoAccount360_Test & LG_GeneralTest 
*************************************************************************************************************************************/



global class LG_Care_InvoiceInfoAccount360_Controller {
    private String accountId{get;set;}
    public List<InvoiceWrapper> wrapperList{get;set;}
    public list<UM_InvoiceHeader__c>Invoiceid;
    public List<Payment> paymentsList;
    private Set<Id> billingIds{get;set;}
    private Set<Id> invoiceHeaders{get;set;}
    public LG_Care_InvoiceInfoAccount360_Controller(ApexPages.StandardController controller) {
    try{
        accountId = controller.getId();
      
        if(accountId != null){
            invoiceRecords();
            findRelatedRecords();
        }
        }
             catch(Exception e) {
        }
    }
    
    
    
    private void invoiceRecords(){
    
    try{
        wrapperList = new List<InvoiceWrapper>();
        billingIds = new Set<Id>();
        
        for(csconta__Billing_Account__c bill :
                    [SELECT Id,LG_BillingAccountNumber__c,
                    (SELECT Name,UM_Invoice_Amount_Gross_Currency__c,UM_Invoice_Date__c,UM_Payment_Due_Date__c from Invoice_Headers__r order by UM_Payment_Due_Date__c desc limit 3)
                    from csconta__Billing_Account__c where csconta__Account__c =: accountId])
       if(bill !=null)
       {
            
            InvoiceWrapper wrapperInstance = new InvoiceWrapper();
            
            if(bill.Id !=null)
            {
            wrapperInstance.billingId = bill.Id;
            }
            if(bill.LG_BillingAccountNumber__c !=null )
            {
            wrapperInstance.billingNumber = bill.LG_BillingAccountNumber__c;
            }
           
               wrapperInstance.invoiceList = new List<UM_InvoiceHeader__c>();
               wrapperInstance.invoiceList.addAll(bill.Invoice_Headers__r);
            
              wrapperList.add(wrapperInstance);
              billingIds.add(bill.Id);
        
        
        
        }
        }
             catch(Exception e) {
        }
    }
    
    private void findRelatedRecords(){
    try{
        paymentsList = new List<Payment>();
        findPayments();
        findInvoices();
        //findAdjustments();
        
        Map<Id, List<Payment>> paymentMap = new Map<Id, List<Payment>>();
        for(Payment eachPayment : paymentsList){
            if(eachPayment.billingId != null && paymentMap.containsKey(eachPayment.billingId)){
                List<Payment> tempPaymentList = paymentMap.get(eachPayment.billingId);
                tempPaymentList.add(eachPayment);
                paymentMap.put(eachPayment.billingId, tempPaymentList);
            }
            else if(eachPayment.billingId != null){
                paymentMap.put(eachPayment.billingId, new List<Payment>{eachPayment});
            }
        }
        
       
        
        for(Id billId : paymentMap.keySet()){
            calculateBalance(billId, paymentMap.get(billId));
        }
        
        }
        
             catch(Exception e) {
        }
    }
    
    private void findPayments() {
        try{
        if(billingIds != null && billingIds.size() > 0) {
            
            // CREDIT UM_Transaction_Amount__c
            for(UM_PaymentInformation__c tmpPayment :  [SELECT id, UM_Transaction_Date_Converted__c, UM_Transaction_Date__c, UM_Transaction_Amount__c, UM_Transaction_Amount_Currency__c, 
                                                        UM_Transaction_ID__c, UM_Transaction_Status_Translation__c, UM_Overpayments__c, UM_Transaction_Status__c, UM_Billing_Location__c 
                                                        FROM UM_PaymentInformation__c 
                                                            WHERE UM_Billing_Location__c IN: billingIds 
                                                            ORDER BY UM_Transaction_Date_Converted__c DESC]){

            

                    // format date
                    Date paymentDateTmp = Date.newInstance( 
                        tmpPayment.UM_Transaction_Date_Converted__C.year(),
                        tmpPayment.UM_Transaction_Date_Converted__C.month(),
                        tmpPayment.UM_Transaction_Date_Converted__C.day() 
                    );

                    Payment newPayment = 
                        new Payment(
                                tmpPayment.Id, 
                                String.valueOf( paymentDateTmp ),
                                paymentDateTmp,
                                'Payment ' + tmpPayment.UM_Transaction_ID__c );
                
                    // payment reversal are on debit side - quick fix 
                    if(tmpPayment.UM_Transaction_Status__c == '5') {
                        newPayment.debit = tmpPayment.UM_Transaction_Amount_Currency__c;
                    } else {
                        newPayment.credit = tmpPayment.UM_Transaction_Amount_Currency__c;
                    }
                    newPayment.overpayment = tmpPayment.UM_Overpayments__c;

                    newPayment.paymentStatus = tmpPayment.UM_Transaction_Status_Translation__c;
                    newPayment.paymentType = 'payment';
                    if(tmpPayment.UM_Transaction_Status__c != null)
                        newPayment.paymentNumStatus = Integer.valueOf( tmpPayment.UM_Transaction_Status__c );
                    newPayment.billingId = tmpPayment.UM_Billing_Location__c;

                    paymentsList.add( newPayment );
                
            }
        }
      }
      
      catch(Exception e) {
      }  
      
      
    }
    
    private void findInvoices() {
        invoiceHeaders = new Set<Id>();
        try{
        if(billingIds != null && billingIds.size() > 0) {

            
           for(UM_InvoiceHeader__c tmpInvoice : [SELECT id, UM_Invoice_Date__c, UM_Invoice_Amount_Net_Currency__c, UM_Invoice_Amount_Gross_Currency__c, UM_InvoiceNumber__c, UM_Backout_Status__c,UM_Billing_Location__c 
                                                        FROM UM_InvoiceHeader__c 
                                                            WHERE UM_Billing_Location__c IN: billingIds ORDER BY UM_Invoice_Date__c DESC]){
               

                    if(tmpInvoice.UM_Backout_Status__c != '1002') {

                        invoiceHeaders.add( tmpInvoice.Id );

                        Payment newInvoice = new Payment(
                                tmpInvoice.Id, 
                                String.valueOf( tmpInvoice.UM_Invoice_Date__c ),
                                tmpInvoice.UM_Invoice_Date__c,
                                'Invoice ' + tmpInvoice.UM_InvoiceNumber__c);

                        newInvoice.invoiceNumber = tmpInvoice.UM_InvoiceNumber__c;
                        newInvoice.debit = tmpInvoice.UM_Invoice_Amount_Net_Currency__c;
                        newInvoice.paymentType = 'invoice'; 
                        newInvoice.billingId = tmpInvoice.UM_Billing_Location__c;            

                        paymentsList.add( newInvoice );
                    }

                
            }
        }
       }
      catch(Exception e) {
        } 
    }
    
     private void calculateBalance(Id billingId, List<Payment> paymentsList) {
        Boolean f = TRUE;
        Decimal currentBalance = 0.00;
        
        for(Payment eachPayment : paymentsList){
            if(eachPayment.credit == null) eachPayment.credit = 0;
            if(eachPayment.debit == null) eachPayment.debit = 0;
            
            if(f == TRUE) {
                currentBalance = eachPayment.credit + eachPayment.debit;
                f = FALSE;
            } else {
                currentBalance = currentBalance + eachPayment.credit + eachPayment.debit;
            }
        }
        
        for(InvoiceWrapper eachWrap : wrapperList){
            if(eachWrap.billingId == billingId ){
                eachWrap.balance = currentBalance;
                
            }
            
        }
        
    }
  
    
    Public class InvoiceWrapper{
        public String billingId{get;set;}
        public String billingNumber{get;set;}
        public Decimal balance{get;set;}
        public List<UM_InvoiceHeader__c> invoiceList{get;set;}
    }
    
    global class Payment implements Comparable {

        public Id paymentId {get;set;}
        public Id billingId{get;set;}
        public String paymentDate {get;set;}
        public Date paymentDateOrg {get;set;}
        public String paymentDescription {get;set;}
        public String paymentStatus {get;set;}
        public String invoiceNumber {get;set;}
        public Decimal credit {get;set;}
        public Decimal debit {get;set;}
        public Decimal balance {get;set;}
        public Decimal overpayment {get;set;}
        public String paymentType {get;set;}
        public Integer paymentNumStatus {get;set;}

        //String ts , Decimal crd, Decimal deb, Decimal bal, Decimal op
        public Payment(Id pid, String pdate, Date pdateo, String pdescr) {

            paymentId = pid;
            paymentDate = pdate;
            paymentDateOrg = pdateo;            
            paymentDescription = pdescr;

            credit = 0.00;
            debit = 0.00;
            balance = 0.00;
            overpayment = 0.00;
        }
         
         public payment(){}

        global Integer compareTo(Object objToCompare) {
    
            Payment other = (Payment) objToCompare;
            if (this.paymentDateOrg > other.paymentDateOrg)
                return -1;
            else if (this.paymentDateOrg == other.paymentDateOrg)
                return 0;
            
            return 1;
        }
    }
}