public class Question11Class {
public List<WrapperClass> myList;
    public List<WrapperClass> SelectedList{get;set;}
    public List<String> ListIteration{get;set;}
    public Question11Class()
    {
        ListIteration=new String[]{'Name','Store_Owner__c','Location__c'};
    }
    public List<WrapperClass> getRecord()
    {
        myList=new List<WrapperClass>();
        List<SObject> RecordList=[SELECT Id, Name, Location__c, Profit__c,Store_Owner__c,Company__c FROM Store__c];
        for(SObject obj:RecordList)
        {
            myList.add(new WrapperClass(obj));
        }
        return myList;
    }
    public void SelectedRecord()
    {
        SelectedList=new List<WrapperClass>();
        for(WrapperClass obj:myList)
        {
            if(obj.MyCheck==true)
            {
                SelectedList.add(obj);
            }
        }
    }
    public class WrapperClass
    {
        public SObject NestObj{get;set;}
        public Boolean MyCheck{get;set;}
        public WrapperClass(SObject NestObj)
        {
            this.NestObj=NestObj;
        }
    }

}