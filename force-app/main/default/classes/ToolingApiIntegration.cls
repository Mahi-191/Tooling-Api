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
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + fetchUserSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('https://briskminds32-dev-ed.my.salesforce.com/services/data/v39.0/tooling/sobjects');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 200){
            ToolingApiWrapper result =  (ToolingApiWrapper)JSON.deserialize(res.getBody(),ToolingApiWrapper.class);
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
        if(res.getStatusCode() == 200){
            ToolingApiWrapper result =  (ToolingApiWrapper)JSON.deserialize(res.getBody(),ToolingApiWrapper.class);
            return result;
        }
        else{
            return null;
        }
    }


}