@isTest
public class GoogleDriveMock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req){
        string endPoint = req.getEndpoint();
        HttpResponse res = new HttpResponse();

        //return tokens get auth code 
        if(endPoint == 'https://oauth2.googleapis.com/token?code=TESTauthCODEabcdefghijklmnopqrstuvwxyz&grant_type=authorization_code&access_type=offline&client_id=37712708779-ktaa3725goggq1na07p32e3p29239ko1.apps.googleusercontent.com&client_secret=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&redirect_uri=https://scsinfra-developer-edition.ap27.force.com/integration/s/google-drive'){
            System.assertEquals('POST', req.getMethod());
            res.setBody('{"access_token":"A1B2C3D4E5F6G7H8I9J10","expires_in":"3000","scope":" ","token_type":"test","refresh_token":"Z1Y2X3W4V5U6T7S8R9Q10"}');
            res.setStatusCode(200);
            
        }//return tokens get refresh token
        else if(endPoint == 'https://oauth2.googleapis.com/token?grant_type=refresh_token&client_id=37712708779-ktaa3725goggq1na07p32e3p29239ko1.apps.googleusercontent.com&client_secret=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&refresh_token=testCLASSrefreshTOKEN'){
            System.assertEquals('POST', req.getMethod());
            res.setBody('{"access_token":"A1B2C3D4E5F6G7H8I9J10k11","expires_in":"3000","scope":" ","token_type":"test","refresh_token":""}');
            res.setStatusCode(200);
           
        }//Return file data get accesstoken
        else if(endPoint == 'https://www.googleapis.com/drive/v3/files?q=\'root\'+in+parents&trashed=false'){
            System.assertEquals('GET', req.getMethod());
            res.setBody('{"kind": "drive#fileList","incompleteSearch": false,"files": [{"kind": "drive#file","id": "19fczRNhR-pZWq5UqUUc2wYwRrd6PG5pp","name": "bmnija.jpg","mimeType": "image/jpeg"}]}');
            res.setStatusCode(200);

        }//create folder request
        else if(endPoint == 'https://www.googleapis.com/drive/v3/files'){
            System.assertEquals('POST', req.getMethod());
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"kind": "drive#file","id": "19fczRNhR-pZWq5UqUUc2wYwRrd6PG5pp","name": "New Folder","mimeType": "application/vnd.google-apps.folder"}');
            res.setStatusCode(200);
           
        }//delete file request
        else if(endPoint == 'https://www.googleapis.com/drive/v3/files/FIELDTESTID12345'){
            System.assertEquals('DELETE', req.getMethod());
            res.setBody('');
            res.setStatusCode(204);
            
        }//download file
        else if(endPoint == 'https://www.googleapis.com/drive/v2/files/FIELDTESTID12345'){
            System.assertEquals('GET', req.getMethod());
            res.setBody('{ "webContentLink": "https://drive.google.com/uc?id=ABCD&export=download", "kind": "drive#file","id": "123ABCD","mimeType": "image/png","title": "ABC.png"}');
            res.setStatusCode(200);

        }//UPLOAD FILE REQUEST
        else if(endPoint == 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart'){ 
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "webContentLink": "https://drive.google.com/uc?id=ABCD&export=download", "kind": "drive#file","id": "123ABCD","mimeType": "image/png","title": "ABC.png"}');
            res.setStatusCode(200);
        }
        else{
            res.setStatusCode(404); 
        }
        return res;
    }

}