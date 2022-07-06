public class Question9Class {
    public List<Integer> firstList;
    Public List<Integer> secondList;
    Public List<Integer> thirdList;
    
    Public List<Integer> getFb(){
        if(firstList == null){
        	firstList = new Integer[10];
        }
        for(Integer i = 0; i<10; i++){
            firstList[i] = i+1;
        }
        Return firstList;
    }
    public PageReference pageref(){
        if(secondList == null){
        	secondList = new Integer[10];
        }
        for(Integer i =0; i<10; i++){
            secondList[i] = 10*(i+1);
        }  
        Return null;
    }
    
    Public List<Integer> getSb(){
        Return secondList;
    }
    
    public PageReference pageref1(){
        if(thirdList == null){
        	thirdList = new Integer[10];
        }
        for(Integer i =0; i<10; i++){
            thirdList[i] = firstList[i]*(i+1);
        }  
        return null;
    }
        Public List<Integer> getTb(){
        Return thirdList;
    }
}