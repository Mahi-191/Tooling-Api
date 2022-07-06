({
    init : function(component, event, helper) {
        component.set("v.spinner", true);
        var action = component.get("c.getUser");
        action.setCallback(this, function(response) { 
            let state = response.getState();
            if (state === "SUCCESS") {      
                var accessData = response.getReturnValue();
                //checks user is new or not
                if(accessData == null){
                    helper.authStepOne(component,event);
                }
                else{
                    //check have access token or not
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
                                //check access token is expired or not
                                if(expired){
                                    helper.refreshAccessToken(component,event);
                                }
                                else{
                                    //show data
                                    let crumbList = [{id : "0", name : "Root" }];
                                    component.set("v.myBreadcrumbs",crumbList);
                                    let folderId = '0';
                                    helper.getData(component, event, folderId);
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
    
    //get item id and pass to helper class to get download link
    downloadFile : function(component,event,helper){
        component.set("v.spinner", true);
        var fId = event.target.id;
        helper.downloadBoxFile(component, event, fId);
    },

    //show delete confermation model and set id of item in attribute
    showDelete : function(component,event,helper){
        component.set("v.showDeleteModel", true);
        component.set("v.delId",event.target.dataset.id);
        component.set("v.delitemtype",event.target.dataset.type);
    },

    //to get id of item from attribute to delete and call helper function to delete item
    deleteFile : function(component, event, helper){
        component.set("v.spinner", true);
        var delId = component.get("v.delId");
        helper.deleteBoxFile(component,event,delId);
        component.set("v.showDeleteModel", false);
    },

    //open model to get folder name
    creatFolder : function(component, event, helper){
        component.set("v.showfolderModel", true);
    },

    // comnan method to close models
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
        var folderId = event.target.dataset.id;
        var folderName = event.target.dataset.name;
        helper.getData(component, event, folderId);
        var crumbList = component.get("v.myBreadcrumbs");
		crumbList.push({id : folderId, name : folderName });
        component.set("v.myBreadcrumbs",crumbList);
    },

    //handel navigation by bread crumb
    breadCrumbNavigation: function(component, event, helper) {
        component.set("v.spinner", true);
        var folderId = event.getSource().get('v.name');
        var crumbList = component.get("v.myBreadcrumbs");
            helper.getData(component, event, folderId);
            const index = crumbList.findIndex(item => item.id === folderId);
            crumbList.length = index+1;
            component.set("v.myBreadcrumbs",crumbList);
    },

    //take file and send data, file name, parent id  to helper 
    fileUpload : function(component, event, helper){
        component.set("v.spinner", true);
        let fileData = event.getSource().get("v.files");
        let fileName = fileData[0].name;
        let crambList = component.get("v.myBreadcrumbs");
        let parent = crambList[crambList.length - 1].id;
        let objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            let fileContents = objFileReader.result;
            let base64 = 'base64,';
            let dataStart = fileContents.indexOf(base64) + base64.length;;
            fileContents = fileContents.substring(dataStart);
            helper.uploadFileHelper(component, event, fileContents, parent, fileName);
        });
        objFileReader.readAsDataURL(fileData[0]);
    }  
})