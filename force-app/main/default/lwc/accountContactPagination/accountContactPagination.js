import { LightningElement, track } from 'lwc';
import getFields from '@salesforce/apex/AccountContactPaginationController.getFields';
import getAccountRecords from '@salesforce/apex/AccountContactPaginationController.getAccountRecords';
export default class AccountContactPagination extends LightningElement {
    showSpinner = false;
    showTable = false;
    searchValue = '';
    sortBy = 'NA';
    sortDirection = 'asc';
    arrowUp = false;
    arrowDWN = false;
    startIndex = 0;
    endIndex = 9;
    recordCount;
    totalPages;
    pageNumber = 0;
    disablePrevious = false;
    disableNext = false;
    pageSize = 10;
    allRecords = [];
    @track AllActData = [];
    @track UiActData = [];
    @track actColumnsList = [];
    @track pageSizeList = [ {label : '5', value: '5'},
                        {label : '10', value: '10'}, 
                        {label : '20', value: '20'}, 
                        {label : '50', value: '50'}];
    connectedCallback(){
        this.makeColumnsList();
        this.getActData();

    }

    //make list of columns for table of Account Records
    makeColumnsList(){
        getFields().then(result =>{
            for(let key in result){                    
                this.actColumnsList.push({label: result[key], fieldName: key, isSorted: false});       
            }  
        }).catch(error=>{
            console.log(error);
        });
    }

    //get Account Account Records 
    getActData(){
        getAccountRecords().then(result =>{
            if(result.length>0){
                this.pageNumber = 1;
                this.showTable = true;
                this.recordCount = result.length;
                this.totalPages = Math.ceil(this.recordCount / Number(this.pageSize));
                console.log('total record Count is  ', this.recordCount);
                this.AllActData = result;
                this.allRecords = result;
                for(let i = 0; i<10;i++){
                    if(this.AllActData.length>i){
                        this.UiActData.push(this.AllActData[i]);
                    }
                }
                //this.UiActData = result;
                console.log(JSON.stringify(this.UiActData));
            }
            else{
                this.showTable = false;
            }
            
        }).catch(error=>{
            console.log(error);
        });
    } 

    // handel Navigation Buttons 
    handelNavButtons(event){
       
        let button = event.target.name;
        if(button == 'next'){
            this.startIndex = this.endIndex+1;
            this.endIndex =+this.endIndex + +this.pageSize;    
            this.pageNumber = +this.pageNumber + 1;
        }
        else if(button == 'last'){
            this.endIndex = this.totalPages*this.pageSize-1;
            this.startIndex = this.endIndex-this.pageSize+1;
            this.pageNumber = this.totalPages;
        }
        else if(button == 'first'){
            this.startIndex = 0;
            this.endIndex = this.pageSize-1;
            this.pageNumber = 1;
        }
        else if(button == 'previous'){
            this.endIndex = this.startIndex-1;
            this.startIndex -= this.pageSize;
            this.pageNumber -= 1;
        }
        this.disablebuttons();
        this.showRecordsOnPage();        
    }

    goOnFirstPage(){
        this.startIndex = 0;
        this.endIndex = this.pageSize-1;
        this.pageNumber = 1;
        this.disablebuttons();
        this.showRecordsOnPage();    
    }

     // disable buttons when needed
     disablebuttons(){
        if(this.pageNumber >= this.totalPages){
            this.disableNext = true;
        }
        else{
            this.disableNext = false;
        }

        if(this.pageNumber<= 1){
            this.disablePrevious = true;
        }
        else{
            this.disablePrevious = false;
        }
    }

    showRecordsOnPage(){
        this.UiActData = [];
        for(let i = this.startIndex; i<= this.endIndex; i++){
            if(this.recordCount>i){
                this.UiActData.push(this.AllActData[i]);
            }
        }
     }
     onSizeChange(event){
        
        this.pageSize = event.detail.value;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.recordCount / Number(this.pageSize));
        let count = Number(this.pageSize);
        this.disablebuttons();
        this.startIndex = 0;
        this.endIndex = (count< this.recordCount) ? count-1 : this.recordCount-1;
        this.showRecordsOnPage();
       
    }

    //Sort Records according to selected column
    sort(event){
        let sortfield = event.currentTarget.dataset.id;
        for(let i = 0; i< this.actColumnsList.length; i++){
            if( this.actColumnsList[i].fieldName == sortfield){
                this.actColumnsList[i].isSorted = true;
            }
            else{
                this.actColumnsList[i].isSorted = false;
            }
        }
        // var divblock = this.template.querySelector('[data-id=sortfield]');
        
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
        let parseData = JSON.parse(JSON.stringify(this.UiActData));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x).toLowerCase() : '';
            y = keyValue(y) ? keyValue(y).toLowerCase() : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.UiActData = parseData;
       
    }

    //search name in table 
    searchKeyword(event){
        this.searchValue = event.target.value;
        if(this.searchValue !== ''){
            //this.UiActData = [];
            this.AllActData = [];
            for(let i = 0; i< this.allRecords.length;i++){
                 let str = this.allRecords[i].Name;
                if(str.toLowerCase().includes(this.searchValue.toLowerCase())){
                    this.AllActData.push(this.allRecords[i]);
                }
             }
        }
        else{
            this.AllActData = this.allRecords; 
        }
         this.recordCount = Object.keys(this.AllActData).length;
        this.totalPages = Math.ceil(this.recordCount / Number(this.pageSize));
        this.goOnFirstPage()

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