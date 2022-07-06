public with sharing class PaymentGatewayController {
  
    //to make callout body endpoint and get response for CreditCard Payment 
    @AuraEnabled(cacheable = true)
    public static PaymentGatwayWrapper creditCardPayment (String cardNumber, String expDate, String cvv){
        String Api_Key = PaymentGateway__mdt.getInstance('Authorize').Login_Id__c;
        String Transaction_Key = PaymentGateway__mdt.getInstance('Authorize').Transaction_Id__c;       
        String endpoint = 'https://apitest.authorize.net/xml/v1/request.api';
        Integer randomRefId = Integer.valueof((Math.random() * 1000));
        String body = '{"createTransactionRequest": {"merchantAuthentication": {"name": "'+Api_Key+'","transactionKey": "'+Transaction_Key+'"},"refId": "'+ randomRefId +'","transactionRequest": {"transactionType": "authOnlyTransaction","amount": "1000","payment": {"creditCard": {"cardNumber": "'+cardNumber+'","expirationDate": "'+expDate+'","cardCode": "'+cvv+'"}}}}}';
        endPoint += '?content-type=application/json'+'&Content-length='+ String.valueOf(body.length());
        String resp = PaymentGatewayService.httpCallout(endpoint, body);
        PaymentGatwayWrapper respo = (PaymentGatwayWrapper) json.deserialize(resp.substring(1,resp.length()),PaymentGatwayWrapper.class);
        return respo;

    }    

    //to make callout body endpoint and get response for Echeck Payment 
    @AuraEnabled(cacheable = true)
    public static PaymentGatwayWrapper echeckPayment(String routingNum, String accNum, String accName){             
        String Api_Key = PaymentGateway__mdt.getInstance('Authorize').Login_Id__c;
        String Transaction_Key = PaymentGateway__mdt.getInstance('Authorize').Transaction_Id__c;      
        String endpoint = 'https://apitest.authorize.net/xml/v1/request.api';
        Integer randomRefId = Integer.valueof((Math.random() * 1000));
        String body = '{"createTransactionRequest": {"merchantAuthentication": {"name": "'+Api_Key+'","transactionKey": "'+Transaction_Key+'"},"refId": "'+ randomRefId +'","transactionRequest": {"transactionType": "authOnlyTransaction","amount": "1000","payment": {"bankAccount": {"routingNumber": "'+routingNum+'","accountNumber": "'+accNum+'","nameOnAccount": "'+accName+'"}}}}}';
        endPoint += '?content-type=application/json'+'&Content-length='+ String.valueOf(body.length());
        String resp = PaymentGatewayService.httpCallout(endpoint, body);   
        System.debug(resp);
        PaymentGatwayWrapper respo = (PaymentGatwayWrapper) json.deserialize(resp.substring(1,resp.length()),PaymentGatwayWrapper.class); 
        System.debug(respo);
        return respo;
    }    
}