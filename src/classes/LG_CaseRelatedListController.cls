public class LG_CaseRelatedListController {
    public Id caseIdVal {get; set;}
    public cComments[] comments{
    get{
        List<cComments> comments = new List<cComments>();
        List<CaseComment> allCaseComments = new List<CaseComment>();
        allCaseComments = [Select LastModifiedDate, LastModifiedBy.Id, LastModifiedBy.Name, IsPublished, CreatedDate, CreatedBy.Id, CreatedBy.Name, CommentBody From CaseComment c where ParentId = :caseIdVal order by c.LastModifiedDate desc];
        for(CaseComment comment : allCaseComments)
        {
        cComments tempcComment = new cComments();
        tempcComment.cComment = comment;
        
        // Build String to display.
        tempcComment.commentText = '<b>Created By: <a href=\'/' + comment.CreatedBy.Id + '\'>' + comment.CreatedBy.Name + '</a> (' + comment.CreatedDate.format() + ') | ';
        tempcComment.commentText += 'Last Modified By: <a href=\'/' + comment.LastModifiedBy.Id + '\'>' + comment.LastModifiedBy.Name + '</a> (' + comment.LastModifiedDate.format() + ')</b><br>';
        tempcComment.commentText += comment.CommentBody;
        
        if(comment.IsPublished)
        tempcComment.PublicPrivateAction = 'Make Private';
        else
        tempcComment.PublicPrivateAction = 'Make Public';
        //Add to list
        comments.add(tempcComment);	
        }
        return comments;
    }
    
    set;
    }
    
    public PageReference NewComment()
    {
        PageReference pr = new PageReference('/00a/e?parent_id='+ caseIdVal + '&retURL=%2F' + caseIdVal);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference deleteComment()
    {
        Id commentId = ApexPages.currentPage().getParameters().get('CommentId_del');
        
        for(cComments Comment : comments)
        {
            if(Comment.cComment.Id == commentId)
            {	
                delete Comment.cComment;	
                break;
            }
    	}
    
        PageReference pg = new PageReference('/' + caseIdVal);
        pg.setRedirect(true);
        return pg;
    }	
    
    public PageReference makePublicPrivate()
    {
        Id commentId = ApexPages.currentPage().getParameters().get('CommentId_p');
        for(cComments Comment : comments)
        {
            if(Comment.cComment.Id == commentId)
            {	
                Comment.cComment.IsPublished = !Comment.cComment.IsPublished;
                if(Comment.cComment.IsPublished){
                    Comment.PublicPrivateAction = 'Make Private';
                }else{
                    Comment.PublicPrivateAction = 'Make Public';
                }
                
                update Comment.cComment;	
                break;
            }
        }
        PageReference pg = new PageReference('/' + caseIdVal);
        pg.setRedirect(true);
        return pg;
    }
    
    public caseHistories[] caseHistory{
        get{
            List<caseHistories> allCaseHistories = new List<caseHistories>();
            List<CaseHistory> allCaseHistory = new List<CaseHistory>();
            allCaseHistory = [SELECT Id, CreatedDate, CreatedById, Field, OldValue, NewValue FROM CaseHistory ch WHERE CaseId=:caseIdVal ORDER BY ch.CreatedDate DESC];
            for(CaseHistory history: allCaseHistory){
                String action = '';
                caseHistories tempHistory = new caseHistories();
                tempHistory.history = history;
                if(history.OldValue != null && history.NewValue != null){
                    action = 'Changed '+'<b>'+history.Field+'</b> from '+history.OldValue+' to <b>'+history.NewValue+'</b>.';
                }else if(history.OldValue!= null && history.NewValue == null){
                    action = 'Deleted '+history.OldValue+' in <b>'+history.Field+'</b>.';
                }else if(history.OldValue == null && history.NewValue != null){
                    action = 'Changed <b>'+history.Field+'</b> to '+history.NewValue;
                }else if(history.OldValue == null && history.NewValue == null){
                    System.debug('CreatedDate'+history.CreatedDate);
                    action = history.Field+'.';
                }
                tempHistory.action = action;
                allCaseHistories.add(tempHistory);
            }
            return allCaseHistories;
        }
    }
    
    
    //private String getLabel
    
    public class cComments {
		public CaseComment cComment {get; set;}
        public String commentText {get; set;}
        public String PublicPrivateAction {get; set;}
    }
    
    public class caseHistories {
        public CaseHistory history {get; set;}
        public String action {get; set;}
    }

}