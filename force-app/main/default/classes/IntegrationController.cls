public with sharing class IntegrationController {

    //method to check Access Token expired or not
    @AuraEnabled
    public static boolean isExpired(){
        Integration_Access__c user = [select Expire_In__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        return (user.Expire_In__c < System.now());
    }

    //get current user related access data if available return data else return null
    @AuraEnabled
    public static Integration_Access__c getUser(){
        List<Integration_Access__c> user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        if(user.size()==0){
            return null;
        }
        else{
            return user[0];
        }
    }
         
 
    //create and return url to get auth code 
    @AuraEnabled
    public Static String authstep1(){
       String clientUrl =   'https://accounts.google.com/o/oauth2/v2/auth' + '?scope=https://www.googleapis.com/auth/drive' +
                            '&access_type=offline' + '&include_granted_scopes=true' + '&response_type=code' + '&state=state_parameter_passthrough_value'+
                            '&redirect_uri=' + Auth_Data__mdt.getInstance('GoogleDrive').Redirect_Url__c +
                            '&client_id=' + Auth_Data__mdt.getInstance('GoogleDrive').AppKey__c;
                            System.debug('url ='+clientUrl);	

        Integration_Access__c user = new Integration_Access__c(name = userInfo.getUserId(), Record_Type__c = 'Google Drive');
        insert user;
        return clientUrl;
    }

    //method to get Tokens
    @AuraEnabled
    public Static void auth_Step_2(String code){  
         String authUrl = 'https://oauth2.googleapis.com/token';
         String params = '?code=' + code +
                         '&grant_type=authorization_code' + '&access_type=offline'+
                         '&client_id=' + Auth_Data__mdt.getInstance('GoogleDrive').AppKey__c +
                         '&client_secret=' + Auth_Data__mdt.getInstance('GoogleDrive').AppScret__c + 
                         '&redirect_uri=' + Auth_Data__mdt.getInstance('GoogleDrive').Redirect_Url__c;
        string endPoint = authUrl + params;
        GoogleDriveIntegrationWrapper.GoogleAuth_response tokens = GoogleDriveServiceClass.generateTkoens(endPoint);

        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        user.Access_Token__c = tokens.access_token;
        user.Refresh_token__c = tokens.refresh_token;
        Double exp = tokens.expires_in;
        user.Expire_In__c = System.now()+(exp/60/60/24);
        update user;
    }

    //regenerate access token when expired
    @AuraEnabled
    public Static void reGenerateTkoen(){
        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        String authUrl = 'https://oauth2.googleapis.com/token';
        String params = '?grant_type=refresh_token' + 
                        '&client_id=' + Auth_Data__mdt.getInstance('GoogleDrive').AppKey__c +
                        '&client_secret=' + Auth_Data__mdt.getInstance('GoogleDrive').AppScret__c + 
                        '&refresh_token=' + user.Refresh_token__c;
        String endPoint = authUrl + params;
        GoogleDriveIntegrationWrapper.GoogleAuth_response tokens = GoogleDriveServiceClass.generateTkoens(endPoint);
       
            user.Access_Token__c = tokens.access_token;
            Double exp = tokens.expires_in;
            user.Expire_In__c = System.now()+(exp/60/60/24);
            update user;
        
    }

    //fetch bdata from google drive 
    @AuraEnabled
    public static List<GoogleDriveIntegrationWrapper.Files> fetchData(string url){
   
        Integration_Access__c user = [Select Access_Token__c from Integration_Access__c WHERE Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        string accessToken = user.Access_Token__c;
        GoogleDriveIntegrationWrapper.GoogleDriveData folderData = GoogleDriveServiceClass.getFiles(url,accessToken);
        List<GoogleDriveIntegrationWrapper.Files> driveFiels = new  List<GoogleDriveIntegrationWrapper.Files>();
        for(GoogleDriveIntegrationWrapper.Files obj : folderData.files){
            driveFiels.add(obj);
        }
        return driveFiels;
    }
    
    //return download url
    @AuraEnabled
    public static String download(string fileId){
    
        String endPoint = 'https://www.googleapis.com/drive/v2/files/' + fileId;
        Integration_Access__c oldUser = [Select Access_Token__c from Integration_Access__c WHERE Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        string accessToken = oldUser.Access_Token__c;
        return GoogleDriveServiceClass.getDownloadLink(endPoint,accessToken);
    }

    // method to delete file or folder from google drive
    @AuraEnabled
    public static string deleteFiles(String fileId){
   
        string endPoint = 'https://www.googleapis.com/drive/v3/files/' + fileId ;
        Integration_Access__c oldUser = [Select Access_Token__c from Integration_Access__c WHERE Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        string accessToken = oldUser.Access_Token__c;
        return GoogleDriveServiceClass.deleteFile(endPoint,accessToken);    
    }

    // create folder on drive .. get folder name and parent id 
    @AuraEnabled
    public static GoogleDriveIntegrationWrapper.Files createFolder(String folderName, String parentId) {
     
        Integration_Access__c oldUser = [Select Access_Token__c from Integration_Access__c WHERE Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        string accessToken = oldUser.Access_Token__c;
        string endPoint = 'https://www.googleapis.com/drive/v3/files';
        string body = '{"name" : "'+ folderName +'","mimeType" : "application/vnd.google-apps.folder"}';
        if(parentId != null) {
            body = '{"name" : "'+ folderName +'","mimeType" : "application/vnd.google-apps.folder","parents" : ["'+ parentId +'"]}';
        } 
        return GoogleDriveServiceClass.createFolder(endPoint, accessToken, body);
    }

    //method to upload file to google drive 
    @AuraEnabled
    public static GoogleDriveIntegrationWrapper.Files uploadFile(String reqBody, String boundary ) {
   
        Integration_Access__c oldUser = [Select Access_Token__c from Integration_Access__c WHERE Name =: userInfo.getUserId() AND Record_Type__c = 'Google Drive'];
        String accessToken = oldUser.Access_Token__c;
        string endPoint = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart';
        return GoogleDriveServiceClass.uploadFile(endPoint,accessToken,reqBody,boundary);
    }
}