/******** Email Handler class for handling reply to Email response received from customer****
 ***** Author: Neha Arora **********
*********SFOM - 122***********
*****************************************************************/
global class LG_AppointmentReminderEmailHandler implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
          system.debug('In Email Handler#');
          try
          {
              String emailBody = email.plaintextbody;
              system.debug('body#'+emailBody);
              if(emailBody.contains('Case#'))
              {
                  //parse the email body to get Case Number
                  Integer i = emailBody.lastindexOf('Case#');
                  system.debug('length#'+emailBody.length());
                  String tempText = emailBody.mid(i,15);
                  List<String> finalText = tempText.split(':');
                  system.debug('case number#'+finalText[1].trim());
                  String caseNumber = finalText[1].trim();
                  
                  Case cse = [SELECT LG_Solution__c,LG_Solution__r.ownerId FROM Case where casenumber = :caseNumber];
                  system.debug('solut id#'+cse.LG_Solution__c);
                  //attaching email to Solution object
                  if(cse.LG_Solution__c != null){
                      Id solId = cse.LG_Solution__c;
                      Attachment attachment = new Attachment();
                      attachment.Name = 'Email Reply received for Appointment reminder on Case#:'+caseNumber+'.doc';
                      attachment.Body = Blob.valueOf(emailBody);
                      attachment.ParentId = solId;
                      insert attachment;
                      //creating list of attachments for email to be sent to Order manager
                      List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                      Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                      efa.setFileName(attachment.Name);
                      efa.setBody(attachment.Body);
                      fileAttachments.add(efa);
                      
                      //send email to order manager
                      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                      mail.setTargetObjectId(cse.LG_Solution__r.ownerId);
                      mail.setSubject('Email Reply received for Appointment reminder on Case#:'+caseNumber);
                      mail.setHtmlBody('Hi, \n Please find attached, the reply to the appointment reminder from the customer');
                      mail.setFileAttachments(fileAttachments);
                      mail.saveAsActivity = false;
                      mailsToSend.add(mail);
                      
                  }
                  if(mailsToSend.size() > 0)
                  {
                        Messaging.sendEmail(mailsToSend);       
                  }
                  
              }
              else{
                  system.debug('in else');
                  //notify admin for incorrect email
              } 
          	  return result;
          }
          catch(Exception e)
          {
              system.debug('inside catch'+e);
          }
          return result;
      }
  }