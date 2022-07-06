public with sharing class PaymentGatewayService {

    //comman callout for both methods for payment
    public static String httpCallout(String endPoint, String body){     
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endPoint);
        request.setBody(body);
        request.setTimeout(60*1000);
        Http http = new Http();       
        HttpResponse response = http.send(request);
        return response.getBody();
    }
}