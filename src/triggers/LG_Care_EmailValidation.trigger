trigger LG_Care_EmailValidation on EmailMessage (before insert) {
    
    /********* added ***********/
    List<permissionsetassignment> psAssign = new List<permissionsetassignment>();
    ID userID= UserInfo.getUserId();
    String usr_email = UserInfo.getUserEmail();
    
    if(UserInfo.getName() != 'System'){
        psAssign=[select permissionset.id from permissionsetassignment where assigneeid=:userID and PermissionSet.Label='UM Care Agent']; 
    }
    /*****************************/
    for(EmailMessage eMsg : Trigger.new) {
        
        String eTxtBody=eMsg.TextBody;
        String eHtBody=eMsg.HtmlBody;
        String threadId;
        
        System.debug('------------ '+UserInfo.getName());
        /*** Commented the below line of code to avoid SOQL error And added the same outside for loop| Amit**********/
        /*if(UserInfo.getName() != 'System'){
        User current_user=[SELECT id,Email,Profile.Name FROM User WHERE Id= :UserInfo.getUserId() LIMIT 1] ;
        List<permissionsetassignment> psAssign=[select permissionset.id from permissionsetassignment where assigneeid=: current_user.id and PermissionSet.Label='UM Care Agent'];
        */
        if(psAssign.size()>0)
        {
            system.debug(eMsg);
            //String usr_email=Current_user.Email;
                        
            if(usr_email==eMsg.FromAddress)
            {
                eMsg.addError(Label.B2B_Care_Email_Validation_for_FromAddress);
            }
            if(!(eTxtBody=='' || eTxtBody==null))
            {
                if(eTxtBody.Endswith('ref'))
                {
                    threadId='ref:'+eTxtBody.substringafter('ref:');
                    
                }
                if(eTxtBody.Equals(threadId))
                {
                    eMsg.addError(Label.B2B_Care_Email_Validation_for_Body);
                    
                }
                
            }
            
            
            else if(!(eHtBody=='' || eHtBody==null || eHtBody.stripHtmlTags().length()==2))
            {
                String Str3=eHtBody.stripHtmlTags();
                if(Str3.Endswith('ref'))
                {
                    threadId='ref:'+Str3.substringafter('ref:');
                    
                    if(Str3.Equals(threadId))
                    {
                        eMsg.addError(Label.B2B_Care_Email_Validation_for_Body);
                        
                    }
                }
                
            }
            
            else
            {
                eMsg.addError(Label.B2B_Care_Email_Validation_for_Body);
                
            }
        }
        //}
    }
    
}