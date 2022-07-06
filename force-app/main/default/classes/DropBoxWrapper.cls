public with sharing class DropBoxWrapper {

    @AuraEnabled public String cursor;
    @AuraEnabled public Boolean has_more;
    @AuraEnabled public list<entries> entries;
    @AuraEnabled public String link;
    
    public class entries{
        @AuraEnabled public String tag; 
        @AuraEnabled public String id;
        @AuraEnabled public String path_lower;
        @AuraEnabled public String name;
        @AuraEnabled public String path_display;
        @AuraEnabled public Boolean isFolder;
        
    }

    public class tokens{
        @AuraEnabled public String access_token;
        @AuraEnabled public String refresh_token;
        @AuraEnabled public Integer expires_in;
    }
}