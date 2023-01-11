import { LightningElement, track } from 'lwc';

export default class DataTableTest extends LightningElement {
    @track data = [
        { id: 1, name: 'billy', age: 40, email: 'billy@salesforce.com', phone: '7742271512', regdate: new Date() },
        { id: 2, name: 'Kelsey', age: 35, email: 'kelsey@salesforce.com', phone: '7976134951'  },
        { id: 3, name: 'Kyle', age: 50, email: 'kyle@salesforce.com', phone: '7766554433' },
        { id: 4, name: 'Krystina', age: 37, email: 'krystina@salesforce.com', phone: '8877665544'},
        { id: 5, name: 'mahendra', age: 21, email:'mahi@gmail.com', phone:'7765422425'}
    ];
    
    @track columns = [
        { label: 'Name', fieldName: 'name' },
        { label: 'Age', fieldName: 'age', type: 'number'},
        { label: 'Email', fieldName: 'email', type: 'email' },
        { label: 'Phone', fieldName: 'phone', type: 'button', typeAttributes : {label: {fieldName:'phone'},variant : 'base'}},
        { label: 'Registration Date', fieldName: 'regdate', type: 'date', typeAttributes :{ day: 'numeric', month: 'short', year: 'numeric'}}
    ];

    onclick(event){
        console.log(JSON.stringify(event.detail.row));
        alert('inside js method');
    }
}