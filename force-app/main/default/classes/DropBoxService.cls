public with sharing class DropBoxService {
    

    // method for all required callouts
    public static HttpResponse callOutNoraml(String endPoint, String body, String callType, Map<String,String> header, Blob blobBody){
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod(callType);
        request.setEndpoint(endpoint);
        if(body != null){
            request.setBody(body);
        }
        if(header != null){
            for(String key : header.keyset()){
                request.setHeader(key,header.get(key));
            }
        }
        if(blobBody != null){
            request.setBodyAsBlob(blobBody);
        }
        HTTPResponse response = http.send(request);
        return response;

    }
}