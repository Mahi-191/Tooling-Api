public class StringArrayTest{
    public static list<String> generateStringArray(Integer i){
        List<String> test = new List<String>();
        for(Integer j = 0;j<i;j++){
            test.add('Test '+i);
        }
        return test;
    }
}