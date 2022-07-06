public with sharing class GoogleDriveIntegrationWrapper {
    //fetch data get request's response 
    public class GoogleDriveData{
        @AuraEnabled public String kind;
        @AuraEnabled public String nextPageToken;
        @AuraEnabled public Boolean incompleteSearch;
        @AuraEnabled public List<Files> files;
    }
    //wrapper to store responce recived from google drive ( stores file and folder basic details for API v3)
    //title added to get name of file from drive api v2
    public class Files {
        @AuraEnabled public String kind;
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String title;
        @AuraEnabled public String mimeType;

    }

    //wrapper to store response of tokens 
    public class GoogleAuth_response{
        @AuraEnabled public String access_token;
        @AuraEnabled public Integer expires_in;
        @AuraEnabled public String scope;
        @AuraEnabled public String token_type;
        @AuraEnabled public string refresh_token;
    }
}