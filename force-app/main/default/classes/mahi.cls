public class mahi {

    public static void upload(){
        String x = '-------314159265358979323846';
        String y = '---------314159265358979323846\n'+
        'Content-Type: application/json\n'+
        
        '{"title":"hello","mimeType":"text/plain"}\n'+
        '---------314159265358979323846\n'+
        'Content-Type: text/plain\n'+
        'Content-Transfer-Encoding: base64\n'+
        
        'cHVibGljIGNsYXNzIEpzb25QYXJzZXJ7DQoJCXB1YmxpYyBCb29sZWFuIGluY29tcGxldGVTZWFyY2h7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgbmV4dFBhZ2VUb2tlbntnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBzZWxmTGlua3tnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBuZXh0TGlua3tnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBldGFne2dldDtzZXQ7fQ0KCQlwdWJsaWMgbGlzdDxpdGVtcz4gaXRlbXN7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcga2luZHtnZXQ7c2V0O30NCglwdWJsaWMgY2xhc3MgdXNlclBlcm1pc3Npb257DQoJCXB1YmxpYyBTdHJpbmcgaWR7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgZXRhZ3tnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBzZWxmTGlua3tnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBraW5ke2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIHJvbGV7Z2V0O3NldDt9DQoJCXB1YmxpYyBCb29sZWFuIHBlbmRpbmdPd25lcntnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyB0eXBle2dldDtzZXQ7fQ0KCX0NCglwdWJsaWMgY2xhc3Mgc2hhcmluZ1VzZXJ7DQoJCXB1YmxpYyBTdHJpbmcgZW1haWxBZGRyZXNze2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIHBlcm1pc3Npb25JZHtnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gaXNBdXRoZW50aWNhdGVkVXNlcntnZXQ7c2V0O30NCgkJcHVibGljIHBpY3R1cmUgcGljdHVyZXtnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBkaXNwbGF5TmFtZXtnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBraW5ke2dldDtzZXQ7fQ0KCX0NCglwdWJsaWMgY2xhc3MgcGljdHVyZXsNCgkJcHVibGljIFN0cmluZyB1cmx7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgdXJse2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIHVybHtnZXQ7c2V0O30NCgl9DQoJcHVibGljIGNsYXNzIG93bmVyc3sNCgkJcHVibGljIFN0cmluZyBraW5ke2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGRpc3BsYXlOYW1le2dldDtzZXQ7fQ0KCQlwdWJsaWMgcGljdHVyZSBwaWN0dXJle2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIHBlcm1pc3Npb25JZHtnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBlbWFpbEFkZHJlc3N7Z2V0O3NldDt9DQoJCXB1YmxpYyBCb29sZWFuIGlzQXV0aGVudGljYXRlZFVzZXJ7Z2V0O3NldDt9DQoJfQ0KCXB1YmxpYyBjbGFzcyBsYXN0TW9kaWZ5aW5nVXNlcnsNCgkJcHVibGljIFN0cmluZyBkaXNwbGF5TmFtZXtnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gaXNBdXRoZW50aWNhdGVkVXNlcntnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBwZXJtaXNzaW9uSWR7Z2V0O3NldDt9DQoJCXB1YmxpYyBwaWN0dXJlIHBpY3R1cmV7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgZW1haWxBZGRyZXNze2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGtpbmR7Z2V0O3NldDt9DQoJfQ0KCXB1YmxpYyBjbGFzcyBsYWJlbHN7DQoJCXB1YmxpYyBCb29sZWFuIHZpZXdlZHtnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gdHJhc2hlZHtnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gaGlkZGVue2dldDtzZXQ7fQ0KCQlwdWJsaWMgQm9vbGVhbiByZXN0cmljdGVke2dldDtzZXQ7fQ0KCQlwdWJsaWMgQm9vbGVhbiBzdGFycmVke2dldDtzZXQ7fQ0KCX0NCglwdWJsaWMgY2xhc3MgaXRlbXN7DQoJCXB1YmxpYyBsaXN0PFN0cmluZz4gcGFyZW50c3tnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyB2ZXJzaW9ue2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIHNoYXJlZFdpdGhNZURhdGV7Z2V0O3NldDt9DQoJCXB1YmxpYyBzaGFyaW5nVXNlciBzaGFyaW5nVXNlcntnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBtYXJrZWRWaWV3ZWRCeU1lRGF0ZXtnZXQ7c2V0O30NCgkJcHVibGljIGV4cG9ydExpbmtzIGV4cG9ydExpbmtze2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGxhc3RWaWV3ZWRCeU1lRGF0ZXtnZXQ7c2V0O30NCgkJcHVibGljIHVzZXJQZXJtaXNzaW9uIHVzZXJQZXJtaXNzaW9ue2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIG1vZGlmaWVkQnlNZURhdGV7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgZmlsZVNpemV7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgbW9kaWZpZWREYXRle2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIHF1b3RhQnl0ZXNVc2Vke2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGNyZWF0ZWREYXRle2dldDtzZXQ7fQ0KCQlwdWJsaWMgbGlzdDxTdHJpbmc+IG93bmVyTmFtZXN7Z2V0O3NldDt9DQoJCXB1YmxpYyBCb29sZWFuIGNvcHlSZXF1aXJlc1dyaXRlclBlcm1pc3Npb257Z2V0O3NldDt9DQoJCXB1YmxpYyBsaXN0PG93bmVycz4gb3duZXJze2dldDtzZXQ7fQ0KCQlwdWJsaWMgbGFiZWxzIGxhYmVsc3tnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBsYXN0TW9kaWZ5aW5nVXNlck5hbWV7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgbWltZVR5cGV7Z2V0O3NldDt9DQoJCXB1YmxpYyBsYXN0TW9kaWZ5aW5nVXNlciBsYXN0TW9kaWZ5aW5nVXNlcntnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyB0aXRsZXtnZXQ7c2V0O30NCgkJcHVibGljIGNhcGFiaWxpdGllcyBjYXBhYmlsaXRpZXN7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgdGh1bWJuYWlsTGlua3tnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gZWRpdGFibGV7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgaWNvbkxpbmt7Z2V0O3NldDt9DQoJCXB1YmxpYyBCb29sZWFuIGNvcHlhYmxle2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGVtYmVkTGlua3tnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gd3JpdGVyc0NhblNoYXJle2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGFsdGVybmF0ZUxpbmt7Z2V0O3NldDt9DQoJCXB1YmxpYyBCb29sZWFuIHNoYXJlZHtnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBzZWxmTGlua3tnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gZXhwbGljaXRseVRyYXNoZWR7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgZXRhZ3tnZXQ7c2V0O30NCgkJcHVibGljIEJvb2xlYW4gYXBwRGF0YUNvbnRlbnRze2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGlke2dldDtzZXQ7fQ0KCQlwdWJsaWMgbGlzdDxTdHJpbmc+IHNwYWNlc3tnZXQ7c2V0O30NCgkJcHVibGljIFN0cmluZyBraW5ke2dldDtzZXQ7fQ0KCX0NCglwdWJsaWMgY2xhc3MgZXhwb3J0TGlua3N7DQoJCXB1YmxpYyBTdHJpbmcgdGV4dC9jc3Z7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgYXBwbGljYXRpb24vemlwe2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGFwcGxpY2F0aW9uL3ZuZC5vcGVueG1sZm9ybWF0cy1vZmZpY2Vkb2N1bWVudC5zcHJlYWRzaGVldG1sLnNoZWV0e2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIGFwcGxpY2F0aW9uL3ZuZC5vYXNpcy5vcGVuZG9jdW1lbnQuc3ByZWFkc2hlZXR7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgYXBwbGljYXRpb24vcGRme2dldDtzZXQ7fQ0KCQlwdWJsaWMgU3RyaW5nIHRleHQvdGFiLXNlcGFyYXRlZC12YWx1ZXN7Z2V0O3NldDt9DQoJCXB1YmxpYyBTdHJpbmcgYXBwbGljYXRpb24veC12bmQub2FzaXMub3BlbmRvY3VtZW50LnNwcmVhZHNoZWV0e2dldDtzZXQ7fQ0KCX0NCglwdWJsaWMgY2xhc3MgY2FwYWJpbGl0aWVzew0KCQlwdWJsaWMgQm9vbGVhbiBjYW5Db3B5e2dldDtzZXQ7fQ0KCQlwdWJsaWMgQm9vbGVhbiBjYW5FZGl0e2dldDtzZXQ7fQ0KCX0NCn0=\n'
        +'---------314159265358979323846--';
        IntegrationController.uploadFile(y, x);
    }
     //*Method to delete files & folders */
     @AuraEnabled
     public static string deleteFileService(String accessToken, String selectedFolderType, String selectedFolderId) {
         System.debug('serviceselectedFolderType -->'+selectedFolderType);
         System.debug('selectedFolderId-->'+selectedFolderId);
         HttpRequest req = new HttpRequest();
         req.setMethod('DELETE');
         if(selectedFolderType == 'folder') {
             req.setEndpoint('https://api.box.com/2.0/folders/'+selectedFolderId);
         } else {
             req.setEndpoint('https://api.box.com/2.0/files/'+selectedFolderId);
         }
         req.setHeader('Accept','application/json');
         req.setHeader('Authorization','Bearer'+' '+ accessToken);
 
         Http h = new Http();
         HttpResponse response = h.send(req);
         String result = response.getBody();
         return result;
     }
 
     //*Method to crate new folder at root or within any folder */
     @AuraEnabled
     public static string createNewFolderService(String newFolderName, String parentFolderId , String accessToken) {
         system.debug('newfoldername at service  --->'+newFolderName);
         system.debug('parentFolderId at service  --->'+parentFolderId);
         system.debug('accessToken at service  --->'+accessToken);
         HttpRequest req = new HttpRequest();
         req.setMethod('POST');     
         req.setEndpoint('https://api.box.com/2.0/folders');
         req.setHeader('Authorization','Bearer'+' '+ accessToken);
         req.setHeader('content-type', 'application/json');
         String body = '{"name": "'+newFolderName+'", "parent": {"id": "0"}}';
         if(parentFolderId != null) {
             body = '{"name" : "'+ newFolderName +'","parent" : {"id" :  "'+parentFolderId+'" }}';
         } 
         system.debug('---API Body----'+ body);
         req.setBody(body);
         Http h = new Http();
         HttpResponse res = h.send(req);
         String response = res.getBody();
         return response;
     }
 
     //*Method to download files/
     @AuraEnabled
     public static string downloadFileService(String fileId, String accessToken) {
         HttpRequest req = new HttpRequest();
         req.setMethod('GET');
         req.setEndpoint('https://api.box.com/2.0/files/' + fileId + '/content');
         req.setHeader('Content-Type','application/json');
         req.setHeader('Accept','application/json');
         req.setHeader('Authorization' , 'Bearer'+' '+ accessToken);
         Http h = new Http();
         HttpResponse res = h.send(req);
         String downloadURL = res.getHeader('location');
         return downloadURL;
     }
 
     //*Method to dowload files */
     @AuraEnabled
     public static string uploadFileService(Blob fileContents, String parentFolderId, String fileName, String accessToken) {
         blob base64EncodeFile = base64EncodeFileContent(fileContents, filename);
         String uploadEndPointURL='https://upload.box.com/api/2.0/files/content?parent_id='+parentFolderId;
         String boundary = '----------------------------741e90d31eff';
         HttpRequest req = new HttpRequest();
         req.setBodyAsBlob(base64EncodeFile);
         req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
         req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
         req.setHeader('Authorization', 'Bearer'+' '+ accessToken);
         req.setMethod('POST');
         req.setEndpoint(uploadEndPointURL);
         req.setTimeout(120000);
         //Send request to Box
         Http h = new Http();
         HTTPResponse res = h.send(req);
         String Response=res.getBody();
         System.debug('**Files upload Response:'+Response);
         Integer uploadStatusCode = res.getStatusCode();
         if(uploadStatusCode==201){
             System.debug('File uploaded successfully');
         }else{
             System.debug('Error');
         }
         return Response;
     }
    
     //*Method to convert blob into base 64 encode file */
     @AuraEnabled
     public static blob base64EncodeFileContent(Blob file_body, String file_name) {
         String boundary = '----------------------------741e90d31eff';
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
         } else if(last4Bytes.endsWith('=')) {
             last4Bytes = last4Bytes.substring(0,3) + 'N';
             bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
             footer = '\n' + footer;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
         } else {
             footer = '\r\n' + footer;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
         }
  
         return bodyBlob;
     }
}