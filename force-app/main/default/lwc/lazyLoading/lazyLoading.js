import { LightningElement, track, wire, api } from 'lwc';
import showFieldDynamically from '@salesforce/apex/LazyLoadingController.showFieldDynamically'
export default class LazyLoading extends LightningElement {
    @api fieldList = ['LastName','AccountId','Id','Email'];
    @api objName = 'Contact';
    @track data=[];
    @track columnsList=[];
    @track checkRoot = false;
    lastId = '0';
    count = 20;
    totalRecords = 0;
    showSpinner = true;
    sortBy = 'NA';
    sortDirection = 'asc';
    arrowUp = false;
    arrowDWN = false;
    connectedCallback(){
        //get data when component load
        this.getData();
    }

    // get  data from apex 
    getData(){
        let query = this.fieldList.toString();
        showFieldDynamically({objName : this.objName, query : query, lastId : this.lastId})
        .then(result =>{             
            let headerList = result.fieldsMap;
            //this.data = result.recordList;
            let dataList = result.recordList;              
            this.totalRecords = result.totalRecords;
            this.lastId = result.lastId;              
            this.columnsList = [];
            //store field Api Name and label in a list 
            for(let key in headerList){                    
                this.columnsList.push({label: headerList[key], fieldName: key, isSorted: false});       
            }  
            for(const element of dataList) {
                element.isChecked = false;
                this.data.push(element); 
           } 
            this.rootBox();
            if(this.sortBy != 'NA'){
                this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
                this.sortNow(this.sortBy);
            }
           
            this.showSpinner = false;
        });
    }

    // run every time when scroll bar scrolled 
    handelScroll(event){
        let scrollTop = event.target.scrollTop;
        let scrollHeight = event.target.scrollHeight;
        let clientHeight = event.target.clientHeight;     
        if((scrollHeight - clientHeight) <= (scrollTop + 1)){
            this.showSpinner = true;    
            let count = parseInt(this.count);
            let totalRecords = parseInt(this.totalRecords); 
            //when scroll bar reach at end run get data method 
            if(totalRecords >= count ){
                this.count = count+20;   
                this.getData();                
            }    
            else{
                this.showSpinner = false;
                alert('No more Records Available');
            }           
        }
    }   
    sort(event){
        let sortfield = event.currentTarget.dataset.id;
  
        this.sortNow(sortfield);
    }

    sortNow(sortfield){
       
        for(let i = 0; i< this.columnsList.length; i++){
            if( this.columnsList[i].fieldName == sortfield){
                this.columnsList[i].isSorted = true;
            }
            else{
                this.columnsList[i].isSorted = false;
            }
        }
        // var divblock = this.template.querySelector('[data-id=sortfield]');
        this.showSpinner = true;
        if(this.sortBy === sortfield){
            this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        }else{
            this.sortDirection = 'asc';
        }
        if(this.sortDirection === 'asc'){
            this.arrowUp = true;
            this.arrowDWN = false;  
        }
        else{
            this.arrowUp = false;
            this.arrowDWN = true;
        }
        this.sortBy = sortfield;
        this.sortData(this.sortBy, this.sortDirection);
    }   

    sortData(fieldname, direction) {       
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x).toLowerCase() : '';
            y = keyValue(y) ? keyValue(y).toLowerCase() : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
        this.showSpinner = false;
    }


    rootBox(){
        for(var i = 0 ; i < this.data.length ; i++){
            if(this.data[i].isChecked === false){
                this.checkRoot = false;
                break;
            }
            else{
                this.checkRoot = true;
            }
        }
    }

    childCheckBox(event){
        this.data[event.target.dataset.index].isChecked = event.target.checked;
        this.rootBox();
    }
    rootCheckBox(event){
        this.checkRoot = event.target.checked;
        for(let i = 0 ; i < this.data.length; i++){
            this.data[i].isChecked = event.target.checked;
        }
    }



}