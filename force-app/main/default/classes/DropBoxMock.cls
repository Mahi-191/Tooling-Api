public with sharing class DropBoxMock implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
        string endPoint = req.getEndpoint();
        HttpResponse res = new HttpResponse();

        //return tokens by taking auth code/Referesh Token 
        if(endPoint == 'https://api.dropboxapi.com/oauth2/token'){
            
            res.setBody('{"access_token":"A1B2C3D4E5F6G7H8I9J10","token_type": "bearer", "expires_in": 14400,"refresh_token":"Z1Y2X3W4V5U6T7S8R9Q10"}');
            res.setStatusCode(200);
        }

        //Return file data get accesstoken
        else if(endPoint == 'https://api.dropboxapi.com/2/files/list_folder'){
           
            res.setBody('{"entries": [{".tag": "folder", "name": "first", "path_lower": "/first", "path_display": "/first", "id": "id:101kgoIPWkIAAAAAAAAABg"}]}}');
            res.setStatusCode(200);
        }

        //create folder request
        else if(endPoint == 'https://api.dropboxapi.com/2/files/create_folder_v2'){
           
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"metadata": {"name": "New Folder", "path_lower": "/first/hah", "path_display": "/first/hah", "id": "id:101kgoIPWkIAAAAAAAAATw"}}');
            res.setStatusCode(200);
        }
        
        
        //delete file request
        else if(endPoint == 'https://api.dropboxapi.com/2/files/delete_v2'){
            
            res.setBody('{"metadata": {".tag": "folder", "name": "New Folder", "path_lower": "/first/hah", "path_display": "/first/hah", "id": "id:101kgoIPWkIAAAAAAAAATw"}}');
            res.setStatusCode(204);
        }
            
       //download file
        else if(endPoint == 'https://api.dropboxapi.com/2/files/get_temporary_link'){
           
            res.setBody('{ "link": "https://testDownloadLink"}');
            res.setStatusCode(200);

        }//UPLOAD FILE REQUEST
        else if(endPoint == 'https://content.dropboxapi.com/2/files/upload'){ 
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"name": "ABC.jpg", "path_lower": "/first/abc.jpg", "path_display": "/first/ABC.jpg", "id": "id:101kgoIPWkIAAAAAAAAAUA", "client_modified": "2022-06-20T06:00:43Z", "server_modified": "2022-06-20T06:00:44Z", "rev": "5e1dad3182c88a2b77e21"}');
            res.setStatusCode(200);
        }

        else{
            res.setStatusCode(404); 
        }
        return res;
    }
}