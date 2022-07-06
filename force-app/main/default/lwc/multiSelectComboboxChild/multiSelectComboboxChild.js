import { LightningElement,api,track } from 'lwc';
import getData from'@salesforce/apex/MultiSelectComboboxController.getData';
    export default class MultiSelectComboboxChild extends LightningElement {
         
        @api options;
        @api label;
        @api multiSelect = false;
        @api sobj;
        selectedValue;
        disabled = false;
        @track selectedList = [];
        @track uiData = [];
        @track tempData = [];
        searchString;
        showOptionsList = false;
        showDropdown = false;
        showSpinner = true;
        noResultfound;
      
        connectedCallback() {
            let options = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
            if(options != null){
                for(let i = 0; i < options.length; i++) {
                    options[i].selected = false;
                }
                this.uiData = options;
                this.tempData = options;
            }
            else{
                this.disabled = true;
            }
            this.showSpinner = false;
            
        }

        // show records list on UI to select or unselect 
        showOptions(){
            if(this.options) {
                this.showDropdown = true;
                this.showOptionsList = true;
                this.searchString='';
                this.noResultfound ='';
            }
        }
        
        // maintain select and unselect records 
        onSelect(event) {
            let selectedOption = event.currentTarget.dataset.id;
            if(selectedOption) {
                let options = JSON.parse(JSON.stringify(this.uiData));
                for(let i = 0; i < options.length; i++) {
                    if(options[i].id === selectedOption) {
                        if(this.multiSelect){
                            if(this.selectedList.filter(e => e.id === options[i].id).length>0){
                                const index = this.selectedList.findIndex(item => item.id === options[i].id);
                                this.selectedList.splice(index, 1);
                            } 
                            else{
                                this.selectedList.push({id : options[i].id,name : options[i].name});
                            }
                            options[i].selected = options[i].selected ? false : true;  
                            let index = this.tempData.findIndex(item => item.id === options[i].id);
                            this.tempData[index].selected = this.tempData[index].selected ? false : true;
                        }
                        else {
                            this.selectedValue ={id : options[i].id, name : options[i].name} ;
                            this.searchString = options[i].name;
                        }
                    }
                }
                this.uiData = options;
                if(this.multiSelect){
                    this.searchString = this.selectedList.length + ' Option(s) Selected';
                    let evnt = new CustomEvent('selectedoption', {detail:this.selectedList});
                    this.dispatchEvent(evnt);
                }
                if(!this.multiSelect){
                    let evnt = new CustomEvent('selectedoption', {detail:this.selectedValue});
                    this.dispatchEvent(evnt);
                }
     
                 if(this.multiSelect){
                     event.preventDefault();
                 }
                 else{
                     this.showDropdown = false;
                 }
             }
        }
      
       
        // Search given keyword by calling Apex method  
        filterOptions(event) {
            this.showSpinner = true;
            this.searchString = event.target.value;
            if(this.searchString.length>3) {
                getData({Sobj : this.sobj, searchkey : this.searchString})
                    .then(result => {
                        if(result.length!=0){
                            this.uiData =[];
                            for(var i=0;i<result.length;i++){
                                if(this.selectedList.filter(e => e.id === result[i].Id).length>0){
                                    this.uiData.push({name : result[i].Name, id : result[i].Id, selected : true });
                                } 
                                else{ 
                                this.uiData.push({name : result[i].Name, id : result[i].Id, selected : false });
                                }
                            }
                        }
                        else{
                            this.uiData =[];
                            this.noResultfound = "No results found for '" + this.searchString + "'";
                        }
                        this.showSpinner = false;
                });
            }
            else{
                this.uiData = this.tempData;
                this.showSpinner = false;
                this.noResultfound = '';
            }
        }

        // Remove pills from ui and unselect from all records 
        removeOption(event) {
            let value = event.currentTarget.name;
            let options = JSON.parse(JSON.stringify(this.uiData));
            for(let i = 0; i < options.length; i++) {
                if(options[i].id === value) {
                    options[i].selected = false;
                    let index = this.selectedList.findIndex(item => item.id === options[i].id);
                    this.selectedList.splice(index, 1);
                    let ind = this.tempData.findIndex(item => item.id === options[i].id);
                    this.tempData[ind].selected = false;
                }
            }
            this.uiData = options;
            if(this.multiSelect){
                this.searchString =  this.selectedList.length + ' Option(s) Selected';
                let evnt = new CustomEvent('selectedoption', {detail : this.selectedList});
                this.dispatchEvent(evnt);
            }
        }

        // hide list of records from ui on blur
        handleMouseOut(){
            if(this.multiSelect){
                this.searchString = this.selectedList.length + ' Option(s) Selected';
                this.uiData = this.tempData;
            }
             this.showDropdown = false;
        }
     
    }