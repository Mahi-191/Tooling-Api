public with sharing class SalesforceIntegrationMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req){
        string endPoint = req.getEndpoint();
        HttpResponse res = new HttpResponse();
    
        // Upload file to api org response 
        if(endPoint == 'callout:mnc32Api/services/apexrest/upload'){       
            res.setStatusCode(302);
            res.setHeader('Location','callout:mnc32Api/services/apexrest/upload/changed');
        }       
        
         // Upload file to api org response 
        else if(endPoint == 'callout:mnc32Api/services/apexrest/upload/changed'){       
            res.setBody('"testFile.png"');
            res.setStatusCode(200);
        }    
        else{
            res.setStatusCode(404); 
        }

        return res;
    
    }
}