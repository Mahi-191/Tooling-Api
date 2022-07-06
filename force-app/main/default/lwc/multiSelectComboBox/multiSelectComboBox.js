import { LightningElement,track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getData from'@salesforce/apex/MultiSelectComboboxController.getData';

export default class MultiSelectComboBox extends NavigationMixin (LightningElement) {
    @track recordList = [];
    @track data=[];
    isMultiSelect = false;
    showComp=false;
    sobject = 'Account';
    selectedOption = null;
    selectedOptions = [];
    recordPageUrl = '';
    connectedCallback(){
        getData({Sobj : this.sobject, searchkey : null})
        .then(result => {
            for(var i=0;i<result.length;i++){
                this.recordList.push({name : result[i].Name, id : result[i].Id});
            }
            this.showComp = true;
        })
   }

   //switch bitween single select and multi select
   toggleSwitch(event){
        this.isMultiSelect = event.target.checked;
        this.selectedOptions = [];
        this.selectedOption = null;
   }  
    // Handle event from multi select combobox
    selectedListHandler(evevt){
        this.selectedOptions = evevt.detail;
    }

    // handle event from single select combobox
    selectedHandler(event){
        this.selectedOption = event.detail;
    }
    
    // to show or hide selected records list
    get isSomthingSelected(){
        if(this.selectedOption!=null || this.selectedOptions.length > 0){
            return true;
        }
        else{
            return false;
        }
    }

    // open record's detail page on click
    openDetailPage(event){
        let id = event.currentTarget.dataset.id;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                actionName: 'view',
            }
         })
        .then((url) => {
            this.recordPageUrl = url;
        });
    }
}