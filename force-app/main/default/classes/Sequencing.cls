public class Sequencing {


    // method to handle sequence number of contact before insert take trigger.new List as parameter 
    public Static void insertcontact(List<Contact> conNewList){
        Map<ID,List<Contact>> newRecordsMap = new map<ID,List<Contact>>();      //to store inserted  records in list associated with account id in map
        Map<ID, Map<Decimal,contact>> existingRecords = new Map<ID, Map<Decimal,contact>>(); //store existing records of contacts of selected accounts
        list<contact> updateList = new list<contact>();

        //this loop will put all new records in map and seprate with key Accountid
        for(contact con:conNewList){ 
            if(!newRecordsMap.containsKey(con.AccountId)){
                newRecordsMap.put(con.AccountId,new List<Contact>());
                existingRecords.put(con.AccountId,new Map<Decimal,contact>());
            } 
            newRecordsMap.get(con.AccountId).add(con);
        }

        //this list stors exesting records of that accounts which are available in map as key and shift them in a map of account id and map of sequence number and contact record
        List<contact> tempList =[SELECT Id, Sequence_Number__c, AccountId FROM Contact WHERE AccountId IN :existingRecords.keySet() ORDER BY AccountId ASC];
        if(templist.size()>0){
            integer sequ = 1;
            Id tempid = tempList[0].AccountId;
            for(contact con: tempList){
                //Assign sequence number to Exesting records 
                if(con.AccountId!=tempid){
                    sequ = 1;
                    tempid = con.AccountId;
                }
                if(con.Sequence_Number__c == Null){
                    con.Sequence_Number__c = sequ;
                    sequ++;
                }
                existingRecords.get(con.AccountId).put(con.Sequence_Number__c, con);
            }
        }
        //this loop is to itrate all accounts associated with list of new contacts 
        for(id actId:newRecordsMap.keySet()){
            Map<Decimal, contact> tempMap = existingRecords.get(actId);    // temprary map to avoid confusion and prevent to itrate other account releted data
            // this loop only itrate new contact records of a perticular account 
            for(contact con: newRecordsMap.get(actId)){
                Integer size = tempMap.size();

                // check if the sequence no. of new contact is less then 1 ( it covers 2 cases when sequence no. is 0 or negative )
                // if true only assign 1 to sequence no. of that contact 
                if(con.Sequence_Number__c < 1){
                    con.Sequence_Number__c = 1;
                }

                //check map(existing records map) contains sequence no of new record if yes then shift records..  it always work on 0 and negative values becaus they changed to 1 in upper step 
                if(tempMap.containsKey(con.Sequence_Number__c)){
                    for(Integer i = size; i>=con.Sequence_Number__c; i--){
                        tempMap.get(i).Sequence_Number__c++;
                        contact temp =  tempMap.get(i);
                        tempMap.put(i+1,temp);
                    }
                    tempMap.put(con.Sequence_Number__c,con);
                }

                // if above conditions is not true it means the sequence no. is out of range or null then add them in end with sequence number size + 1; 
                else{
                    con.Sequence_Number__c = size+1;
                    tempMap.put(con.Sequence_Number__c,con);
                }
            }

            // this loop is to get only old records in list to perform update DML 
            for(decimal seq:tempMap.keySet()){
                if(tempMap.get(seq).id!= Null){
                    updateList.add(tempMap.get(seq));
                }
            }
        }
        UPDATE updateList;
    }

    // after delete edit sequence and update records
    public Static void deleteContact(List<Contact> conDelList){
        Map<id,Decimal> minSeqMap = new Map<id,Decimal>();   // map that Store the Account id as a key and minimum Sequence Number among all deleted Contact of this account
        Map<id,List<contact>> deletedRecords = new Map<id,List<contact>>();
        Map<Id,Map<Decimal,Contact>> allRecordMap = new Map<Id,Map<Decimal,Contact>>();
        List<contact> recordsToUpdate = new List<Contact>();
         for(Contact con: conDelList) {
             if(!minSeqMap.containsKey(con.AccountId)) {
                 minSeqMap.put(con.AccountId,con.Sequence_Number__c);
                 deletedRecords.put(con.AccountId,new List<contact>());
                 allRecordMap.put(con.AccountId, new Map<decimal,contact>());
             }
             
             //find and store deleted minimum sequence number of a particular account
             else {
                 if(minSeqMap.get(con.AccountId) > con.Sequence_Number__c ) {
                    minSeqMap.put(con.AccountId,con.Sequence_Number__c); 
                 }
             }
             deletedRecords.get(con.AccountId).add(con);
         }
         // all records list
         List <Contact> allRecords = [SELECT id,Sequence_Number__c, AccountId FROM Contact WHERE Accountid IN :allRecordMap.keySet()];
         for(contact con : allRecords){
            allRecordMap.get(con.Accountid).put(con.sequence_Number__c,con);
         }
         for(id id : minSeqMap.keySet()) { 
             Decimal MinimumSeqNumber = minSeqMap.get(id);
             Map<decimal,Contact> tempMap = allRecordMap.get(id);
             for(Decimal i = MinimumSeqNumber + 1; i <= tempMap.size()+deletedRecords.get(id).size(); i++) {               // Iterating All Remaining Contacts For this Account After Deletion whose Sequence Number is grater then minimum Sequence num
                if(tempMap.containsKey(i)){
                    tempMap.get(i).Sequence_Number__c = MinimumSeqNumber;
                    MinimumSeqNumber += 1;						
                    recordsToUpdate.add(tempMap.get(i));
                }				
             }
         }
         update recordsToUpdate ;
     }

    // undelete records (add in end)
    public Static void undeleteContact(Map<Id,Contact> undeleteRecords){
        Map<Id,List<Contact>> updatable = new Map<Id,List<contact>>();
        Map<Id,List<contact>> totalRecords = new Map<Id,List<Contact>>();
        List<contact> updateList = new List<Contact>();
        //undeleted contacts to edit sequence number
        List<contact> undeleted = [SELECT Id, Name, Sequence_Number__c, AccountId FROM Contact WHERE Id IN :undeleteRecords.keySet()];
        for(contact con: undeleted){
            if(!updatable.containsKey(con.AccountId)){
                updatable.put(con.AccountId,new List<Contact>());
                totalRecords.put(con.AccountId,new List<Contact>());
           } 
           updatable.get(con.AccountId).add(con);
        }
        //all records to get number of records in particular Account  
        List<contact> allRecords =[SELECT Id, AccountId FROM Contact WHERE AccountId IN :totalRecords.keySet()];
        for(contact con : allRecords){
            totalRecords.get(con.Accountid).add(con);
        }
        // assign new Sequence Number to undeleted contacts
        for(Id id: updatable.keySet()){
            Integer totalSize = totalRecords.get(id).size(); 
            for(Integer i = 0; i < updatable.get(id).size() ; i++){
                updatable.get(id)[i].Sequence_Number__c = (totalSize-updatable.get(id).size()) + i+1;
                updateList.add(updatable.get(id)[i]);
            }          
        }
        update updateList;
    }

    // update logic 
    public Static void updatecontact(List<Contact> conNewList, Map<ID,contact> oldMap){
        Map<ID,List<Contact>> recordNewMap = new map<ID,List<Contact>>();                                   //store list of records to be updated with there Account Id as key 
        Map<ID, Map<Decimal,contact>> existingRecords = new Map<ID, Map<Decimal,contact>>();                //store all exesting records of Selected accounts
        list<contact> updateList = new list<contact>();                                                     //list to store changed data to perform DML operation
        for(contact con:conNewList){ 
            if(!recordNewMap.containsKey(con.AccountId)){
                recordNewMap.put(con.AccountId,new List<Contact>());
                existingRecords.put(con.AccountId,new Map<Decimal,contact>());
            } 
            recordNewMap.get(con.AccountId).add(con);
        }
        for(Id i: oldMap.keySet()){
            if(!existingRecords.containsKey(oldMap.get(i).AccountId)){
                existingRecords.put(oldMap.get(i).AccountId,new Map<Decimal,contact>());
            }
        }
        List<contact> tempList =[SELECT Id, Sequence_Number__c, AccountId FROM Contact WHERE AccountId IN :existingRecords.keySet() ORDER BY Sequence_Number__c ASC];
        for(contact con: tempList){
            existingRecords.get(con.AccountId).put(con.Sequence_Number__c, con);
        }
        //to maintain
        Map<Id,Contact> forOldSequences = new Map<Id,Contact>();
        forOldSequences.putAll([Select id, Sequence_Number__c FROM Contact WHERE Id in: oldMap.keySet()]);
        // iterate map of account ids associated with list of contacts    
        for(id actId:recordNewMap.keySet()){
            Map<Decimal, contact> tempMap = existingRecords.get(actId);
            Map<Decimal,contact> oldParent = new  Map<Decimal,contact>(); 
            // iterate list of contacts of a specific Account
            for(contact con: recordNewMap.get(actId)){
                // checking record updating with re-parenting or not
                Integer oldSeq= Integer.valueOf(forOldSequences.get(con.id).sequence_Number__c);
                if(con.AccountId == oldMap.get(con.id).AccountId){
                    Integer newSeq = Integer.valueOf(con.sequence_Number__c);
                    //when new sequence is 0 or negative 
                    if(newSeq < 1){
                        con.Sequence_Number__c = 1; //assigning 1 shifting will done in next conditions
                        newSeq = 1;
                    }
                    //when new sequence is more then range or null
                    else if(newSeq > tempMap.size() || newSeq == null){
                        con.Sequence_Number__c = tempMap.size(); //assigning last sequence shifting will done in next conditions
                        newSeq = tempMap.size();
                    }
					//when old sequence is grater then new then shift sequence to next 
                    if(oldseq > newSeq){    
                        for(Integer i = oldseq-1; i>=newSeq; i--){
                            tempMap.get(i).Sequence_Number__c++;
                            contact temp =  tempMap.get(i);
                            tempMap.put(temp.sequence_Number__c,temp);
                            if(forOldSequences.containsKey(temp.id)){
                                forOldSequences.get(temp.id).Sequence_Number__c++;
                            }     
                        }
                        tempMap.put(con.Sequence_Number__c,con);
                    }
                    //when old sequence is Less then new then shift sequence to previous
                    else if(oldseq < newSeq){
                        for(Integer i = oldseq+1; i<=newSeq; i++){
                            tempMap.get(i).Sequence_Number__c--;
                            contact temp = tempMap.get(i);
                            tempMap.put(temp.Sequence_Number__c,temp);
                            if(forOldSequences.containsKey(temp.id)){
                                forOldSequences.get(temp.id).Sequence_Number__c--;
                            }
                        }
                        tempMap.put(con.Sequence_Number__c,con);
                    }
                    else{
                        tempMap.put(con.Sequence_Number__c,con);
                    }
                }

                // Re-Parenting
                else{                    
                    //when record have parent and changing to another account or null 
                    if(oldMap.get(con.id).AccountId!=null){
                       // Integer oldSeq= Integer.valueOf(oldMap.get(con.id).sequence_Number__c);
                        oldParent = existingRecords.get(oldMap.get(con.id).AccountId);
                        for(Integer i = oldSeq+1; i <= oldParent.size(); i++){
                            oldParent.get(i).Sequence_Number__c--;
                            contact temp = oldParent.get(i);
                            oldParent.put(temp.Sequence_Number__c,temp);
                            if(forOldSequences.containsKey(temp.id)){
                                forOldSequences.get(temp.id).Sequence_Number__c--;
                            }
                        }
                        oldParent.remove(oldParent.size()); 
                        // when assigning new parent 
                        if(con.AccountId !=null){
                            con.Sequence_Number__c = tempMap.size()+1;
                            tempMap.put(con.Sequence_Number__c,con);
                        }
                        // when assigning null
                        else{
                            con.Sequence_Number__c = null;
                        }
                    }

                    // when record not have parent and assigning a parent
                    else{
                        con.Sequence_Number__c = tempMap.size()+1;
                        tempMap.put(con.Sequence_Number__c,con);
                    }
                }          
            }
            for(decimal seq:tempMap.keySet()){
                if(!oldMap.containsKey(tempMap.get(seq).id)){ 
                    updateList.add(tempMap.get(seq));
                }
            }
            for(decimal seq:oldParent.keySet()){
                if(!oldMap.containsKey(oldParent.get(seq).id)){ 
                    updateList.add(oldParent.get(seq));
                }
            }
        }
        UPDATE updateList;
        checkRecursive.firstCheck = false;
    }
}