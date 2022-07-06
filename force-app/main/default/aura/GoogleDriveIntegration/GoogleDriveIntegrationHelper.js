({
	// get url from apex and open in same window to autharize user
	authStepOne : function(component, event){
		let action = component.get("c.authstep1");
		action.setCallback(this, function(response) { 
			let state = response.getState();
			if (state === "SUCCESS") { 
				let url = response.getReturnValue();
				window.open(url,'_top');
			}
			else{
				console.log('Somthing went Wrong');
			}
		});
		$A.enqueueAction(action);
	},

	// function to call apex method that get access token and refresh token 
	authStepTwo : function(component,event,authCode){
		let action = component.get("c.auth_Step_2");
		action.setParams({ code : authCode});
		action.setCallback(this, function(response){
			let state = response.getState();
			if(state == "SUCCESS"){
				window.open('https://scsinfra-developer-edition.ap27.force.com/integration/s/google-drive','_top');
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

	// in case  of token expiry Re-Generate access token by Refresh token
	refreshAccessToken : function (component, event){
		var action = component.get("c.reGenerateTkoen");
		action.setCallback(this, function(response){
			var state = response.getState();
			if(state == "SUCCESS"){
				window.open('https://scsinfra-developer-edition.ap27.force.com/integration/s/google-drive','_top');
			}
		}); 
		$A.enqueueAction(action);
	},

	//fetch google drive data as a list of files wrapper
	getGdriveData :function(component, event, passUrl){
		let action = component.get("c.fetchData");
		action.setParams({url : passUrl});
		action.setCallback(this, function(response){
		let st = response.getState();
		if(st === "SUCCESS"){
			var data = response.getReturnValue();
			component.set("v.data",data);
		}
		component.set("v.spinner", false);
		});
		$A.enqueueAction(action);
	},

	//function to get download link of the file
	downloadDriveFile : function(component, event, fId){
		let action = component.get("c.download");
        action.setParams({fileId : fId});
        action.setCallback(this, function(response){
            let state = response.getState(); 
            if(state === "SUCCESS"){
                let link = response.getReturnValue();
                if(link == null){
    
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : 'Info',
						message: 'can\'t Download This File',
						duration:' 5000',
						key: 'info_alt',
						type: 'info',
						mode: 'dismissible'
					});
					toastEvent.fire();
                }
                else{
                    window.open(link,'_blank');
                }
            }
			component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

	//function to call apex method that delete file from drive and remove deleted file from UI
	deleteDriveFile : function(component, event, delId){
		let action = component.get("c.deleteFiles");
        action.setParams({fileId : delId});
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let respCode = response.getReturnValue();
				console.log('code'+respCode);
                if(respCode === '204'){
                    let datalist =  component.get("v.data");
                    const index = datalist.findIndex(item => item.id === delId);
                    datalist.splice(index,1);
                    component.set("v.data", datalist);
					
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : 'Success',
						message: 'Item Deleted',
						duration:' 4000',
						key: 'info_alt',
						type: 'success',
						mode: 'pester'
					});
					toastEvent.fire();
                }
                else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : 'Info',
						message: 'Can not Delete this File',
						duration:' 4000',
						key: 'info_alt',
						type: 'info',
						mode: 'dismissible'
					});
					toastEvent.fire();
                }
            }
            else{
                console.log('error');
            }
			component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

	// call apex method that creats folder by passing folder name and parent Id (where we want to create folder)
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
            }  
			component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

	//upload file to google drive 
	uploadFiletoDrive : function(component, event, fileBody, FileBoundary){
		let action = component.get("c.uploadFile");
		action.setParams({reqBody : fileBody, boundary : FileBoundary});
		action.setCallback(this, function(response){
			let state = response.getState();
			console.log('state is   '+ state);
			if(state === "SUCCESS"){
				let dataList = component.get("v.data");
                let file = response.getReturnValue();
                dataList.push(file);
                component.set("v.data", dataList);
				component.set("v.showfileModel", false);
				
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title : 'Success',
					message: 'File Uploaded',
					duration:' 4000',
					key: 'info_alt',
					type: 'success',
					mode: 'pester'
				});
				toastEvent.fire();
			}
			else {
				console.log('error');
			}
			component.set("v.spinner", false);
		});
		$A.enqueueAction(action);
	}
   
})