@isTest
private class paginationControllerTestClass{

    PaginationController pc = new PaginationController();
    @isTest static void fetchobjectTest(){
        PaginationController pc = new PaginationController();
        pc.fetchObjects();
        System.assert(pc.sObjectList.size()>20,'After running fetchObject function sObjectList must have sobjects');       
    }
    @isTest static void fetchFieldTest(){
        PaginationController pc = new PaginationController();
   		pc.sObj = 'Account';
        pc.fetchFields();   
        System.assertEquals(true,pc.show,'after selecting account show should be true to display fieldlist on page.');
        System.assertEquals(false, pc.ObjFields.isEmpty(),'aftre select object filds of that objects stored in fieldlist');
        System.assertEquals(true, pc.selectedFieldsOptions.isEmpty());
    }
    
    static testmethod void fetchFieldWithoutObjectTest(){
        PaginationController pc = new PaginationController();
   		pc.sObj = ' ';
        pc.fetchFields();
        
        test.startTest();
            pc.fetchFields();
        test.stopTest();

        System.assertEquals(false,pc.show,'when we select none or nothing show should be false and fields lists block should be hidden');
        System.assertEquals(true, pc.ObjFields.isEmpty(),'aftre select object filds of that objects stored in fieldlist');
        
    } 

    @isTest static void listaddRemoveTest(){
        PaginationController pc = new PaginationController();
        //pc.fetchObjects();
        pc.sObj = 'Account';
        pc.fetchFields();
        pc.selectedFields= new list<string>();
        pc.selectedFields.add('Name');
        pc.selectedFields.add('Id');
        pc.selectedFields.add('AccountNumber');
        pc.add();
        System.assertEquals(3, pc.selectedFieldsOptions.size(),'after add button 3 fields should be in selected field options list');
        pc.removeFields.add('AccountNumber');
        pc.removeButton();
        System.assertEquals(2,pc.selectedFieldsOptions.size(),'after removing AccountNumber selectFieldOptions should only contains 2 values name and id');
        
    }
    
    @isTest static void processTest(){
        PaginationController pc = new PaginationController();
        pc.sObj = 'Account';
        pc.fetchFields();
        pc.selectedFields= new list<string>();
        pc.selectedFields.add('Name');
        pc.selectedFields.add('Id');
        pc.selectedFields.add('AccountNumber');
        pc.add();
        System.assertEquals(3, pc.selectedFieldsOptions.size(),'after add button 3 fields should be in selected field options list');
        pc.process();
        System.assert(pc.fieldsApiName.size()==pc.fieldsLableName.size(),'both must be same ');
    }
    
    @isTest static void resetTest(){
     	PaginationController pc = new PaginationController();
        pc.sObj = 'Account';
        pc.reset();
        System.assertEquals(' ', pc.sobj,'sobject value converted to null');
        System.assertEquals(false, pc.show && pc.paginationBlock,'after reset button both select list and pagination block renderd should be false');
    
    }

}