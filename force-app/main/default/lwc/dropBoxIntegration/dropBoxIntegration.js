import { LightningElement,track } from 'lwc';
import isUserExist from '@salesforce/apex/DropBoxIntegration.isUserExist';
import isExpired from '@salesforce/apex/DropBoxIntegration.isExpired';
import regenerateAccessToken from '@salesforce/apex/DropBoxIntegration.regenerateAccessToken';
import authCodeRequest from '@salesforce/apex/DropBoxIntegration.authCodeRequest';
import getTokens from '@salesforce/apex/DropBoxIntegration.getTokens';
import getData from '@salesforce/apex/DropBoxIntegration.getData';
import createNewFolder from '@salesforce/apex/DropBoxIntegration.createNewFolder';
import deleteItem from '@salesforce/apex/DropBoxIntegration.deleteItem';
import downloadData from '@salesforce/apex/DropBoxIntegration.downloadData';
import uploadFile from '@salesforce/apex/DropBoxIntegration.uploadFile';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DropBoxIntegration extends LightningElement {
   
    @track myBreadcrumbs = [{name: 'Root', id: '',path:'' }, ];
    @track data = [];
    currentFolderPath = '';
    deleteFilePath;
    showfolderModel = false;
    showDeleteModel = false;
    showUpload = false;
    showSpinner = true;
    fileData;
    connectedCallback(){
        //check user is new oe existing 
        isUserExist()
        .then(result =>{
            let geturl = new URL(window.location.href);
            let authCode = geturl.searchParams.get("code");
            if(result ||authCode != null){
                if(result){
                   // check access token expired or not
                   isExpired()
                   .then(result=>{
                    if(result){
                        regenerateAccessToken();
                        window.open('https://scsinfra-developer-edition.ap27.force.com/integration/s/dropbox','_top');
                    }
                    else{
                        // sho data on ui
                        this.fetchData('');
                    }
                   });
                   
                }
                else{
                    // get tokens from dropBox
                    getTokens({authCode : authCode})
                    .then(result =>{
                        window.open('https://scsinfra-developer-edition.ap27.force.com/integration/s/dropbox','_top');   
                    }); 
                }

            }
            else{
                // request auth code 
                authCodeRequest()
                .then(result =>{
                    window.open(result,'_top');
                });
            }
        });
    }


    // get data from Dropbox according to parent folder
    fetchData(parentId){
        getData({parent : parentId})
        .then(result=>{
             result.entries.forEach(rec => {
                 if(rec.tag == 'folder'){
                     rec.isFolder = true;
                 }
                 else{
                     rec.isFolder = false;
                 }
             });
             this.data = result.entries;
             this.showSpinner = false;
        });
    }

    // show folder data when folder name clicked 
    openFolder(event){
        this.showSpinner = true;
        let folderId = event.target.dataset.id;
        let folderName = event.target.dataset.name;
        this.currentFolderPath = event.target.dataset.path;
        this.fetchData(folderId);
        this.myBreadcrumbs.push({name: folderName, id: folderId, path : this.currentFolderPath })
    }
      //handel navigation by bread crumb
      breadCrumbNavigation(event) {
        this.showSpinner = true;
        let folderId = event.target.dataset.id;
        this.currentFolderPath = event.target.dataset.path;
        this.fetchData(folderId);
        const index = this.myBreadcrumbs.findIndex(item => item.id === folderId);
        this.myBreadcrumbs.length = index+1;
    }

    // show delete file model 
    showDelete(event){
        this.showDeleteModel = true;
        this.deleteFilePath = event.target.dataset.path;
    }

    // show model to get name of new folder 
    showCreateFolderModel(){
        this.showfolderModel = true;
    }

    // open model to upload file 
    OpenUploadModel(){
        this.showUpload = true;
    }

    // call apex metjhod by passing file path and recive download link 
    downloadFile(event){
        let filePath =  event.target.dataset.path;
        downloadData({path : filePath})
        .then(result=>{
            window.open(result,'_blank');
        });
    }

    // method to close all models 
    closeModel(){
        this.showfolderModel = false;
        this.showDeleteModel = false;
        this.showUpload = false;
    }
    
    // functionality to create folder and add folder on UI
    createFolder(){
        this.showSpinner = true;
        let folderName = this.template.querySelector(".folderName").value;
        createNewFolder({name : folderName, path : this.currentFolderPath})
        .then(result=>{
            result.isFolder = true;
            this.data.push(result);
            this.showfolderModel = false;
            this.showSpinner = false;
        });
    }

   
      

    // Functionality to upload File and show file on UI
    fileUpload(event){
        let file = event.detail.files[0];
        const reader = new FileReader();
        reader.onload = () => {
           let base64Data = reader.result.split(',')[1];
           this.fileData ={
            'fileName' : file.name,
            'base64': base64Data
           }   
        }   
        reader.readAsDataURL(file);
    }

    uploadThis(){
        this.showSpinner = true;
        let folderPath = this.myBreadcrumbs[this.myBreadcrumbs.length - 1].path;
        uploadFile({path : folderPath, name : this.fileData.fileName, file : this.fileData.base64})
        .then(result=>{
            if(result === null){
                alert('Somthing is wrong');
                this.showSpinner = false;
            }
            else{                            
                this.showUpload = false;
                this.showSpinner = false;
                alert('file uploded');  
                this.fetchData(folderPath);   
           }   
    });
    }

    // functionality to delete file and hide from ui
    deleteFile(){
        this.showSpinner = true;
        deleteItem({path : this.deleteFilePath})
        .then(result=>{
            this.showDeleteModel = false;
            
            const index = this.data.findIndex(item => item.path_display === this.deleteFilePath);
            this.data.splice(index,1);
            
            alert('item Deleted');
            this.showSpinner = false;
        });
    }
}