trigger ContactSequencing on Contact (before insert, before update, after delete, after undelete) {
    
    if(trigger.isInsert){
            checkRecursive.firstCheck = true;
            Sequencing.insertcontact(trigger.new);
    }
    
    else if(trigger.isDelete){
        checkRecursive.firstCheck = true;
        Sequencing.deleteContact(trigger.old);
    }

    else if(trigger.isUndelete){
        checkRecursive.firstCheck = true;
        Sequencing.undeleteContact(trigger.newMap);
    }

    else if(trigger.isUpdate){
        if(!checkRecursive.firstCheck){
            checkRecursive.firstCheck = true;
            Sequencing.updateContact(trigger.new,trigger.oldMap);
            
        }
     }
}