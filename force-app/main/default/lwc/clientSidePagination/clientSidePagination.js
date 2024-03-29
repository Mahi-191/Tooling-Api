import { LightningElement, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import columnValue from '@salesforce/apex/ClientSidePagination.columnValue';
import fetchRecords from '@salesforce/apex/ClientSidePagination.fetchRecords';
import totalRecords from '@salesforce/apex/ClientSidePagination.totalRecords';
import deleteRecord from '@salesforce/apex/ClientSidePagination.deleteRecord';
export default class ClientSidePagination extends NavigationMixin (LightningElement) {
    @api selectedobject;
    @api selectedfields = [];
    @track allRecords;
    baseRecords;
    @track showrecords = [];
    @track pageSizeList = [];
    @track pageSize = '10';
    @track pageNumber = 1;
    @track columnList;
    recordCount;
    baseCount;
    startIndex;
    endIndex;
    totalPages;
    disableNext;
    disablePrevious;
    @track pageNoButtonList =[];
    sortDirection;
    sortedBy;
    @track tempSelectIds = [];
    isnoRecords;
    showSpinner = true;
    searchValue = '';
    hasName = false;
    fromNevigation = true;
    @track actions = [
        { label: 'View', name: 'view' },
        { label: 'Clone', name: 'clone' },
        { label: 'Delete', name: 'delete' }

    ];
    connectedCallback() {
        this.columns();
        this.totalRec();
        this.makeSizeList();
        this.fetchdata();
    }
    
    // make column list for data table
    columns(){
        columnValue({objName : this.selectedobject, fieldList : JSON.parse(JSON.stringify(this.selectedfields))})
        .then(result => {
            this.columnList = [];
             let tempList = result;            
            for(let field in tempList)
            {
                if(tempList[field].fieldApi == 'Name'){
                    this.hasName = true;
                }
                if(tempList[field].type == 'DATE'){
                    this.columnList.push({label: tempList[field].fieldLabel , fieldName: tempList[field].fieldApi , type: 'date', typeAttributes :{ day: 'numeric', month: 'short', year: 'numeric'}, sortable: tempList[field].sortable});   
                }
                else  if(tempList[field].type == 'DATETIME'){
                    this.columnList.push({label: tempList[field].fieldLabel , fieldName: tempList[field].fieldApi , type: 'date', typeAttributes :{ day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit'}, sortable: tempList[field].sortable});   
                }
                else{
                    this.columnList.push({label: tempList[field].fieldLabel , fieldName: tempList[field].fieldApi , type: tempList[field].type, sortable: tempList[field].sortable});           
                }
            }
            this.columnList.push(
            {   label: 'Action',
                fieldName: 'Action',
                type: 'action',
                typeAttributes: { rowActions: this.actions },
            } );
        })
        .catch(error => {
            console.log('error '+ error);
            this.error = error;
        }); 
    }

    //fetch data from org via calling apex method
    fetchdata(){
        fetchRecords({objName : this.selectedobject, fieldList : JSON.parse(JSON.stringify(this.selectedfields))})
        .then(result =>{
            this.allRecords = result;
            this.baseRecords = this.allRecords;
            this.disablePrevious = true;
            this.startIndex=0;
            this.endIndex=9;
            this.showRecordsOnPage();
        })
        .catch(error =>{
            console.log(error);
        });
    }

    //total records of selected object
    totalRec(){
        totalRecords({objName : this.selectedobject})
        .then(result =>{
            this.recordCount = result;
            this.baseCount = result
            if(this.recordCount>0){
                this.isnoRecords = false;
            }
            else{
                this.isnoRecords = true;
            }
            this.totalPages = Math.ceil(this.recordCount / Number(this.pageSize));
            this.managePageList(this.pageNumber);
            if(this.totalPages > 0){
                this.pageNoButtonList[0].style = 'changeProperty';
            }
            this.disablebuttons();
        })
        .catch(error=>{
            console.log(error);
        });
    }

    // list for page per size combobox
    makeSizeList() {
        this.pageSizeList.push({'label':'5', 'value':'5'});
        this.pageSizeList.push({'label':'10', 'value':'10'});
        this.pageSizeList.push({'label':'25', 'value':'25'});
        this.pageSizeList.push({'label':'50', 'value':'50'});
        this.pageSizeList.push({'label':'100', 'value':'100'});
    }

 
    // function runs when user change size of page 
    onSizeChange(event){
        this.showSpinner = true;
        this.pageSize = event.detail.value;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.recordCount / Number(this.pageSize));
        let count = Number(this.pageSize);
        this.disablebuttons();
        this.managePageList(this.pageNumber);
        this.startIndex = 0;
        this.endIndex = (count< this.recordCount) ? count-1 : this.recordCount-1;
        this.showRecordsOnPage();
       
    }

    // handel Navigation Buttons 
    handelNavButtons(event){
        this.showSpinner = true;
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
        this.managePageList(this.pageNumber);
        this.showRecordsOnPage();        
    }

    goOnFirstPage(){
        this.startIndex = 0;
        this.endIndex = this.pageSize-1;
        this.pageNumber = 1;
        this.disablebuttons();
        this.managePageList(this.pageNumber);
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

    // handel buttons list (1,2,3,4,5) according to page number and number of records 
    handelpageNoButton(event){
        this.showSpinner = true;
        let btn = event.target.dataset.key;
        if(btn <= this.totalPages){
            this.startIndex = this.pageSize*(btn-1);
            this.endIndex = +this.startIndex + +this.pageSize -1;
            this.pageNumber = btn;
            this.disablebuttons();
            this.managePageList(btn);
            this.showRecordsOnPage();
        }
        else{
            this.showSpinner = false;
        }
       
    }

    //show records in table using start index and end index 
    showRecordsOnPage(){
        this.showrecords = [];
        this.fromNevigation = true;
        // this.selectedIDs = this.tempSelectIds;
        for(let i = this.startIndex; i<= this.endIndex; i++){
            if(this.recordCount>i){
                this.showrecords.push(this.allRecords[i]);
            }
        }
        this.showSpinner = false;
        // this.selectedIDs = this.tempSelectIds;
        for(let i=0; i<this.pageNoButtonList.length;i++){
            if(this.pageNoButtonList[i].value == this.pageNumber){
                this.pageNoButtonList[i].style = 'changeProperty';
            }
        } 
        this.template.querySelector("lightning-datatable").selectedRows = this.tempSelectIds;   
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch ( actionName ) {
            case 'view':
                        this[NavigationMixin.GenerateUrl]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: row.Id,
                                actionName: 'view',
                            }
                        })
                        .then((url) => {
                        window.open(url,'_blank');
                        });
                        break;
            case 'clone':
                        
                        console.log(' clone ',row.Id);
                        break;
            case 'delete':
                        deleteRecord({recId : row.Id})
                        .then(result=>{
                            if(result == true){
                                let index = this.allRecords.findIndex(item => item.Id === row.Id);
                                this.allRecords.splice(index, 1);

                                let title = 'Record Deleted with Id ' + row.Id;
                                let v = 'SUCCESS';
                                this.toast(title,v);
                                this.showRecordsOnPage();
                            }
                        })
                        break;
            default:
        }
    }

    // manage buttons of pageNumber
    managePageList(btn){
        var totalPage = this.totalPages;
        var currentPageNo = this.pageNumber;
        this.pageNoButtonList =[];
        if(totalPage<=5){
            for(let i=1; i<=this.totalPages;i++){
                this.pageNoButtonList.push({value:i,style:''});
            }
        }
        else{
            if(!(btn==(totalPage-1))){                
                if(currentPageNo<=(totalPage-2) && btn!=totalPage){               
                    if(btn<=3){                
                        this.pageNoButtonList.push({value:1,style:''},{value:2,style:''},{value:3,style:''},{value:4,style:''},{value:5,style:''});
                    }  
                    else if(btn>=3){                                
                        this.pageNoButtonList.push({value:btn-2,style:''},{value:btn-1,style:''},{value:btn,style:''},{value:+btn+1,style:''},{value:+btn+2,style:''});                                                         
                    }                
                }
                else{
                    this.pageNoButtonList.push({value:btn-4,style:''},{value:btn-3,style:''},{value:btn-2,style:''},{value:btn-1,style:''},{value:btn,style:''}); 
                }
            }
            else{
                this.pageNoButtonList.push({value:btn-3,style:''},{value:btn-2,style:''},{value:btn-1,style:''},{value:btn,style:''},{value:+btn+1,style:''});                        
            } 
        }          
    }

    // maintain checkbox state 
     checkboxState(event){
        this.showSpinner = true;
        let selectedData = event.detail.selectedRows;
        let AllSelectedlst = new Set(this.tempSelectIds);
        let selected = new Set();
        let notSelected = new Set();
        let recordsOnPage = this.showrecords;
        for(var i=0;i<selectedData.length;i++){
            selected.add(selectedData[i].Id);
            AllSelectedlst.add(selectedData[i].Id);
        }
        for (let rec of Object.values(recordsOnPage)) {
            if(!selected.has(rec.Id)){ 
                notSelected.add(rec.Id);
            }
        }
        for(let i  of notSelected){
            if(AllSelectedlst.has(i)){
                AllSelectedlst.delete(i);
            }
        }
        
        this.tempSelectIds = Array.from(AllSelectedlst);
        this.showSpinner = false;   
    }

    //method to get short direction and Filed name  
    onHandleSort(event){
        this.showSpinner = true;
        
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }   

    // method to short data according to field and direction
    sortData(fieldname, direction) { 
        let parseData = JSON.parse(JSON.stringify(this.allRecords));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x).toLowerCase() : '';
            y = keyValue(y) ? keyValue(y).toLowerCase() : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.allRecords = parseData;
        this.goOnFirstPage();
        this.showSpinner = false;
    }    

    //search name in data table 
    searchKeyword(event){
        this.searchValue = event.target.value;
        if(this.searchValue !== ''){

            this.allRecords = [];
            for(let i = 0; i< this.baseCount;i++){
                 let str = this.baseRecords[i].Name;
                if(str.toLowerCase().includes(this.searchValue.toLowerCase())){
                    this.allRecords.push(this.baseRecords[i]);
                }
             }
        }
        else{
            this.allRecords = this.baseRecords; 
        }
        this.recordCount = Object.keys(this.allRecords).length;
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