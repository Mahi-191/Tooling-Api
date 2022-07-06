import { LightningElement, api, track} from 'lwc';

export default class LazyLoadingData extends LightningElement {
    @api record;
    @api fieldapi;
    @track data='';
    renderedCallback() {
        this.data = this.record[this.fieldapi];
          
    }
}