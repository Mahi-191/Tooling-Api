public with sharing class DropBoxIntegration {

    // return request URl to get AuthCode 
    @AuraEnabled
    public static string authCodeRequest(){
        String authUri = 'https://www.dropbox.com/oauth2/authorize'+'?client_id='+Auth_Data__mdt.getInstance('Drop_Box').AppKey__c+
        '&token_access_type=offline&response_type=code' + '&redirect_uri='+Auth_Data__mdt.getInstance('Drop_Box').Redirect_Url__c;        
        return authUri;
    }

    //check user data is inserted or not
    @AuraEnabled
    public static Boolean isUserExist(){
        List<Integration_Access__c> user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
        if(user.size()==0){
            return false;
        }
        else{
            return true;
        }
    }

    // check Access Token Expiry
    @AuraEnabled
    public static Boolean isExpired(){
        Integration_Access__c user = [select Expire_In__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
        return (user.Expire_In__c < System.now());
    }
   
    // get tokens by Authcode 
    @AuraEnabled
    public static void getTokens(String authCode){
        System.debug(authCode);
        if(!(isUserExist())){
            String endPoint = 'https://api.dropboxapi.com/oauth2/token';
            String body =  'grant_type=authorization_code'+'&code='+ authCode +
                    '&client_id=' + Auth_Data__mdt.getInstance('Drop_Box').AppKey__c +
                    '&client_secret=' + Auth_Data__mdt.getInstance('Drop_Box').AppScret__c +
                    '&redirect_uri=' + Auth_Data__mdt.getInstance('Drop_Box').Redirect_Url__c ;
            String type = 'POST';
            HttpResponse response = DropBoxService.callOutNoraml(endPoint, body, type, null, null);
            System.debug(response.getBody());
            if(response.getStatuscode() == 200 ){
                DropBoxWrapper.tokens token =  (DropBoxWrapper.tokens)JSON.deserialize(response.getBody(),DropBoxWrapper.tokens.class);
                Integration_Access__c userIns = new Integration_Access__c();
                userIns.Name = UserInfo.getUserId();
                userIns.Access_Token__c = token.access_token;
                userIns.Refresh_token__c = token.refresh_token;
                Double expTime = token.expires_in;
                userIns.Record_Type__c = 'DropBox';
                userIns.Expire_In__c = System.now()+(expTime/60/60/24);
                insert userIns;
            }
        }
    }

     //method to get access token from refresh token
     @AuraEnabled
     public static void regenerateAccessToken(){
        List<Integration_Access__c> user = [select Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
		string endPoint='https://api.dropboxapi.com/oauth2/token';
		String body ='grant_type=refresh_token'+
			   '&refresh_token='+user[0].Refresh_token__c+
			   '&client_id='+ Auth_Data__mdt.getInstance('Drop_Box').AppKey__c +
			   '&client_secret='+Auth_Data__mdt.getInstance('Drop_Box').AppScret__c;
		String type = 'GET';
        HttpResponse response = DropBoxService.callOutNoraml(endPoint, body, type, null, null);
        if(response.getStatuscode() == 200 ){
            DropBoxWrapper.tokens token =  (DropBoxWrapper.tokens)JSON.deserialize(response.getBody(),DropBoxWrapper.tokens.class);
            user[0].Access_Token__c = token.access_token;
            Double expTime = token.expires_in;
            user[0].Expire_In__c = System.now()+(expTime/60/60/24);
            update user;
        }
        else{
            delete user;
        }
	
    }

    //get data from dropBox 
    @AuraEnabled
    public static DropBoxWrapper getData(String parent){
        List<Integration_Access__c> user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
        Map<String,String> headers = new Map<String,String>();
        String endPoint = 'https://api.dropboxapi.com/2/files/list_folder';
        String type = 'GET';
        headers.put('Authorization', 'Bearer '+user[0].Access_Token__c);
        headers.put('Content-Type', 'application/json');
        String body = '{"path": "'+parent+'","recursive": false,"include_media_info": false,"include_deleted": false,"include_has_explicit_shared_members": false,"include_mounted_folders": true,"include_non_downloadable_files": true}';
        HttpResponse response = DropBoxService.callOutNoraml(endPoint, body, type, headers, null);
        System.debug('Response   :: '+response.getBody());

        if(response.getStatuscode() == 200 ){
            String resp = response.getBody();
            String finalResp = resp.replace('.tag', 'tag');
            System.debug(finalResp);
            DropBoxWrapper data =  (DropBoxWrapper)JSON.deserialize(finalResp,DropBoxWrapper.class);
            return data;
        }
        else{
            return null;
        }
    }

    // create folder on dropbox 
    @AuraEnabled
    public static DropBoxWrapper.entries createNewFolder(String name, String path) {
        List<Integration_Access__c> user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
        String body = '{ "path": "' + path + '/' + name + '", "autorename": false }';
        String endPoint = 'https://api.dropboxapi.com/2/files/create_folder_v2';
        String type = 'POST';
        Map<String,String> headers = new Map<String,String>();
        headers.put('Authorization', 'Bearer '+user[0].Access_Token__c);
        headers.put('Content-Type', 'application/json');
        HttpResponse response = DropBoxService.callOutNoraml(endPoint, body, type, headers, null);
        if(response.getStatuscode() == 200 ){
            String resp = response.getBody();
            System.debug(resp);
            String finalResp = resp.replace('{"metadata":', '');
            DropBoxWrapper.entries data =  (DropBoxWrapper.entries)JSON.deserialize(finalResp,DropBoxWrapper.entries.class);
            System.debug(finalResp);
            data.tag = 'folder';
            System.debug(data);
            return data;
        }
        else{
            return null;
        }
    }

    //method to delete file or folder from dropbox 
    @AuraEnabled
    public static String deleteItem(String path) {
        String endPoint = 'https://api.dropboxapi.com/2/files/delete_v2';
        List<Integration_Access__c> user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
        String body = '{"path": "' + path + '"}';
        String type = 'POST';
        Map<String,String> headers = new Map<String,String>();
        headers.put('Authorization', 'Bearer '+user[0].Access_Token__c);
        headers.put('Content-Type', 'application/json');
        HttpResponse response = DropBoxService.callOutNoraml(endPoint, body, type, headers, null);
        System.debug(response.getBody());
        return response.getBody();
    }

    // method to get temporary download link of a file 
    @AuraEnabled
    public static String downloadData(String path) {
        String endPoint = 'https://api.dropboxapi.com/2/files/get_temporary_link';
        List<Integration_Access__c> user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
        String body = '{"path": "' + path + '"}';
        String type = 'POST';
        Map<String,String> headers = new Map<String,String>();
        headers.put('Authorization', 'Bearer '+user[0].Access_Token__c);
        headers.put('Content-Type', 'application/json');
        HttpResponse response = DropBoxService.callOutNoraml(endPoint, body, type, headers, null);
        System.debug(response.getBody());
        
        DropBoxWrapper data =  (DropBoxWrapper)JSON.deserialize(response.getBody(),DropBoxWrapper.class);

        return data.link;
    }

    // method to upload file to drive 
    @AuraEnabled
    public static DropBoxWrapper.entries uploadFile(string path, String name, String file) {
        Integration_Access__c user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId() AND Record_Type__c = 'DropBox'];
        
        file = EncodingUtil.urlDecode(file, 'UTF-8');
        // Attachment atch = new Attachment();
        // atch.Body = EncodingUtil.base64Decode(file);
        // atch.Name = name;
        // atch.ContentType = 'application/octet-stream';
        // String bodyEncoded = EncodingUtil.base64Encode(atch.Body);
        Blob bodyEncoded2 = EncodingUtil.base64Decode(file);
        String body = '{ "path": "' + path + '/' + name +'","mode":{".tag":"overwrite"},"autorename":true,"mute":false}';

        String type = 'POST';
        String endPoint = 'https://content.dropboxapi.com/2/files/upload';
        Map<String,String> headers = new Map<String,String>();
        headers.put('Authorization', 'Bearer ' + user.Access_Token__c);
        headers.put('Content-Type', 'application/octet-stream');
        headers.put('Dropbox-API-Arg', body);
        headers.put('Content-length', String.valueOf(bodyEncoded.length()));

        HttpResponse response = DropBoxService.callOutNoraml(endPoint, body, type, headers, bodyEncoded2);
        System.debug('Response   :: '+response.getBody());
        if(response.getStatuscode() == 200 ){
            DropBoxWrapper.entries data =  (DropBoxWrapper.entries)JSON.deserialize(response.getBody(),DropBoxWrapper.entries.class);
            System.debug('wrapper response is '+ data);
            return data;
        }
        else{
            return null;
        }
    }
}