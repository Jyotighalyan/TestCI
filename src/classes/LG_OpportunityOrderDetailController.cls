public class LG_OpportunityOrderDetailController {
    
    public class NumberPortingInformation {
        
        public final List<LG_PortingNumber__c> fixedLineNumbersSmall { get; private set; }
        
        public final List<LG_PortingNumber__c> fixedLineNumbersSOHO { get; private set; }
        
        public final List<LG_PortingNumber__c> mobileNumbers { get; private set; }
        
        public NumberPortingInformation() {
            fixedLineNumbersSmall = new List<LG_PortingNumber__c>();
            fixedLineNumbersSOHO = new List<LG_PortingNumber__c>();
            mobileNumbers = new List<LG_PortingNumber__c>();
        }
        
        public NumberPortingInformation(List<LG_PortingNumber__c> fixedLineNumbersSmall,
                                        List<LG_PortingNumber__c> fixedLineNumbersSOHO,
                                        List<LG_PortingNumber__c> mobileNumbers) {
            this.fixedLineNumbersSmall = fixedLineNumbersSmall;
            this.fixedLineNumbersSOHO = fixedLineNumbersSOHO;
            this.mobileNumbers = mobileNumbers;
        }
        
        public Integer getTotalCount() {
            return (fixedLineNumbersSmall.size() + fixedLineNumbersSOHO.size() + mobileNumbers.size());
        }
        
    }
    
    public Opportunity relatedTo { get; set; }
        
    public LG_OpportunityOrderDetailController() {
        // Do nothing...
    }
    
    public List<LG_ProductDetail__c> getProductDetails() {
        if (relatedTo == null) {
            return null;
        }

        
        return [select p.Id, p.LG_Name__c, p.LG_Product__c, p.LG_Value__c
                from LG_ProductDetail__c p
                where (p.LG_Type__c = 'Order Detail') and (LG_Opportunity__c = :relatedTo.Id)
                order by p.LG_Sequence__c asc];
                
    }
    
    public NumberPortingInformation getNumberPortingInformation() {
        if (relatedTo == null) {
            return new NumberPortingInformation();
        }
        List<LG_PortingNumber__c> fixedLineNumbersSmall = new List<LG_PortingNumber__c>();
        List<LG_PortingNumber__c> fixedLineNumbersSOHO = new List<LG_PortingNumber__c>();
        List<LG_PortingNumber__c> mobileNumbers = new List<LG_PortingNumber__c>();
        List<LG_PortingNumber__c> numberPortings = [SELECT p.Id, p.LG_Type__c, p.LG_SIMcardnumber__c,
                                                    p.LG_PortingDate__c, p.LG_PrimaryNumber__c, p.LG_Operator__c,
                                                    p.LG_PhoneNumber__c, p.LG_FirstPhoneNumber__c, p.LG_LastPhoneNumber__c,
                                                    p.LG_CustomerName__c, p.LG_InDirectory__c
                                                    FROM LG_PortingNumber__c p where p.LG_Opportunity__c = :relatedTo.Id
                                                    order by p.LG_LastPhoneNumber__c];
        for (LG_PortingNumber__c porting : numberPortings) {
            
            if (porting.LG_Type__c == 'SB Telephony') {
                fixedLineNumbersSmall.add(porting);
            } else if (porting.LG_Type__c == 'SOHO Telephony') {
                fixedLineNumbersSOHO.add(porting);
            } else if (porting.LG_Type__c == 'Mobile Telephony') {
                mobileNumbers.add(porting);
            }
            
        }
        return new NumberPortingInformation(fixedLineNumbersSmall, fixedLineNumbersSOHO, mobileNumbers);
    }
    
    public String getMainProducts() {
        List<OpportunityLineItem> products = [select p.PricebookEntry.Name from OpportunityLineItem p where p.OpportunityId = :relatedTo.Id and p.LG_MainOLI__c = true];
        List<String> productNames = new List<String>();
        for (OpportunityLineItem product : products) {
            productNames.add(product.PricebookEntry.Name);
        }
        return String.join(productNames, ', ');
    }
    
}