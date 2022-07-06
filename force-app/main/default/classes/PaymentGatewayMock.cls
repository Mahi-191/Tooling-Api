@isTest
public with sharing class PaymentGatewayMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request){   
        HTTPResponse res = new HTTPResponse();
        //check endpoint recived from creditcard payment method and set dummy body     
        if(request.getEndpoint()=='https://apitest.authorize.net/xml/v1/request.api?content-type=application/json&Content-length=325'){
           string body = ' {"transactionResponse":{"responseCode":"1","authCode":"HH5414","avsResultCode":"Y","cvvResultCode":"S","cavvResultCode":"6","transId":"77422715","refTransID":"","transHash":"FE3CE11E9F7670D3ECD606E455B7C222","accountNumber":"XXXX0015","accountType":"Mastercard","messages":[{"code":"1","description":"This transaction has been approved."}]},"refId":"123456","messages":{"resultCode":"Ok","message":[{"code":"I00001","text":"Successful."}]}}';
            res.setBody(body);
        }

        //check endpoint recived from ECheck payment method and set dummy body     
        else if(request.getEndpoint()=='https://apitest.authorize.net/xml/v1/request.api?content-type=application/json&Content-length=334'){
            string body = ' {"transactionResponse":{"responseCode":"1","authCode":"HH5414","avsResultCode":"Y","cvvResultCode":"S","cavvResultCode":"6","transId":"97993977","refTransID":"","transHash":"FE3CE11E9F7670D3ECD606E455B7C222","accountNumber":"XXXX0015","accountType":"Mastercard","messages":[{"code":"1","description":"This transaction has been approved."}]},"refId":"123456","messages":{"resultCode":"Ok","message":[{"code":"I00001","text":"Successful."}]}}';
             res.setBody(body);
         }
        else{
            res.setBody(null);
        }
        return res;
    }   
}