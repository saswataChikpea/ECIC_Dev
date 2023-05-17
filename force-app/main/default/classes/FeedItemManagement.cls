public with sharing class FeedItemManagement {
    @AuraEnabled
    public static List<AccountFeed> getFeedItems(Id accid){
        try{ 
            //List<FeedItem> feedItemList = FeedItemQueryUtils.feedItemQuery(accid);
            List<AccountFeed> feedItemList = [select Id,Body,Title,ParentId,(Select CommentBody from FeedComments) from AccountFeed where ParentId=:accid ORDER BY CreatedDate DESC ];
            return feedItemList;
        } catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Id createFeed(Id accid){
        try {
            FeedItem feed = new FeedItem();
            feed.Body = 'Test FeedItem2nd';
            feed.ParentId = accid;
            feed.Visibility = 'AllUsers';            
            insert feed;
            return feed.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Id createFeedComment(){
        try {
            FeedComment feed = new FeedComment();
            feed.CommentBody = 'New comment from community';
            feed.FeedItemId = '0D55600000MXp5xCAD';
            // feed.Visibility = 'AllUsers';            
            insert feed;
            return feed.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<FeedComment> getComments(){
        try {
            System.debug('getComments');
            List<FeedComment> feedcomments = [select Id,CommentBody,CommentType,ParentId,ThreadParentId from FeedComment where FeedItemId=:'0D55600000MXp5xCAD'];
            return feedcomments;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}