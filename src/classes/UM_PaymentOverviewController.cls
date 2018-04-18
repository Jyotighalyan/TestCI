global class UM_PaymentOverviewController {

	public List<Id> invoiceHeaders {
		get {
			if(invoiceHeaders == null) {
				invoiceHeaders = new List<Id>();
			}

			return invoiceHeaders;
		}
		set;
	}

	public List<Payment> paymentsList {
		get{
			if(paymentsList == null) {
				paymentsList = new List<Payment>();
			}

			return paymentsList;
		}
		set;
	}

	public List<String> invoicesToFilter {
		get{
			if(invoicesToFilter == null){
				invoicesToFilter = new List<String>();
			}

			return invoicesToFilter;
		}
		set;
	}

	public Id recordIdAttribute {
		get;
		set {
			if(recordIdAttribute == null) {

				recordIdAttribute = value;
	            getPayments();
	            getInvoices();
	            getAdjustments();

	            paymentsList.sort();

	            calculateBalance();
	        }
		}
	}

    public UM_PaymentOverviewController() {
        // Do Nothing
    }

    private void calculateBalance() {

    	Integer lSize = paymentsList.size();
    	if(lSize > 0) {

    		Boolean f = TRUE;
    		Decimal currentBalance = 0.00;
    		for (Integer i=lSize-1; i>=0; i--) {
                //changed below If condition for Payment Type- BHP-50
                if(paymentsList[i].paymentType != 'AdjustmentNotEffectingBalance') {
                    
                    if(paymentsList[i].credit == null) paymentsList[i].credit = 0;
                    if(paymentsList[i].debit == null) paymentsList[i].debit = 0;
                    
                    if(f == TRUE) {
                        currentBalance = paymentsList[i].credit + paymentsList[i].debit;
                        f = FALSE;
                    }
                    // INC INC000001662715 fix (Calculate balance only if status is Posted,Deleted,Payment Reversal & Disconnected Account Record) 
                    //added Payment Type for Adjustment - BHP-50
                    else if(f == false && (paymentsList[i].paymentType == 'AdjustmentEffectingBalance' || paymentsList[i].paymentStatus == null || paymentsList[i].paymentStatus == 'Deleted' || paymentsList[i].paymentStatus == 'Posted' || paymentsList[i].paymentStatus == 'Payment Reversal' || paymentsList[i].paymentStatus == 'Disconnected Account Record')){
                        currentBalance = currentBalance + paymentsList[i].credit + paymentsList[i].debit;
                    }
                } 
                paymentsList[i].balance = currentBalance;                                        
            }
            
            for (Integer i=lSize-1; i>=0; i--) {
                
                Payment payment = paymentsList[i];
                for(String iFilter : invoicesToFilter) {
                    if(payment.invoiceNumber == iFilter) {
                        paymentsList.remove( i );
                    }
                }
            }
        }
    }

    private void getAdjustments() {
        
        if(recordIdAttribute != null) {
            //edited below query for BHP-50
            // CREDIT UM_Transaction_Amount__c
            List<Kenan_Adjustment__c> adjustments = [SELECT id, Name, Adjustment_Type__c, Approval_Status__c, Invoice_Header__c, Total_Amount__c, requestStatus__c, Effective_Date__c,
                                                     UM_Received_from_Billing_System__c,UM_Affects_Balance__c      
                                                     FROM Kenan_Adjustment__c 
                                                     WHERE Invoice_Header__c IN :invoiceHeaders 
                                                     ORDER BY CreatedDate DESC];
            
            if(adjustments.size() > 0) {
                for(Kenan_Adjustment__c tmpAdjustment : adjustments) {
                    
                    Payment newAdjustment = new Payment(
                        tmpAdjustment.Id, 
                        String.valueOf( tmpAdjustment.Effective_Date__c ),
                        tmpAdjustment.Effective_Date__c,
                        'Adjustment ' + tmpAdjustment.Name );
                    
                    newAdjustment.paymentStatus = tmpAdjustment.requestStatus__c;
                    /**added below IF conditions for Adjustments coming from Kenan- BHP-50**/
                    if(tmpAdjustment.UM_Received_from_Billing_System__c)
                    {
                        if(tmpAdjustment.Total_Amount__c < 0)
                           newAdjustment.credit = tmpAdjustment.Total_Amount__c;
                        else
                           newAdjustment.debit = tmpAdjustment.Total_Amount__c;
                    }
                    else
                        newAdjustment.credit = tmpAdjustment.Total_Amount__c * -1;
                    
                    if(tmpAdjustment.UM_Affects_Balance__c &&  tmpAdjustment.UM_Received_from_Billing_System__c)
                        newAdjustment.paymentType = 'AdjustmentEffectingBalance';
                    else 
                        newAdjustment.paymentType = 'AdjustmentNotEffectingBalance';
                        
                    /***BHP-50 ends ***/  
                    //below added for BHP-78
                    newAdjustment.affectsBalance = tmpAdjustment.UM_Affects_Balance__c;
                    newAdjustment.receivedFromBilling =  tmpAdjustment.UM_Received_from_Billing_System__c;
                    //changes for BHP-78 ends 
                    paymentsList.add( newAdjustment );
                }
            }
        }           
    }

    private void getInvoices() {

    	if(recordIdAttribute != null) {

	    	// UM_Invoice_Amount_Net_Currency__c - static invoice amount
	    	// UM_Invoice_Amount_Gross_Currency__c - outstanding balance
	    	List<UM_InvoiceHeader__c> invoices = [SELECT id, UM_Invoice_Date__c, UM_Invoice_Amount_Net_Currency__c, UM_Invoice_Amount_Gross_Currency__c, UM_InvoiceNumber__c, UM_Backout_Status__c
	    												FROM UM_InvoiceHeader__c 
	    													WHERE UM_Billing_Location__c=:recordIdAttribute 	    													ORDER BY UM_Invoice_Date__c DESC];

	    	if(invoices.size() > 0) {

	    		invoicesToFilter = new List<String>();
		    	for(UM_InvoiceHeader__c tmpInvoice : invoices) {

		    		if(tmpInvoice.UM_Backout_Status__c != '1002') {

			    		invoiceHeaders.add( tmpInvoice.Id );

			    		Payment newInvoice = new Payment(
			    				tmpInvoice.Id, 
			    				String.valueOf( tmpInvoice.UM_Invoice_Date__c ),
			    				tmpInvoice.UM_Invoice_Date__c,
			    				'Invoice ' + tmpInvoice.UM_InvoiceNumber__c);

			    		newInvoice.invoiceNumber = tmpInvoice.UM_InvoiceNumber__c;
                        newInvoice.debit = tmpInvoice.UM_Invoice_Amount_Net_Currency__c;
                       // newInvoice.debit = tmpInvoice.UM_Invoice_Amount_Gross_Currency__c;
                        newInvoice.paymentType = 'invoice';                                     
                        //added below for BHP-78
                        newInvoice.receivedFromBilling = true;
                        newInvoice.affectsBalance = true;
                        //changes for BHP-78 ends
                        paymentsList.add( newInvoice );
                    } else {
                        
                        // need to be processed correctly
                        invoicesToFilter.add( tmpInvoice.UM_InvoiceNumber__c );
                    }
                    
                }
            }
        }
    }

    private void getPayments() {
        
        if(recordIdAttribute != null) {
            
            // CREDIT UM_Transaction_Amount__c
            List<UM_PaymentInformation__c> payments = [SELECT id, UM_Transaction_Date_Converted__c, UM_Transaction_Date__c, UM_Transaction_Amount__c, UM_Transaction_Amount_Currency__c, 
                                                       UM_Transaction_ID__c, UM_Transaction_Status_Translation__c, UM_Overpayments__c, UM_Transaction_Status__c
                                                       FROM UM_PaymentInformation__c 
                                                       WHERE UM_Billing_Location__c=:recordIdAttribute 
                                                       ORDER BY UM_Transaction_Date_Converted__c DESC];
            
            if(payments.size() > 0) {
                
                for(UM_PaymentInformation__c tmpPayment : payments) {
                    
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
                    // INC INC000001662715 fix (+vevalue should be shown in debit and -ve on credit inspite of transaction status)
                    // payment reversal are on debit side - quick fix 
                    //          if(tmpPayment.UM_Transaction_Status__c == '5') { 
                    if(tmpPayment.UM_Transaction_Amount_Currency__c >= 0) {    
                        newPayment.debit = tmpPayment.UM_Transaction_Amount_Currency__c;
                    } else {
                        newPayment.credit = tmpPayment.UM_Transaction_Amount_Currency__c;
                    }
                    newPayment.overpayment = tmpPayment.UM_Overpayments__c;
                    
                    newPayment.paymentStatus = tmpPayment.UM_Transaction_Status_Translation__c;
                    newPayment.paymentType = 'payment';
                    newPayment.paymentNumStatus = Integer.valueOf( tmpPayment.UM_Transaction_Status__c );
                    
                    //added below for BHP-78
                    newPayment.receivedFromBilling = true;
                    if(newPayment.paymentStatus== 'Deleted' || newPayment.paymentStatus == 'Posted' || newPayment.paymentStatus == 'Payment Reversal' || newPayment.paymentStatus == 'Disconnected Account Record' )
                        newPayment.affectsBalance = true;
                    //changes for BHP-78 ends
                    paymentsList.add( newPayment );
                }
            }
        }
    }


    global class Payment implements Comparable {

    	public Id paymentId {get;set;}
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
        //added below properties for BHP-78
        public Boolean receivedFromBilling{get;set;}
        public Boolean affectsBalance{get;set;}
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