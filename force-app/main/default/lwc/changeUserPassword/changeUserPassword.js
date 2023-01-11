import { LightningElement } from 'lwc';
import Name from '@salesforce/user/Id';
import changePassword from '@salesforce/apex/ChangeUserPassword.changePassword';
export default class ChangeUserPassword extends LightningElement {
    userName = Name;
    passwordData = {
        oldPassword : '',
        newPassword : '',
        cnfPassword : ''
    }
    handeChange(event){
        let passwordtype = event.target.name;
        if(passwordtype == 'old'){
            this.passwordData.oldPassword = event.target.value;
        }
        if(passwordtype == 'new'){
            this.passwordData.newPassword = event.target.value;
        }
        if(passwordtype == 'cnf'){
            this.passwordData.cnfPassword = event.target.value;
        }
        console.log('enterd data is ',JSON.stringify(this.passwordData));
    }
    changePassword(){
        console.log('enterd data is ',JSON.stringify(this.passwordData));
        changePassword({jsonData:JSON.stringify(this.passwordData)})
        .then(result =>{
            console.log(result);
        })
    }
}