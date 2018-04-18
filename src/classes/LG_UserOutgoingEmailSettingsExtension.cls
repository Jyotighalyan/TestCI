/*
This is a controller extension for standard User controller.
Its purpose is to edit the User's Outgoing Email Settings.
*/
public with sharing class LG_UserOutgoingEmailSettingsExtension {
    
    public User selectedUser { get; private set; }
    
    // Determines if editing mode is enabled.
    public Boolean editing { get; private set; }
    
    // Status message displayed on Visualforce page.
    public String infoMessage { get; private set; }

	// Determines if the currently logged in User can edit the selected User record.
    public Boolean canEditRecord {
        get {
            UserRecordAccess accessInformation = [select RecordId, HasReadAccess, HasTransferAccess, HasEditAccess, MaxAccessLevel from UserRecordAccess
                                                  where UserId = :UserInfo.getUserId() and RecordId = :selectedUser.Id];
            return accessInformation.HasEditAccess;
        }
    }

    public LG_UserOutgoingEmailSettingsExtension(ApexPages.StandardController controller) {
		ID selectedUserId = ((User) controller.getRecord()).Id;
        selectedUser = [select u.SenderName, u.SenderEmail from User u where u.Id = :selectedUserId];
        editing = false;
    }
    
    // Enable editing mode if it's premitted for the logged in User to edit the selected User record.
    public System.PageReference startEditing() {
        editing = (canEditRecord ? true : false);
        infoMessage = null;
        return null;
    }
    
    // Confirm and save changes if it's premitted for the logged in User to edit the selected User record.
    // Otherwise a redirect takes place.
    public System.PageReference confirm() {
        if (canEditRecord) {
            Database.update(selectedUser);
            editing = false;
            infoMessage = Label.LG_OutgoingEmailSettingsConfirmationNeeded;
            return null;
        } else {
            cancelEditing();
            return (new ApexPages.StandardController(selectedUser)).cancel();
        }
    }
    
    // Disable editing mode and refresh User information.
    public System.PageReference cancelEditing() {
        selectedUser = [select u.SenderName, u.SenderEmail from User u where u.Id = :selectedUser.Id];
        editing = false;
        infoMessage = null;
        return null;
    }

}