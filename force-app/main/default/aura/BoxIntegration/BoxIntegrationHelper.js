({
	//get url string from apex and redirect 
	authStepOne : function(component, event){
		let action = component.get("c.redirectAuthURI");
		action.setCallback(this, function(response) { 
			let state = response.getState();
			if (state === "SUCCESS") { 
				let url = response.getReturnValue();
				window.open(url, '_top');
			}
			else{
				alert('Somthing went Wrong');
			}
		});
		$A.enqueueAction(action);
	},

	//get token and call apex method that generate and update tokens
	authStepTwo : function(component, event, authCode){
		let action = component.get("c.getTokens");
		action.setParams({ code : authCode});
		action.setCallback(this, function(response){
			let state = response.getState();
			if(state == "SUCCESS"){
				window.open('https://scsinfra-developer-edition.ap27.force.com/integration/s/boxcom', '_top');
			}
		});
		$A.enqueueAction(action);
	},

	// if access token is expired call apex method that regenerate token
	refreshAccessToken : function (component, event){
		var action = component.get("c.reGenerateTkoen");
		action.setCallback(this, function(response){
			var state = response.getState();
			if(state == "SUCCESS"){
				window.open('https://scsinfra-developer-edition.ap27.force.com/integration/s/boxcom', '_top');
			}
		}); 
		$A.enqueueAction(action);
	},

	//delete user when auth code not available in url
	whenAuthFail: function(component, event){
		let action = component.get("c.authfail");
		action.setcallback(this, function(response){
			let state = response.getState();
			if(state =="SUCCESS"){
				this.authStepOne(component,event);
			}
			else{
				alert('somthing wrong');
			}
		});
	},

	// comman function to get data from box (root data or folder's data)
	getData :function(component, event, folderId){
		let action = component.get("c.fetchData");
		action.setParams({parent : folderId});
		action.setCallback(this, function(response){
		let st = response.getState();
		if(st === "SUCCESS"){
			var data = response.getReturnValue();
			component.set("v.data", data.item_collection.entries);
		}
		component.set("v.spinner", false);
		});
		$A.enqueueAction(action);
	},

	// function to get download link from apex and open in another window
	downloadBoxFile : function(component, event, fId){
		let action = component.get("c.downloadFiles");
        action.setParams({fileId : fId});
        action.setCallback(this, function(response){
            let state = response.getState(); 
            if(state === "SUCCESS"){
                let link = response.getReturnValue();
                if(link == null){
                    alert('can\'t Download This File');
                }
                else{
                    window.open(link, '_blank');
                }
            }
			component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

	//pass item id and type(folder/file) to delete 
	deleteBoxFile : function(component, event, delId){
		let type = component.get("v.delitemtype")
		let action = component.get("c.deleteFiles");
        action.setParams({itemType : type, itemId : delId});
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let respCode = response.getReturnValue();
                if(respCode === '204'){
                    let datalist =  component.get("v.data");
                    const index = datalist.findIndex(item => item.id === delId);
                    datalist.splice(index,1);
                    component.set("v.data", datalist);

					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : 'Success',
						message: 'Item Deleted', duration:' 3000',
						key: 'info_alt', type: 'success', mode: 'pester'
					});
					toastEvent.fire();
               }
			   else if(respCode === '400'){
				   var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : 'Info', message: 'can\'t Delete Because folder is not empty',
						duration:' 4000', key: 'info_alt',
						type: 'info', mode: 'dismissible'
					});
					toastEvent.fire();
			   }
                else{
                    var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : 'Info', message: 'ERROR',duration:' 4000',
						key: 'info_alt', type: 'info', mode: 'dismissible'
					});
					toastEvent.fire();
                }
            }
            else{
                alert('error');
            }
			component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

	// pass name of new folder and parent id to apex for folder creation
	createNewFolder : function(component, event, nameOfFolder, parent){
		let action = component.get("c.createFolder");
        action.setParams({folderName : nameOfFolder, parentId : parent});
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let dataList = component.get("v.data");
                let newfolder = response.getReturnValue();
                dataList.push(newfolder);
                component.set("v.data", dataList);
                component.set("v.showfolderModel", false);
            }
            else{
               	alert('sonthing went wrong');
				component.set("v.showfolderModel", false);
            }  
			component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

	//upload file on box.com
	 uploadFileHelper : function(component, event, fileContents, parent, fileName) {
		var action = component.get("c.uploadFile");
			action.setParams ({
                fileContents : fileContents,
                parentFolderId : parent,
				fileName : fileName
			});
			action.setCallback(this, function(response) {
				var state = response.getState();
				if(state == "SUCCESS") {
					var result = response.getReturnValue();
					if(result !== null) {
						//set data on ui
                        let dataList = component.get("v.data");
                		dataList.push(result.entries[0]);
            			component.set("v.data", dataList);
						component.set("v.showfileModel", false);
						var toastEvent = $A.get("e.force:showToast");
						//toast success message when file upload process ends
						toastEvent.setParams({
							title : 'Success', message: 'File Uploaded',
							duration:' 4000', key: 'info_alt',
							type: 'success', mode: 'pester'
						});
						toastEvent.fire();

					}
					else {
					 	alert("can't upload file");
					}
				} 
				else {
                    alert("system generated upload error");
                }
				component.set("v.spinner", false);	
			});
		$A.enqueueAction(action);			
	}
   
})