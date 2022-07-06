@isTest
public with sharing class BoxMockClass implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req){
        string endPoint = req.getEndpoint();
        HttpResponse res = new HttpResponse();

        //return tokens by taking auth code/Referesh Token 
        if(endPoint == 'https://api.box.com/oauth2/token'){
            System.assertEquals('POST', req.getMethod());
            res.setBody('{"access_token":"A1B2C3D4E5F6G7H8I9J10","expires_in":"3000","scope":" ","token_type":"test","refresh_token":"Z1Y2X3W4V5U6T7S8R9Q10"}');
            res.setStatusCode(200);
        }
        
        //Return file data get accesstoken
        else if(endPoint == 'https://api.box.com/2.0/folders/0'){
            System.assertEquals('GET', req.getMethod());
            res.setBody('{"item_collection": {"entries": [{"sequence_id": "1","id": "234567","name": "bmninja.jpg","type": "file"}]}}');
            res.setStatusCode(200);

        }
        
        //create folder request
        else if(endPoint == 'https://api.box.com/2.0/folders'){
            System.assertEquals('POST', req.getMethod());
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"sequence_id": "1","id": "FOLDER123","name": "New Folder","Type": "folder"}');
            res.setStatusCode(200);
           
        }
        
        //delete file request
        else if(endPoint == 'https://api.box.com/2.0/files/FIELDTESTID12345'){
            System.assertEquals('DELETE', req.getMethod());
            res.setBody('');
            res.setStatusCode(204);
        }
            
        //delete folder request
        else if(endPoint == 'https://api.box.com/2.0/folders/FolderID12345'){
            System.assertEquals('DELETE', req.getMethod());
            res.setBody('');
            res.setStatusCode(204);
            
        }//download file
        else if(endPoint == 'https://api.box.com/2.0/files/FileId12345/content'){
            System.assertEquals('GET', req.getMethod());
            res.setBody('{ "location": "https://public.boxcloud.com/d/1/TestCode"}');
            res.setHeader('location','https://public.boxcloud.com/d/1/TestCode');
            res.setStatusCode(200);

        }//UPLOAD FILE REQUEST
        else if(endPoint == 'https://upload.box.com/api/2.0/files/content?parent_id=ParentId'){ 
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"entries": [{"sequence_id": "1","id": "234567","name": "ABC.jpg","type": "file"}]}');
            res.setStatusCode(200);
        }
        else{
            res.setHeader('location','https://public.boxcloud.com/d/1/TestCode');
            res.setStatusCode(404); 
        }
        return res;
    }
}