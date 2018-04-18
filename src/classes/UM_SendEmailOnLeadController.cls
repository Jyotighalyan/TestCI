public with sharing class UM_SendEmailOnLeadController {
    
    public UM_SendEmailOnLeadController(ApexPages.StandardController stdController)
        {
        
        }
    
    public PageReference sendEmail(){
    	set<UM_ProductInterest__c> set_Coax=new set<UM_ProductInterest__c>();
    	set<UM_ProductInterest__c> set_Fiber=new set<UM_ProductInterest__c>();
    	string leadId=ApexPages.currentPage().getParameters().get('id');
    	list<UM_ProductInterest__c> lstPI=new list<UM_ProductInterest__c>();
    	Lead objLead;
    	
    	if(leadId!=null){
    		lstPI=[select id,Name, UM_Product__c,UM_ContractTerm__c,UM_Forecast__c,UM_Quantity__c,UM_Capex__c,UM_Opex__c,UM_MRR__c,UM_OTC__c from UM_ProductInterest__c where UM_Lead__c=: leadId];
    		objLead=[select id,ownerId,owner.name, name,company ,MobilePhone,LG_VisitAddress__c,Phone,UM_VisitGeolocation__c,UM_VisitGeolocation__latitude__s,UM_VisitGeolocation__longitude__s,Email,Description, street,city,postalcode from lead where Id =:leadId];
    	}
    	
    	if(!lstPI.isEmpty()){
    		for(UM_ProductInterest__c prodInterest:lstPI){
    			if(string.valueOf(prodInterest).contains('Internet')){
    				set_Coax.add(prodInterest);
    			}
    			if(string.valueOf(prodInterest).contains('Fiber')){
    				set_Fiber.add(prodInterest);
    			}
    		}
    	}
    	
		    if(!set_Coax.isEmpty()){
				list<Attachment> lstAttachments=[select Id,parentId,Name,contentType,ownerId,body from attachment where parentId IN:set_Coax];
						    	
    			String htmlBody = 'Dear team, <br/><br/>';
    			htmlBody += 'Please perform the investment cost calculation on this opportunity. These are the products requested: <br/><br/>';
    			
    			htmlBody =htmlBody+ '<table border="1" style="border-collapse: collapse"><caption>Product Interest(s)</caption><tr><td>Product</td><td>Contract Term</td><td>Quantity </td><td>Capex</td><td>Opex</td><td>MRR</td><td>OTC</td></tr>';
		    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		    	
		    	mail.setToAddresses(new String[] {LG_EnvironmentVariables__c.getOrgDefaults().UM_ProductInterestCOAXEmail__c});//b2b-neuanschluss@unitymedia.de
		    	for(UM_ProductInterest__c PI:set_Coax){
		    		if(PI.UM_ContractTerm__c==null)
		    			PI.UM_ContractTerm__c=0;
		    		if(PI.UM_Quantity__c==null)
		    			PI.UM_Quantity__c=0;
		    		if(PI.UM_Capex__c==null)
		    			PI.UM_Capex__c=0;
					if(PI.UM_Opex__c==null)
						PI.UM_Opex__c=0;
					if(PI.UM_MRR__c==null)
						PI.UM_MRR__c=0;
					if(PI.UM_Otc__c==null)
						PI.UM_Otc__c=0;
								    					
					htmlBody += '<tr><td>' + PI.UM_Product__c + '</td><td>' + PI.UM_ContractTerm__c +'</td><td>'+PI.UM_Quantity__c+'</td><td>'+PI.UM_Capex__c+'</td><td>'+PI.UM_Opex__c+'</td><td>'+PI.UM_MRR__c+'</td><td>'+PI.UM_OTC__c+ '</td></tr>';		
		    	}
		    	htmlBody += '</table><br/>';
		    	
		    	if(objLead.company==null)
		    		objLead.company='';
		    	if(objLead.mobilephone==null)
		    		objLead.mobilephone='';
				if(objLead.phone==null)
					objLead.phone='';
				if(objLead.UM_VisitGeolocation__latitude__s==null || objLead.UM_VisitGeolocation__longitude__s==null)
				{
					objLead.UM_VisitGeolocation__latitude__s=0;
					objLead.UM_VisitGeolocation__longitude__s=0;
				}
				if(objLead.email==null)
					objLead.email='';
				if(objLead.description==null)
					objLead.description='';																			    			
		    	htmlBody += 'Below you can find additional details for the customer and any attachments will provide necessary input: <br/><br/>';
		    	htmlBody +='<table border="0" style="border-collapse: collapse">';
		    	htmlBody += '<tr><td>'+objLead.company+'</td><td>'+objLead.mobilephone+'</td></tr>';
		    	htmlBody += '<tr><td>'+objLead.Name+'</td><td>'+objLead.LG_VisitAddress__c+'</td></tr>';
		    	htmlBody += '<tr><td>'+objLead.phone+'</td><td>'+objLead.UM_VisitGeolocation__latitude__s+', '+objLead.UM_VisitGeolocation__longitude__s+'</td></tr>';
		    	htmlBody += '<tr><td>'+objLead.email+'</td><td>'+objLead.description+'</td></tr>';
		    	htmlBody += '</table><br/><br/>';
		    	
		    	htmlBody += 'Regards, <br/>'+objLead.owner.name;
		    	mail.setHtmlBody(htmlBody);
              	mail.setSubject('Investment cost calculation request');
              	if(!lstAttachments.isEmpty()){
              		
              		list<Messaging.EmailFileAttachment> lstEfa = new list<Messaging.EmailFileAttachment>();
              		for(Attachment a: lstAttachments){
              			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
              			efa = new Messaging.EmailFileAttachment();
              			efa.setFileName(a.Name);
				    	efa.setBody(a.body);
				    	efa.setContentType(efa.contentType);
				    	lstEfa.add(efa);
              		}
				     mail.setFileAttachments(lstEfa);
              	}
	            Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		    	
		    }
		    if(!set_Fiber.isEmpty()){
				list<Attachment> lstAttachments=[select Id,parentId,Name,contentType,ownerId,body from attachment where parentId IN:set_Coax];
						    	
    			String htmlBody = 'Dear team, <br/><br/>';
    			htmlBody += 'Please perform the investment cost calculation on this opportunity. These are the products requested: <br/><br/>';
    			
    			htmlBody =htmlBody+ '<table border="1" style="border-collapse: collapse"><caption>Product Interest(s)</caption><tr><td>Product</td><td>Contract Term</td><td>Quantity </td><td>Capex</td><td>Opex</td><td>MRR</td><td>OTC</td></tr>';
		    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		    	
		    	mail.setToAddresses(new String[] {LG_EnvironmentVariables__c.getOrgDefaults().UM_ProductInterestFiberEmail__c});//b2b-neuanschluss@unitymedia.de
		    	for(UM_ProductInterest__c Fb:set_Fiber){
		    		if(Fb.UM_ContractTerm__c==null)
		    			Fb.UM_ContractTerm__c=0;
		    		if(Fb.UM_Quantity__c==null)
		    			Fb.UM_Quantity__c=0;
		    		if(Fb.UM_Capex__c==null)
		    			Fb.UM_Capex__c=0;
					if(Fb.UM_Opex__c==null)
						Fb.UM_Opex__c=0;
					if(Fb.UM_MRR__c==null)
						Fb.UM_MRR__c=0;
					if(Fb.UM_Otc__c==null)
						Fb.UM_Otc__c=0;
								    					
					htmlBody += '<tr><td>' + Fb.UM_Product__c + '</td><td>' + Fb.UM_ContractTerm__c +'</td><td>'+Fb.UM_Quantity__c+'</td><td>'+Fb.UM_Capex__c+'</td><td>'+Fb.UM_Opex__c+'</td><td>'+Fb.UM_MRR__c+'</td><td>'+Fb.UM_OTC__c+ '</td></tr>';		
		    	}
		    	htmlBody += '</table><br/>';
		    	
		    	if(objLead.company==null)
		    		objLead.company='';
		    	if(objLead.mobilephone==null)
		    		objLead.mobilephone='';
				if(objLead.phone==null)
					objLead.phone='';
				if(objLead.UM_VisitGeolocation__latitude__s==null || objLead.UM_VisitGeolocation__longitude__s==null)
				{
					objLead.UM_VisitGeolocation__latitude__s=0;
					objLead.UM_VisitGeolocation__longitude__s=0;
				}
				if(objLead.email==null)
					objLead.email='';
				if(objLead.description==null)
					objLead.description='';																			    			
		    	htmlBody += 'Below you can find additional details for the customer and any attachments will provide necessary input: <br/><br/>';
		    	htmlBody +='<table border="0" style="border-collapse: collapse">';
		    	htmlBody += '<tr><td>'+objLead.company+'</td><td>'+objLead.mobilephone+'</td></tr>';
		    	htmlBody += '<tr><td>'+objLead.Name+'</td><td>'+objLead.LG_VisitAddress__c+'</td></tr>';
		    	htmlBody += '<tr><td>'+objLead.phone+'</td><td>'+objLead.UM_VisitGeolocation__latitude__s+', '+objLead.UM_VisitGeolocation__longitude__s+'</td></tr>';
		    	htmlBody += '<tr><td>'+objLead.email+'</td><td>'+objLead.description+'</td></tr>';
		    	htmlBody += '</table><br/><br/>';
		    	
		    	htmlBody += 'Regards, <br/>'+objLead.owner.name;
		    	mail.setHtmlBody(htmlBody);
              	mail.setSubject('Investment cost calculation request');
              	if(!lstAttachments.isEmpty()){
              		
              		list<Messaging.EmailFileAttachment> lstEfa = new list<Messaging.EmailFileAttachment>();
              		for(Attachment a: lstAttachments){
              			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
              			efa = new Messaging.EmailFileAttachment();
              			efa.setFileName(a.Name);
				    	efa.setBody(a.body);
				    	efa.setContentType(efa.contentType);
				    	lstEfa.add(efa);
              		}
				     mail.setFileAttachments(lstEfa);
              	}
	            Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		    	    	
		    }
    	 	
    	PageReference pr=new PageReference('/'+objLead.Id);
    	return pr;
    }
    
}