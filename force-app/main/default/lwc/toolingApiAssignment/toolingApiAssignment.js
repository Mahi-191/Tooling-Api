import { LightningElement, track } from 'lwc';
import getAllMetadata from'@salesforce/apex/ToolingApiIntegration.getAllMatadata';
import getDataList from'@salesforce/apex/ToolingApiIntegration.getDataList';

export default class ToolingApiAssignment extends LightningElement {
    @track metaDataTypes =[];
    @track metadata = [];
    connectedCallback(){
        getAllMetadata()
        .then(result =>{
            if(result != null){
               if(result.sobjects.length != 0){
                    for(var i=0;i<result.sobjects.length;i++){
                        this.metaDataTypes.push({label : result.sobjects[i].name, name : result.sobjects[i].name, selected : false });
                    }
               }
            }
            else{
                alert('Somthing went wrong');
            }
        });
    }
    onSelect(event){
        this.metadata = [];
        let seletedName = event.currentTarget.dataset.name;
        this.metaDataTypes.forEach(rec => {
            if(rec.name == seletedName){
                rec.selected = true;
            }
            else{
                rec.selected = false;
            }
        });
         
        console.log(seletedName);
        getDataList({name : seletedName})
        .then(result =>{
            if(result != null){
                if(result.records.length != 0){
                     for(var i=0;i<result.records.length;i++){
                         this.metadata.push({label : result.records[i].Name, id : result.records[i].Id, selected : false });
                     }
                }
             }
             else{
                 alert('Somthing went wrong');
             }
            console.log(result);
        })

    }

}