public with sharing class BoxIntegrationServiceClass {

    //generate tokens
    public static BoxWrapper.tokens generateTkoens (String endpoint, String messageBody){
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-length', String.valueOf(messageBody.length()));
        request.setBody(messageBody);
        HTTPResponse response = http.send(request);
        system.debug(response.getBody()+' and code is '+ response.getStatuscode());
        BoxWrapper.tokens tokens = (BoxWrapper.tokens)json.deserialize(response.getBody(),BoxWrapper.tokens.class);
        System.debug(tokens);
        return tokens;
    }

    public static string fetchFiles(String endPoint, string accessToken){
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endPoint);
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        req.setHeader('Authorization' , 'Bearer '+ accessToken);
        Http http = new Http();
        HttpResponse response = http.send(req);
        String result;
        if(response.getStatusCode() == 200) {
            result = response.getBody();
        }
        return result;
    }

    public static string createNewFolder(String endPoint, String accessToken, String body){
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');     
        req.setEndpoint(endPoint);
        req.setHeader('Authorization','Bearer '+ accessToken);
        req.setHeader('content-type', 'application/json');
        req.setBody(body);
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
        return res.getBody();
    }

    public static string deleteItem(String endPoint, String accessToken){
        HttpRequest req = new HttpRequest();
        req.setMethod('DELETE');     
        req.setEndpoint(endPoint);
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization','Bearer '+ accessToken);
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug(res.getStatusCode());
        return String.valueOf(res.getStatuscode());
    }
    
    public static String download(String endPoint, String accessToken){
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');
        req.setHeader('Authorization' , 'Bearer'+' '+ accessToken);
        Http h = new Http();
        HttpResponse res = h.send(req);
        system.debug('Body of response = '+ res.getBody());
        return res.getHeader('location');
    }
 
     public static string uploadFile(Blob fileContents, String parentFolderId, String fileName, String accessToken) {
         blob encodeFile = encodeFile(fileContents, filename);
         String endPoint='https://upload.box.com/api/2.0/files/content?parent_id='+parentFolderId;
         String boundary = 'BounderyByMahimay2022';
         HttpRequest req = new HttpRequest();
         req.setBodyAsBlob(encodeFile);
         req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
         req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
         req.setHeader('Authorization', 'Bearer'+' '+ accessToken);
         req.setMethod('POST');
         req.setEndpoint(endPoint);
         Http h = new Http();
         HTTPResponse res = h.send(req);
         String Response=res.getBody();
         return Response;
     }
    
     public static blob encodeFile(Blob file_body, String file_name) {
         String boundary = 'BounderyByMahimay2022';
         String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
         String footer = '--'+boundary+'--';             
         String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
         while(headerEncoded.endsWith('='))
         {
             header+=' ';
             headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
         }
         String bodyEncoded = EncodingUtil.base64Encode(file_body);
         Blob bodyBlob = null;
         String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
  
        if(last4Bytes.endsWith('==')) {
             last4Bytes = last4Bytes.substring(0,2) + '0K';
             bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
         } 
        else if(last4Bytes.endsWith('=')) {
             last4Bytes = last4Bytes.substring(0,3) + 'N';
             bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
             footer = '\n' + footer;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
        }
        else {
             footer = '\r\n' + footer;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
         }
  
         return bodyBlob;
     }
}