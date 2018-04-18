public with sharing class LG_EventSF1Controller{

  List<Event> filteredEvents;
  public List<String> ViewList = new List<String>{'All Events', 'Today\'s Events', 'Next 7 Days', 'Next 30 Days', 'Past Events'};
  public List<List<EventWrapper>> allWLists = new List<List<EventWrapper>>();
  public List<EventWrapper> filteredWEvents;
    
  public LG_EventSF1Controller(ApexPages.StandardController controller) {
        selectedVal = ViewList[1];
        List<Event> events = [SELECT Id, Subject, EndDateTime, StartDateTime, Location, What.Name, WhatId, Who.Name, WhoId FROM Event Order By StartDateTime];
        List<EventWrapper> wrapped = new List<EventWrapper>();       
        for(Event e : events){
            wrapped.add(new EventWrapper(e));
        }
        allWLists.add(wrapped);
        addTodayEvents(events);
        addPlus7days(events);
        addPlus30days(events);
        addPastEvents(events);
    }    
  
   public List<EventWrapper> getFilteredWEvents(){
      if(selectedVal == ViewList[0]){
          filteredWEvents = allWLists[0];
      }
      if(selectedVal == ViewList[1]){
          filteredWEvents = allWLists[1];         
      }
      if(selectedVal == ViewList[2]){
          filteredWEvents = allWLists[2];
      }
      if(selectedVal == ViewList[3]){
          filteredWEvents = allWLists[3];
      }
      if(selectedVal == ViewList[4]){
          filteredWEvents = allWLists[4];
      }      
      return filteredWEvents;
  }
  public String selectedVal{get;set;}
 
  
  public List<SelectOption> getMenuOptions(){
        List<SelectOption> optns = new List<Selectoption>();
        for(String option : ViewList){
            optns.add(new selectOption(option,option));
        }      
        return optns;
  }
  
  public PageReference go(){
      return null;
  }

  
  public void addTodayEvents(List<Event> events){
      List<EventWrapper> ew = new List<EventWrapper>();
      for(Event e : events){
          if(checkTodayEvents(e.StartDateTime, e.EndDateTime)){
              ew.add(new EventWrapper(e));
          }
      }
      allWLists.add(ew);
  }
  
  private boolean checkTodayEvents(DateTime startDT, DateTime endDT){
      if(startDT == null || endDT == null){
          return false;
      }
      Integer S = startDT.dayOfYear();
      Integer N = S + startDT.date().daysBetween(Date.today());
      Integer E = S + startDT.date().daysBetween(endDT.date());      
      return S <= N && N <= E;  
  }
  
  public void addPlus7days(List<Event> events){
      List<EventWrapper> ew = new List<EventWrapper>();
      for(Event e : events){
          if(checkPlus7days(e.StartDateTime, e.EndDateTime)){
              ew.add(new EventWrapper(e));
          }
      }
      allWLists.add(ew);
  }
  
  private boolean checkPlus7days(DateTime startDT, DateTime endDT){
      if(startDT == null || endDT == null){
          return false;
      }
      Integer S = startDT.dayOfYear();
      Integer N = S + startDT.date().daysBetween(Date.today());
      Integer E = S + startDT.date().daysBetween(endDT.date());        
      return S <= N+7 && N <= E;  
  }
  
  public void addPlus30days(List<Event> events){
      List<EventWrapper> ew = new List<EventWrapper>();
      for(Event e : events){
          if(checkPlus30days(e.StartDateTime, e.EndDateTime)){
              ew.add(new EventWrapper(e));
          }
      }
      allWLists.add(ew);
  }
  
    private boolean checkPlus30days(DateTime startDT, DateTime endDT){
      if(startDT == null || endDT == null){
          return false;
      }
      Integer S = startDT.dayOfYear();
      Integer N = S + startDT.date().daysBetween(Date.today());
      Integer E = S + startDT.date().daysBetween(endDT.date());        
      return S <= N+30 && N <= E;  
  }
  
  public void addPastEvents(List<Event> events){
      List<EventWrapper> ew = new List<EventWrapper>();
      for(Event e : events){
          if(isPastEvent(e.EndDateTime)){
              ew.add(new EventWrapper(e));
          }
      }
      allWLists.add(ew);
  }
  
  private boolean isPastEvent(DateTime endDT){
      if(endDT == null){
          return false;
      }
      Integer A = Date.today().daysBetween(endDT.date());
      return A < 0 && A > - 7;
  }
  
  public class EventWrapper{
      public Event record {get;set;}
      public String startTime {get;set;}
      public String endTime {get;set;}
  
      public EventWrapper(Event e){
          record = e;
          startTime = getHourMinutes(e.StartDateTime);
          endTime = getHourMinutes(e.EndDateTime);
      }
  
      private String getHourMinutes(DateTime dt){
          String hm = '';
          if(dt==null){
              return '00:00';
          }
          hm += '' + dt.hour() + ':';
          Integer m = dt.minute();
          if(m < 10){
              hm += '0';
          }
          hm += m;
          return hm;
      }
  }    
}