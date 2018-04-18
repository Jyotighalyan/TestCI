public class PartnerKnowledgePublish {


    public List<FormsTemp__kav> getForms(){
        return [SELECT title,urlname,Attachment__Name__s ,name__c, summary, PublishStatus FROM FormsTemp__kav where PublishStatus = 'Online' and Language ='en_US']; 
    }
  

    public List<Offer__kav> getOffer(){
        return [SELECT title,urlname,Attachment__Name__s ,name__c, summary, PublishStatus FROM Offer__kav where PublishStatus = 'Online' and Language ='en_US']; 
    }
    
    public List<Newsletter__kav> getNewsletter(){
        return [SELECT title,urlname,Attachment__Name__s ,name__c, summary, PublishStatus FROM Newsletter__kav where PublishStatus = 'Online' and Language ='en_US']; 
    }
    /*
    public List<Formulation__kav> getFormulation(){
        return [SELECT title,urlname,Attachment__Name__s ,name__c, summary, PublishStatus FROM Formulation__kav where PublishStatus = 'Online' and Language ='en_US']; 
    }*/
}