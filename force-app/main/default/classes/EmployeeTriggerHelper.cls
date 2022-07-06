public class EmployeeTriggerHelper {
    
	public void insertTask(list<Employee__c> newList){
        Map<ID,List<Employee__c>> newRecordsMap = new map<ID,List<Employee__c>>();      
        Map<ID, Map<Decimal,Employee__c>> existingRecords = new Map<ID, Map<Decimal,Employee__c>>();
        list<Employee__c> updateList = new list<Employee__c>();
        
        for(Employee__c emp:newList){ 
            if(!newRecordsMap.containsKey(emp.CompanyName__c)){
                newRecordsMap.put(emp.CompanyName__c,new List<Employee__c>());
                existingRecords.put(emp.CompanyName__c,new Map<Decimal,Employee__c>());
            } 
            newRecordsMap.get(emp.CompanyName__c).add(emp);
        }

        //this list stors exesting records of that companyes which are available in map as key and shift them in a map of  id and map of sequence number and employee record
        List<Employee__c> tempList =[SELECT Id, Sequence_Number__c, CompanyName__c FROM Employee__c WHERE CompanyName__c IN :existingRecords.keySet()];
        if(templist.size()>0){
            integer sequ = 1;
            Id tempid = tempList[0].CompanyName__c;
            for(Employee__c emp: tempList){
                //Assign sequence number to Exesting records 
                if(emp.CompanyName__c!=tempid){
                    sequ = 1;
                    tempid = emp.CompanyName__c;
                }
                if(emp.Sequence_Number__c == Null){
                    emp.Sequence_Number__c = sequ;
                    sequ++;
                }
                existingRecords.get(emp.CompanyName__c).put(emp.Sequence_Number__c, emp);
            }
        }
        //this loop is to itrate all companys associated with list of new employees 
        for(id compId:newRecordsMap.keySet()){
            Map<Decimal, Employee__c> tempMap = existingRecords.get(compId);    // temprary map to avoid confusion and prevent to itrate other account releted data
            // this loop only itrate new employee records of a perticular company 
            for(Employee__c emp: newRecordsMap.get(compId)){
                Integer size = tempMap.size();

                // check if the sequence no. of new record is less then 1 ( it covers 2 cases when sequence no. is 0 or negative )
                // if true only assign 1 to sequence no. 
                if(emp.Sequence_Number__c < 1){
                    emp.Sequence_Number__c = 1;
                }

                //check map(existing records map) contains sequence no of new record if yes then shift records
                if(tempMap.containsKey(emp.Sequence_Number__c)){
                    for(Integer i = size; i>=emp.Sequence_Number__c; i--){
                        tempMap.get(i).Sequence_Number__c++;
                        Employee__c temp =  tempMap.get(i);
                        tempMap.put(i+1,temp);
                    }
                    tempMap.put(emp.Sequence_Number__c,emp);
                }

                // if above conditions is not true it means the sequence no. is out of range or null then add them in end with sequence number size + 1; 
                else{
                    emp.Sequence_Number__c = size+1;
                    tempMap.put(emp.Sequence_Number__c,emp);
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
}