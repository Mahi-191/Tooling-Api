public with sharing class GoogleDriveServiceClass {
   
    //method to get tokens and re generate tokens take endpoint url containing authcode or refresh token and returns wraper of tokens
    public static GoogleDriveIntegrationWrapper.GoogleAuth_response generateTkoens (String endpoint){
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('POST');
        request.setHeader('Content-Length', '0');
        request.setEndpoint(endpoint);
        HTTPResponse response = http.send(request);
        //response recived in json then converted in wrapper class object
        system.debug(response.getBody()+' and code is '+ response.getStatuscode());
        GoogleDriveIntegrationWrapper.GoogleAuth_response 
        tokens = (GoogleDriveIntegrationWrapper.GoogleAuth_response)json.deserialize(response.getBody(),GoogleDriveIntegrationWrapper.GoogleAuth_response.class);
        return tokens;
    }

    // Get request to get data from drive and store in wrapper class object
    public static GoogleDriveIntegrationWrapper.GoogleDriveData getFiles (String endPoint, string accessToken){
        HttpRequest request = new HttpRequest();
        HTTPResponse response;
        Http http = new Http();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        request.setHeader('Authorization', 'Bearer '+ accessToken);
        response = http.send(request);
        system.debug(response.getBody()+' and code is '+ response.getStatuscode());
        GoogleDriveIntegrationWrapper.GoogleDriveData
        folderData = (GoogleDriveIntegrationWrapper.GoogleDriveData) JSON.deserialize(response.getBody(),GoogleDriveIntegrationWrapper.GoogleDriveData.class);
        System.debug(folderData);
        return folderData;
    }

    // to get Download url of file .... used Google drive Api v2 that returns webContentLink
    public static string getDownloadLink(string endpoint, string accessToken){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        request.setHeader('Authorization','Bearer ' + accessToken);
        HttpResponse response = http.send(request);
        system.debug(response.getBody()+' and code is '+ response.getStatuscode());
        DownloadLink link = (DownloadLink) JSON.deserialize(response.getBody(),DownloadLink.class);
        return link.webContentLink;
    } 

    // delete request for a file or folder 
    public static String deleteFile(String endPoint, String accessToken){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint(endPoint);
        request.setheader('Authorization', 'Bearer '+accessToken);
        HttpResponse response = http.send(request);
        system.debug(response.getBody()+' and code is '+ response.getStatuscode());
        return String.valueOf(response.getStatuscode());
    }

    //to create new folder in drive (root or any inner folder)
    public static GoogleDriveIntegrationWrapper.Files createFolder(string endPoint, string accessToken, string body){
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');     
        request.setEndpoint(endPoint);
        request.setHeader('Authorization', 'Bearer '+ accessToken);
        request.setHeader('content-type', 'application/json');
        request.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(request);
        system.debug(res.getBody()+' and code is '+ res.getStatuscode());
        GoogleDriveIntegrationWrapper.Files obj = (GoogleDriveIntegrationWrapper.Files) JSON.deserialize(res.getBody(),GoogleDriveIntegrationWrapper.Files.class);
        system.debug('folder created'+ obj);
        return obj;
    }

    // take body of file and send post request to upload file on drive on specific place 
    public static GoogleDriveIntegrationWrapper.Files uploadFile(string endPoint, String accessToken, String fileBody, String boundary){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endPoint);
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'multipart/mixed; boundary=' + boundary);
        request.setHeader('Content-length', String.valueOf(fileBody.length()));
        request.setBody(fileBody);
        HttpResponse res = http.send(request);
        system.debug(res.getBody()+' and code is '+ res.getStatuscode());
        GoogleDriveIntegrationWrapper.Files obj = (GoogleDriveIntegrationWrapper.Files) JSON.deserialize(res.getBody(),GoogleDriveIntegrationWrapper.Files.class);
        obj.name = obj.title;
        system.debug('file uploded'+ obj);
        return obj;
    }

    private class DownloadLink {   
        @AuraEnabled public String webContentLink;
        //@AuraEnabled public String zip;
    }

}