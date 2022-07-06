import { LightningElement, wire, track, api } from 'lwc';
import getcontact from '@salesforce/apex/classtest.getcontact';
export default class TestChield extends LightningElement {

    @api message;

    conList;
    error; 
    // @wire(getcontact)
    // wiredContacts({ error, data }) {
    //     if (data) {
    //         this.conList = data;
    //         this.error = undefined;
    //     } else if (error) {
    //         this.error = error;
    //         this.conList = undefined;
    //     }
    // }

    handleClick(){
        getcontact()
            .then(result => {
                this.conList = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    @api handleValueChange(){
        this.conList = null;
    }
}