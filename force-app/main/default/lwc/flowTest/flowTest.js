import { LightningElement,track } from 'lwc';
import getCases from '@salesforce/apex/getCaseRecords.getCases';
export default class FlowTest extends LightningElement {
    @track casesList = []; 
    @track columns = [
        { label: 'Case Number', fieldName: 'CaseNumber' },
        { label: 'Id', fieldName: 'Id', type: 'text'},
       
    ];
connectedCallback(){
    getCases()
    .then(result =>{
        if(result != null){
            this.casesList = result;
        }
    })
}

}