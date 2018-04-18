/**
  * Class that is used to handle data coming from Documentum
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
public with sharing class UM_DocumentumController {
     private String response = '';
     private String url='';
     private Boolean isError=false;
     private String message='';
    public UM_DocumentumController() {
            
    }

	//Get list of documents in wrapper format
	public List<Document> documentList(String url){
		List<Document> documents = new List<Document>();
		
		//Get info from Documentum
		HTTPResponse res = UM_DocumentumResponse.getData(url);
		//Get the response in DOM model
		Dom.Document xmlDoc = res.getBodyDocument();
		//Retrieve the root element for this document.
		Dom.XMLNode xmlDocuments = xmlDoc.getRootElement();
		//Cycle through the documents
		for(Dom.XMLNode xmlDocument : xmlDocuments.getChildren()) {
			//Create document wrapper
			Document document = new Document();
			//Add document attributes to wrapper
			document.documentId = xmlDocument.getAttributeValue('id', null);
			document.documentType = xmlDocument.getAttributeValue('content_type', null);
			//Cycle through invoices, though only one will exist
			for(Dom.XMLNode xmlInvoice : xmlDocument.getChildren()) {
				//Cycle through nodes
				for(Dom.XMLNode xmlNode : xmlInvoice.getChildren()){
					//Add relevant nodes to the wrapper
					if(xmlNode.getName() == 'number'){
						document.documentNumber = xmlNode.getText();
					} else if(xmlNode.getName() == 'date'){
						document.documentDate = xmlNode.getText();
					} else if(xmlNode.getName() == 'total'){
						document.documentTotal = xmlNode.getText();
					}
				}
			}
			documents.add(document);
		}
		return documents;
	}

    public void fetchInvoivesPDF(){
        try
        {
            Boolean isCDR = false;
            //String invoiceNumber;
            HTTPResponse res = new HTTPResponse();
            if(ApexPages.currentPage().getParameters().containsKey('itemised_bill')) 
            {
               res = UM_DocumentumResponse.getData('invoice/' + ApexPages.currentPage().getParameters().get('invoiceno')+'?itemised_bill='+ApexPages.currentPage().getParameters().get('itemised_bill')); 
               if(ApexPages.currentPage().getParameters().get('itemised_bill')=='1') 
                   isCDR= true;
            }
            else
            {
                res = UM_DocumentumResponse.getData('invoice/' + ApexPages.currentPage().getParameters().get('invoiceno'));
                //invoiceNumber= ApexPages.currentPage().getParameters().get('invoiceno');
            }
            System.debug('res:'+res.getBody());
            System.debug('resStatus:'+res.getStatusCode());
            /**added error handling for SFOM-2116 on 2/11/2017**/
            if(res.getStatusCode()==401)
            {                  
                isError= true;
                if(isCDR)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.UM_INVOICE_CDR_UNAUTHORIZED_ERROR_MSG));
                else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.UM_INVOICE_UNAUTHORIZED_ERROR_MSG));
            }
            else if(res.getStatusCode()==404)
            {                  
                               
                isError= true;
                if(isCDR)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.UM_INVOICE_CDR_NOT_AVAILABLE_ERROR_MSG));
                else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.UM_INVOICE_NOT_AVAILABLE_ERROR_MSG));
            }
            else if(res.getStatusCode()==200)
            {
                isError= false;
                url=EncodingUtil.Base64Encode(res.getBodyAsBlob());
            }
            else
            {
                isError= true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.UM_UNKNOWN_ERROR));
            }
            /* Sfom-2116 ends */ 
        }
        catch(Exception e)
        {
            isError= true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.UM_UNKNOWN_ERROR));
            
        }  
    }
    public String getUrl()
        {return url;}
    public boolean getisError()
        {return isError;}
            
    // Wrapper class for documents retrieved from Documentum
    public class Document {
            
        public String documentId {get; set;}
        public String documentType {get; set;}
        public String documentNumber {get; set;}
        public String documentDate {get; set;}
        public String documentTotal {get; set;}
            
        public Document() {
            
        }   
    }
}