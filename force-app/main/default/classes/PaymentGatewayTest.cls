@isTest
public with sharing class PaymentGatewayTest {
    
    //test CraditCard payment response
    @isTest static void checkCraditCardTest(){
        Test.setMock(HttpCalloutMock.class, new PaymentGatewayMock());
        PaymentGatwayWrapper respo = PaymentGatewayController.creditCardPayment('12345678901234', '2023-02', '311');
        System.assertEquals('77422715',respo.transactionResponse.transId);
    }

    //test ECheck payment response
    @isTest static void checkEcheckTest(){
        Test.setMock(HttpCalloutMock.class, new PaymentGatewayMock());
        PaymentGatwayWrapper respo = PaymentGatewayController.echeckPayment('0987654321', '12345678901', 'Demo');
        System.assertEquals('97993977',respo.transactionResponse.transId);
    }
}