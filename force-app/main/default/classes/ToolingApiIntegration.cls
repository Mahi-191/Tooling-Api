public with sharing class ToolingApiIntegration {
    
    public static String fetchUserSessionId(){
        String sessionId = '';
        PageReference reportPage = Page.GetSessionIdVF;
        String vfContent = reportPage.getContent().toString();
        Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
        endP = vfContent.indexOf('End_Of_Session_Id');
        sessionId = vfContent.substring(startP, endP);
        return sessionId;
    }

    @AuraEnabled
    public static ToolingApiWrapper getAllMatadata(){
        System.debug( 'url is '+URL.getSalesforceBaseUrl().toExternalForm());
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + fetchUserSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('https://briskminds32-dev-ed.my.salesforce.com/services/data/v39.0/tooling/sobjects');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug('response recived '+res.getBody());
        if(res.getStatusCode() == 200){
            ToolingApiWrapper result =  (ToolingApiWrapper)JSON.deserialize(res.getBody(),ToolingApiWrapper.class);
            System.debug('sobjects are '+ result.sobjects.size());
            System.debug('result ' + result);
            return result;
        }
        else {
            return null;
        }
    }

    @AuraEnabled
    public static ToolingApiWrapper getDataList(String name){
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + fetchUserSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('https://briskminds32-dev-ed.my.salesforce.com/services/data/v39.0/tooling/query/?q=select+id,Name+FROM+'+name);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        system.debug(res.getBody());
        system.debug(res.getStatusCode());
        if(res.getStatusCode() == 200){
            ToolingApiWrapper result =  (ToolingApiWrapper)JSON.deserialize(res.getBody(),ToolingApiWrapper.class);
            return result;
        }
        else{
            return null;
        }
    }


}