public class ContectSequencingTriggerHandlor {

   public Static void insertcontact(List<Contact> conNewList){
        map<string,List<Contact>> contactWithAccID = new map<string,List<Contact>>();
        for(contact con:conNewList){ 
            if(!contactWithAccID.containsKey(con.AccountId)){
                contactWithAccID.put(con.AccountId,new List<Contact>());
            } 
            contactWithAccID.get(con.AccountId).add(con);
        }
        System.debug('map -------->'+contactWithAccID);

        for(String id: contactWithAccID.keySet()){
            List<Contact> tempConList =[SELECT Id, Name, Sequence_Number__c FROM Contact WHERE AccountId =:id ORDER BY Sequence_Number__c ASC ];
            Integer count = 0;
            integer tempSize = tempConList.size();
            for(Integer i = 0; i <  contactWithAccID.get(id).size(); i++){
                

                if(contactWithAccID.get(id)[i].Sequence_Number__c > tempSize || contactWithAccID.get(id)[i].Sequence_Number__c == null){
                    contactWithAccID.get(id)[i].Sequence_Number__c = tempConList.size() + i+1;
                    tempSize++;
                    
                }

                else if(contactWithAccID.get(id)[i].Sequence_Number__c < 1){
                    count++;
                    contactWithAccID.get(id)[i].Sequence_Number__c = 1;
                    for(Integer j = 0; j < tempConList.size(); j++){
                        tempConList[j].Sequence_Number__c = count+j+1;
                        System.debug('Negative value or 0 enterd ---' + tempConList[j].Sequence_Number__c);
                    }
                    for(Integer l =0; l<i; l++){
                        if(contactWithAccID.get(id)[i].Sequence_Number__c <= contactWithAccID.get(id)[l].Sequence_Number__c){
                            contactWithAccID.get(id)[l].Sequence_Number__c++;
                       }
                    }
                    tempSize++;
                }
                
                else if(contactWithAccID.get(id)[i].Sequence_Number__c > 0 && contactWithAccID.get(id)[i].Sequence_Number__c <= tempSize){
                    System.debug('new list sequence '+contactWithAccID.get(id)[i].Sequence_Number__c);
                    
                    for(Integer l =0; l<i; l++){
                        if(contactWithAccID.get(id)[i].Sequence_Number__c <= contactWithAccID.get(id)[l].Sequence_Number__c){
                            contactWithAccID.get(id)[l].Sequence_Number__c++;
                       }
                    }
                    //for(Integer k = Integer.valueOf(contactWithAccID.get(id)[i].Sequence_Number__c-1) ; k < tempConList.size(); k++){

                    for(Integer k = 0 ; k < tempConList.size(); k++){
                        if(contactWithAccID.get(id)[i].Sequence_Number__c <= tempConList[k].Sequence_Number__c){
                            tempConList[k].Sequence_Number__c++;
                        }
                    }
                    tempSize++;
                }
            }
            update tempConList;
        }
    }



    public Static void deleteContact(List<Contact> conDelList){
        map<string,List<Contact>> contactWithAccID = new map<string,List<Contact>>();
        for(contact con:conDelList){ 
            if(!contactWithAccID.containsKey(con.AccountId)){
                contactWithAccID.put(con.AccountId,new List<Contact>());
            } 
            contactWithAccID.get(con.AccountId).add(con);
        }
        
        for(String id: contactWithAccID.keySet()){
            List<Contact> tempConList =[SELECT Id, Name, Sequence_Number__c FROM Contact WHERE AccountId =:id ORDER BY Sequence_Number__c ASC ];
            for(Integer i = 0; i <  contactWithAccID.get(id).size(); i++){
                for(Integer k = 0 ; k < tempConList.size(); k++){
                    if(contactWithAccID.get(id)[i].Sequence_Number__c < k+1){
                        tempConList[k].Sequence_Number__c--;
                    }
                }
            }
            update tempConList;
        }
    }



    public Static void undeleteContact(List<Contact> conDelList){
        map<string,List<Contact>> contactWithAccID = new map<string,List<Contact>>();
        set<id> conIds = new set<id>();
        for(contact con:conDelList){ 
            conIds.add(con.id);
            if(!contactWithAccID.containsKey(con.AccountId)){
                contactWithAccID.put(con.AccountId,new List<Contact>());
            } 
            contactWithAccID.get(con.AccountId).add(con);
        }
        for(String id: contactWithAccID.keySet()){
            List<Contact> tempConListforSize =[SELECT Id FROM Contact WHERE AccountId =:id];
            List<Contact> contactToUpdate = [SELECT Id, Name, Sequence_Number__c FROM Contact WHERE AccountId =:id AND id IN :conIds];
            for(Integer i = 0; i < contactToUpdate.size() ; i++){
                contactToUpdate[i].Sequence_Number__c = (tempConListforSize.size()-contactToUpdate.size()) + i+1;
            }
            update contactToUpdate;
        }
    }
}