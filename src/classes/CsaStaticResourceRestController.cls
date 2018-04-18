/**
 * Apex class used for retrieval of StaticResources.
 * Some Salesforce profiles do not have the option to enable access to StaticResource sobjects.
 * For those profiles this Rest api is used.
 */
@RestResource(urlMapping='/CsaRest/StaticResource')
global without sharing class CsaStaticResourceRestController {

    public static StaticResourceQuery q = new StaticResourceQuery();
  
  global class StaticResourceWrapper {
      public Id Id;
      public String Name;
      public String ContentType;
      public DateTime LastModifiedDate;
      public String Data;
  }

    /**
     * Returns an array of StaticResourceWrapper records.
     * Takes id, name and query from the request parameters.
     * If any of those parameters exist a list will be returned 
     * matching the filter defined by that parameter.
     * 
     * @returns List<StaticResourceWrapper> a list of StaticResourceWrapper records containing StaticResource data.
     */
  @HttpGet
  global static List<StaticResourceWrapper> getStaticResources() {
    RestRequest req = RestContext.request;
    String id = req.params.get('id');
    String name = req.params.get('name');
    String query = req.params.get('query');

    List<StaticResource> resourceList = new List<StaticResource>();
    List<StaticResourceWrapper> wrapperList = new List<StaticResourceWrapper>();

    if(query != null) {
      resourceList = q.queryDatabase(query);
    }
    if(id != null) {
      resourceList = q.getStaticResourceById(id);
    }
    if(name != null) {
      resourceList = q.getStaticResourceByName(name);
    }

      for(StaticResource res : resourceList) {
        StaticResourceWrapper wrap = new StaticResourceWrapper();
        try { wrap.Id = res.Id; } catch(Exception e){}
        try { wrap.Name = res.Name; } catch(Exception e){}
        try { wrap.ContentType = res.ContentType; } catch(Exception e){}
        try { wrap.LastModifiedDate = res.LastModifiedDate; } catch(Exception e){}
        try { wrap.Data = (res.Body).toString(); } catch(Exception e){}
  
        wrapperList.add(wrap);
      }

      return wrapperList;
  }

    /**
     * Wrapper class for database methods.
     * Separated to simplify unit testing, since Salesforce does not permit insert of
     * StaticResources records.  
     */
    public virtual class StaticResourceQuery {
        public virtual List<StaticResource> queryDatabase(String query) {
            return Database.query(EncodingUtil.urlDecode(query, 'UTF-8'));
        }
        
        public virtual List<StaticResource> getStaticResourceById(String id) {
          return [SELECT Id, Name, Body, ContentType, LastModifiedDate FROM StaticResource where Id = :id];
      }
      
      public virtual List<StaticResource> getStaticResourceByName(String name) {
          return [SELECT Id, Name, Body, ContentType, LastModifiedDate FROM StaticResource where name = :name];    
      }    
    }
  
}