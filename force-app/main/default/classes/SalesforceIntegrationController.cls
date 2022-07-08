/*
Created By      :   Mahendra Sharma
Description	 	:	Controller for Salesforce to Salesforce Integration Assignment
                    - Fetch Files related to current User's contact
                    - Upload File relating with contact
                    - Callout to upload file to Api Org
*/
public with sharing class SalesforceIntegrationController {
    
    // method to get files related to the login user's contact.
    @AuraEnabled
    public static List<FileData> getLocalData(){
        User usr = [Select Id, ContactId from User where id =:userInfo.getUserId()];
        String conId = usr.ContactId;
        if(conId != null){
            List<FileData> result = new List<FileData>();
            List<ContentDocumentLink> docLink = [Select ContentDocumentID from ContentDocumentLink where LinkedEntityId =:conId];
            Set<Id> fileId = new Set<Id> ();
            for(ContentDocumentLink cl : docLink){
                fileId.add(cl.ContentDocumentId);
            }
            List<ContentVersion> cvlist = [Select Id, FileType, Title from ContentVersion where ContentDocumentId in:fileId];
            for(ContentVersion cv : cvlist){
                result.add( new FileData(cv.Title, cv.FileType));
            }
            return result;
        }
        else{
            return null;
        }
    }

    // Method to upload files in community Org
    @AuraEnabled
    public static FileData localUpload(String base64, String filename) {
        User usr = [Select Id, ContactId from User where id =:userInfo.getUserId()];
        String conId = usr.ContactId;
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        insert cv;

        ContentVersion resultVersion =  [SELECT ContentDocumentId, FileType, Title FROM ContentVersion WHERE Id =: cv.Id];
        ContentDocumentLink docLink = new ContentDocumentLink();
        docLink.ContentDocumentId = resultVersion.ContentDocumentId;
        docLink.LinkedEntityId = conId;
        docLink.ShareType = 'V';
        if(Test.isRunningTest()) {
            docLink.LinkedEntityId = [select id from contact limit 1].id;
        }
        insert docLink;

        FileData result = new FileData(resultVersion.Title, resultVersion.FileType);
        return result;
   }
   
    //Method to upload file to api org on a perticular contact 
    @AuraEnabled
    public static String uploadDataOnApiOrg(String base64, String filename){
        String body = JSON.serialize(new Map<String, object>{
            'base64' => base64,
            'filename'=> filename,
            'conId' => '0035g00000bNKVAAA4' });

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:mnc32Api/services/apexrest/upload');
        req.setBody(body);
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        Http http = new Http();
        HTTPResponse resp = http.send(req);
        
        while(resp.getStatusCode() == 302) {
            req.setEndpoint(resp.getHeader('Location'));
            resp = new Http().send(req);
        }
        return resp.getBody();
    }

    //Wrapper class for file name and Type
    public class FileData {
        @AuraEnabled public String fileName;
        @AuraEnabled public String filetype;
        
        public FileData(String fileName, String filetype){
            this.fileName = fileName;
            this.filetype = fileType;
        }
    }
}