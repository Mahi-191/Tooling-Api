import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLocalData from'@salesforce/apex/SalesforceIntegrationController.getLocalData';
import localUpload from'@salesforce/apex/SalesforceIntegrationController.localUpload';
import uploadDataOnApiOrg from'@salesforce/apex/SalesforceIntegrationController.uploadDataOnApiOrg';

export default class SalesforceIntegration extends LightningElement {
    @track localDataList=[];
    showUpload = false;
    fileData = null;
    isNotContact = false;
    showSpinner = true;
    noRecords = false;
    connectedCallback(){
        // get files list from Apex
        getLocalData()
        .then(result =>{
            if(result != null ){
                if(result.length > 0){
                    this.localDataList = result;
                }
                else{
                    this.noRecords = true;
                }
            }
            else{
             this.isNotContact = true;
            }
            this.showSpinner = false;
        });
    }

    // open model to upload file 
    OpenUploadModel(){
        this.fileData = null;
        this.showUpload = true;
    }
     // method to close all models 
     closeModel(){
        this.showUpload = false;
        this.isNotContact = false;
    }

    // read file when user select file 
    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
            }
        }
        reader.readAsDataURL(file)
    }
    
    // upload file on current contact record and another org's contact
    uploadFile(){
        if(this.fileData != null){
            this.showSpinner = true;
            //when logged in user in a contact upload file to community org contact
            if(!this.isNotContact){
                localUpload({ base64 : this.fileData.base64, filename : this.fileData.filename })
                .then(result=>{
                    this.localDataList.push(result);
                    this.noRecords = false;
                    let title = 'Successfully Uploaded '+this.fileData.filename+' on this Org';
                    let v = 'success';
                    this.toast(title,v);
                    this.showUpload = false;
                    this.showSpinner = false;
                });
            }
            //Upload file to 
            uploadDataOnApiOrg({ base64 : this.fileData.base64, filename : this.fileData.filename })
            .then(result=>{
                this.showSpinner = true;
                if(result.includes(this.fileData.filename)){
                
                    let title = 'Successfully Uploaded '+this.fileData.filename+' on Api Org';
                    let v = 'success';
                    this.toast(title, v);
                    this.showUpload = false;
                }
                else{
                    let title = 'Failed to upload '+this.fileData.filename+' on Api org';
                    let v = 'error';
                    this.toast(title,v);
                }
                this.showSpinner = false;
            });
        }
        else{
            let title = 'Please Select a File First';
            let v = 'error';
            this.toast(title,v);
        }
    }

    //Tost event to show messages 
    toast(title,v){
        const toastEvent = new ShowToastEvent({
            title, 
            variant : v
        })
        this.dispatchEvent(toastEvent)
    }

}