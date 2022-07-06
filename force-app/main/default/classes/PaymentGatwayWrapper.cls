//Wrapper class to get transaction details from server json response
public with sharing class PaymentGatwayWrapper {
   
    @AuraEnabled public messages messages;
    @AuraEnabled public transactionResponse transactionResponse;
	
    //store transaction response
    public class transactionResponse{
		@AuraEnabled public String transId;
		@AuraEnabled public list<messages> messages;
        @AuraEnabled public list<errors> errors;
	}
    //Needed when transaction failed to get error message
    public class errors{
		@AuraEnabled public String errorCode;
		@AuraEnabled public String errorText;
	}
    //needed when transaction Successful
	public class messages{
		@AuraEnabled public String code;
		@AuraEnabled public String description;
	}
}