import { LightningElement } from 'lwc';

export default class TestLwcParent extends LightningElement {
    handleClick() {
        this.template.querySelector("c-test-chield").handleValueChange();
      }
}