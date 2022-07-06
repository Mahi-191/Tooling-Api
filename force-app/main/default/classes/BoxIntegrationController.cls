public with sharing class BoxIntegrationController {
    
    //get current user related access data if available return data else return null
    @AuraEnabled
    public static Integration_Access__c getUser(){
        List<Integration_Access__c> user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
        if(user.size()==0){
            return null;
        }
        else{
            return user[0];
        }
    }

     //method to check Access Token expired or not
     @AuraEnabled
     public static boolean isExpired(){
         Integration_Access__c user = [select Expire_In__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
         return (user.Expire_In__c < System.now());
     }
    
    @AuraEnabled
    public static String redirectAuthURI() {
        String authUri = 'https://account.box.com/api/oauth2/authorize'+
        '?client_id='+Auth_Data__mdt.getInstance('Box').AppKey__c+
        '&response_type=code'+
        '&redirect_uri='+Auth_Data__mdt.getInstance('Box').Redirect_Url__c;        
        Integration_Access__c user = new Integration_Access__c(name = userInfo.getUserId(), Record_Type__c = 'Box.com');
        insert user;
        return authUri;
    }

    @AuraEnabled
    public static void getTokens(String code){
        String endPoint = 'https://api.box.com/oauth2/token';
        String messageBody = 'code='+code+'&client_id='+ Auth_Data__mdt.getInstance('Box').AppKey__c
                        +'&client_secret='+Auth_Data__mdt.getInstance('Box').AppScret__c
                        +'&redirect_uri='+Auth_Data__mdt.getInstance('Box').Redirect_Url__c
                        +'&grant_type=authorization_code';                  
        
        BoxWrapper.tokens tokens = BoxIntegrationServiceClass.generateTkoens(endPoint, messageBody);

        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
        user.Access_Token__c = tokens.access_token;
        user.Refresh_token__c = tokens.refresh_token;
        Double exp = tokens.expires_in;
        user.Expire_In__c = System.now()+(exp/60/60/24);
        update user;
    }
    
    //regenerate access token when expired
    @AuraEnabled
    public Static void reGenerateTkoen(){
        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
        String endPoint = 'https://api.box.com/oauth2/token';
        String messageBody = 'refresh_token='+user.Refresh_token__c+'&client_id='+ Auth_Data__mdt.getInstance('Box').AppKey__c
                            +'&client_secret='+Auth_Data__mdt.getInstance('Box').AppScret__c
                            +'&redirect_uri='+Auth_Data__mdt.getInstance('Box').Redirect_Url__c
                            +'&grant_type=refresh_token';      
       
       
        BoxWrapper.tokens tokens = BoxIntegrationServiceClass.generateTkoens(endPoint,messageBody);
        user.Access_Token__c = tokens.access_token;
        user.Refresh_token__c = tokens.refresh_token;
        Double exp = tokens.expires_in;
        user.Expire_In__c = System.now()+(exp/60/60/24);
        update user;
    }

    
    @AuraEnabled
    public static BoxWrapper.allData fetchData(string parent) {
        
     
        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
        String accessToken = user.Access_Token__c;
        String endPoint = 'https://api.box.com/2.0/folders/'+parent;
        String response = BoxIntegrationServiceClass.fetchFiles(endPoint,accessToken);
        BoxWrapper.allData data = (BoxWrapper.allData) JSON.deserialize(response, BoxWrapper.allData.class);
        return data;
     }

     @AuraEnabled
     public static BoxWrapper.entries createFolder(String folderName, String parentId) {
     
        String endPoint = 'https://api.box.com/2.0/folders';
        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
        String accessToken = user.Access_Token__c;
        String body = '{"name" : "'+ folderName +'","parent" : {"id" :  "'+ parentId +'" }}'; 
         String response = BoxIntegrationServiceClass.createNewFolder(endPoint, accessToken, body);
         BoxWrapper.entries data = (BoxWrapper.entries) JSON.deserialize(response, BoxWrapper.entries.class);
         return data;
         
     }
     @AuraEnabled
     public static string deleteFiles( String itemType, String itemId) {
     
        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
        String accessToken = user.Access_Token__c;
        string endPoint;
         if(itemType == 'folder') {
            endpoint = 'https://api.box.com/2.0/folders/'+itemId;
         } else {
            endpoint = 'https://api.box.com/2.0/files/'+itemId;
         }
         String response = BoxIntegrationServiceClass.deleteItem(endPoint, accessToken);
         return response;
     }

     @AuraEnabled
     public static string downloadFiles(String fileId) {
     
         Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
         String accessToken = user.Access_Token__c;
         String endPoint = 'https://api.box.com/2.0/files/' + fileId + '/content';
         string url = BoxIntegrationServiceClass.download(endPoint, accessToken);
        return url;
     }

     @AuraEnabled
     public static BoxWrapper.item_collection uploadFile(Blob fileContents, String parentFolderId, String fileName) {
      
        Integration_Access__c user = [select name, Access_Token__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'Box.com'];
        String accessToken = user.Access_Token__c;
         String result = BoxIntegrationServiceClass.uploadFile(fileContents, parentFolderId, fileName, accessToken);
         BoxWrapper.item_collection data = (BoxWrapper.item_collection) JSON.deserialize(result, BoxWrapper.item_collection.class);
         return data;
     }
}