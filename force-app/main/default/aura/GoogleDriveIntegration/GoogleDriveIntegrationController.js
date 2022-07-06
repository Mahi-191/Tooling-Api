({
    init : function(component, event, helper) {
         component.set("v.spinner", true);
        var action = component.get("c.getUser");
        action.setCallback(this, function(response) { 
            let state = response.getState();
            if (state === "SUCCESS") {      
                var accessData = response.getReturnValue();
                //check user is new or already created
                if(accessData == null){    
                    helper.authStepOne(component,event);
                }
                else{

                    // check tokens are available for user or not
                    if(accessData.Access_Token__c == null){
                        let url_string = window.location.href;
                        let url = new URL(url_string);
                        let authCode = url.searchParams.get("code");
                        if(authCode == null || authCode =='undefined'){
                            helper.whenAuthFail(component,event);
                        }
                        else{
                            helper.authStepTwo(component,event,authCode);
                        }
                    }
                    else{
                        var action = component.get("c.isExpired");
                        action.setCallback(this, function(response){
                            let state = response.getState();
                            if(state == "SUCCESS"){
                                let expired = response.getReturnValue();
                                //check access token expired or not
                                if(expired){
                                    helper.refreshAccessToken(component,event);
                                }
                                else{
                                    let crumbList = [{id : "root", name : "Root" }];
                                    component.set("v.myBreadcrumbs",crumbList);
                                    let passUrl = 'https://www.googleapis.com/drive/v3/files?q=\'root\'+in+parents&trashed=false';
                                    helper.getGdriveData(component, event, passUrl);
                                }
                            }
                        });
                        $A.enqueueAction(action);
                    }
                }
            }
        });
        $A.enqueueAction(action); 
    },

    //get file id and call download file helper method 
    downloadFile : function(component,event,helper){
        component.set("v.spinner", true);
        var fId = event.target.id;
        helper.downloadDriveFile(component, event, fId);
    },

    //show delete confermation model and set id of item in attribute
    showDelete : function(component,event,helper){
        component.set("v.showDeleteModel", true);
        component.set("v.delId",event.target.id);
    },

    //to get id of item from attribute to delete and call helper function to delete item
    deleteFile : function(component, event, helper){
        component.set("v.spinner", true);
        var delId = component.get("v.delId");
        helper.deleteDriveFile(component,event,delId);
        component.set("v.showDeleteModel", false);
    },

    //open model to get folder name
    creatFolder : function(component, event, helper){
        component.set("v.showfolderModel", true);
    },

    // comman method to close models
    closeModel : function(component, event, helper){
        component.set("v.showfolderModel", false);
        component.set("v.showfileModel", false);
        component.set("v.showDeleteModel", false);

    },

    // method to get name and parent id and call helper function to create folder
    create : function(component, event, helper){
        component.set("v.spinner", true);
        let nameOfFolder = component.find("folderName").get("v.value");
        let crambList = component.get("v.myBreadcrumbs");
        let parent = crambList[crambList.length - 1].id;
        helper.createNewFolder(component, event, nameOfFolder, parent);
    },

    //open model to get attachment
    OpenUploadModel :function(component, event, helper){
        component.set("v.showfileModel", true);
    },

    //get pertaculer folders data and set crumbList
    openFolder : function(component, event, helper){
        component.set("v.spinner", true);
        var selectedId = event.target.dataset.id;
        var selectedFolderName = event.target.dataset.name;
        let passUrl ='https://www.googleapis.com/drive/v3/files?q=\''+selectedId+'\'+in+parents';
        helper.getGdriveData(component, event, passUrl);
        var crumbList = component.get("v.myBreadcrumbs");
		crumbList.push({id : selectedId, name : selectedFolderName });
        component.set("v.myBreadcrumbs",crumbList);
    },

    //handle navigation by bread crumb
    breadCrumbNavigation: function(component, event, helper) {
        component.set("v.spinner", true);
        var id = event.getSource().get('v.name');
        var crumbList = component.get("v.myBreadcrumbs");
        let passUrl;
        if(id == null || id == " " || id == undefined) {
            passUrl = 'https://www.googleapis.com/drive/v3/files?q=\'root\'+in+parents&trashed=false';
            helper.getGdriveData(component, event, passUrl);
            crumbList.length = 1;
            component.set("v.myBreadcrumbs",crumbList);
        } 
        else {
            passUrl ='https://www.googleapis.com/drive/v3/files?q=\''+id+'\'+in+parents';
            helper.getGdriveData(component, event, passUrl);
            const index = crumbList.findIndex(item => item.id === id);
            crumbList.length = index+1;
            component.set("v.myBreadcrumbs",crumbList);
        }
    },

    // get file and make file body to upload on drive 
    fileUpload : function(component, event, helper) {
        component.set("v.spinner", true);
        let fileData = event.getSource().get("v.files");
        let crambList = component.get("v.myBreadcrumbs");
        let parentId = crambList[crambList.length - 1].id;
        const FileBoundary = 'BOUNDARYBYMAHI2022MAY';
        const delimiter = "\r\n--" + FileBoundary + "\r\n";
        const close_delim = "\r\n--" + FileBoundary + "--";
        let reader = new FileReader(); 
        reader.readAsBinaryString(fileData[0]); 
        reader.onload = function(e) {
            let contentType = fileData[0].type || 'application/octet-stream'; 
            let fileName = fileData[0].name;

            let base64Data = btoa(reader.result); 
            let fileBody = delimiter +
                'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + fileName + '",' + ' "mimeType" : "' + contentType + '",' + '"parents":[{"id":"'+ parentId +'"}]}'
                + delimiter +
                'Content-Type: ' + contentType + '\r\n' +
                'Content-Transfer-Encoding: base64\r\n' +
                '\r\n' + base64Data + close_delim;
            helper.uploadFiletoDrive(component, event, fileBody, FileBoundary); 
        }
    }
})