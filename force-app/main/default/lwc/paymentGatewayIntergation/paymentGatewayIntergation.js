import { LightningElement } from 'lwc';
import authImg from '@salesforce/resourceUrl/authImage';
import creditcardPayment from '@salesforce/apex/PaymentGatewayController.creditCardPayment';
import echeckPayment from '@salesforce/apex/PaymentGatewayController.echeckPayment';
export default class PaymentGatewayIntergation extends LightningElement {
    imageSrc = authImg;
    creditCard = true;
    eCheck = false;
    msgModal = false;
    error = false;
    Success = false;
    msg;
    transId;
    header;
    showSpinner = false;
    // when user click pay by Echeck
    ShowECheck(){
        this.creditCard = false;
        this.eCheck = true;
    }

    //when user click pay by Credit Card
    ShowCard(){
        this.creditCard = true;
        this.eCheck = false;
    }

    //create a list of month options for combobox
    get months() {
        return [
            { label: 'Jan', value: '01' },
            { label: 'Feb', value: '02' },
            { label: 'Mar', value: '03' },
            { label: 'Apr', value: '04' },
            { label: 'May', value: '05' },
            { label: 'June', value: '06' },
            { label: 'Jul', value: '07' },
            { label: 'Aug', value: '08' },
            { label: 'Sep', value: '09' },
            { label: 'Oct', value: '10' },
            { label: 'Nov', value: '11' },
            { label: 'Dec', value: '12' }  
        ];
    }

    //create list of years for combobox
    get years(){
        return [
            { label: '2022', value: '2022' },
            { label: '2023', value: '2023' },
            { label: '2024', value: '2024' },
            { label: '2025', value: '2025' },
            { label: '2026', value: '2026' },
            { label: '2027', value: '2027' },
            { label: '2028', value: '2028' }
        ];
    }

    //method to process payment by ECheck
    checkECheck(){
        //get inputs enterd in form
        this. showSpinner = true;
        let accountNumber = this.template.querySelector(".accNum").value; 
        let routingNumber = this.template.querySelector(".rNum").value;
        let nameOnCheck = this.template.querySelector(".accName").value;

        // check if inputs are blank show error message
        if(routingNumber=='' || accountNumber=='' || nameOnCheck==''){
            this.msgModal = true;
            this.error = true;
            this.Success = false;
            this. showSpinner = false;
            this.msg = 'Please Fill All Fields'; 
        }
        else{
            //check recived input is number or not
            if(!(isNaN(routingNumber) || isNaN(accountNumber))){   
                //call apex method to proceed payment       
                echeckPayment({routingNum : routingNumber, accNum : accountNumber, accName : nameOnCheck})
                .then(result => {
                    //checking transactio id in recived response if not 0 the show success message 
                    if(result.transactionResponse.transId != '0'){
                        this.transId = result.transactionResponse.transId;
                        this.msgModal = true;
                        this.error = false;
                        this.Success = true;
                        this.header = 'SUCCESSFUL';
                        this. showSpinner = false;
                        this.msg =  result.transactionResponse.messages[0].description;
                    }
                    else{
                        this.msgModal = true;
                        this.header = 'FAILED';
                        this.error = true;
                        this.Success = false;  
                        this. showSpinner = false;
                        this.msg = result.transactionResponse.errors[0].errorText;
                    }
                })
                .catch(error => {
                    console.log('error '+ error);
                    this. showSpinner = false;
                });
            }
            else{
                this.msgModal = true;
                this.error = true;
                this.Success = false;
                this. showSpinner = false;
                this.msg = 'Please Check details again';
            }
           
        }     

        
    }

    //method for payment through Credit Card
    checkCard(){
        this. showSpinner = true;
        let cardNumber = this.template.querySelector(".card").value;
        let expiryMonth = this.template.querySelector(".month").value;
        let expiryYear = this.template.querySelector('.year').value;
        let cvv = this.template.querySelector('.cvv').value;
        console.log('method called');
         // check if inputs are blank show error message
        if(cardNumber=='' || cvv=='' || expiryMonth==null || expiryYear==null){
            this.msgModal = true;
            this.error = true;
            this.Success = false; 
            this. showSpinner = false;
            this.msg = 'Please Fill All Fields'; 
        }
        else{
            //check card or cvv inputs are number or not
            if(!(isNaN(cvv) || isNaN(cardNumber))){
                if(cardNumber.length>=13 && cvv.length>=3){
                    let expDate = expiryYear + '-' + expiryMonth;

                    //call apex method to proceed payment
                    creditcardPayment({cardNumber : cardNumber, expDate : expDate, cvv : cvv})
                    .then(result => {

                        if(result.transactionResponse.transId != '0'){
                            this.transId = result.transactionResponse.transId;
                            this.msgModal = true;
                            this.error = false;
                            this.Success = true;
                            this. showSpinner = false;
                            this.msg =  result.transactionResponse.messages[0].description;
                        }
                        else{
                            this.msgModal = true;
                            this.error = true;
                            this.Success = false;
                            this. showSpinner = false;
                            this.msg = result.transactionResponse.errors[0].errorText;
                        }
                    })
                    .catch(error => {
                        console.log('error '+ error);
                        this. showSpinner = false;
                    }); 
                }
                else{
                    this.msgModal = true;
                    this. showSpinner = false;
                    this.msg = 'Please Check details again';
                    this.error = true;
                   
                }
            }
            else{
                this.msgModal = true;
                this.error = true;
                this.Success = false; 
                this. showSpinner = false;
                this.msg = 'Bad Input';
            }
        }
    }
    //close transaction status model
    closeModal(){
        this. showSpinner = false;
        this.msgModal = false;
    }
}