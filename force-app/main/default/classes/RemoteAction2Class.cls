public class RemoteAction2Class {

    public String fileName{get;set;}
    public Blob fileBody{get;set;}
   
  
    public Boolean getValue(String fname, Blob fBody)
    {
      fileName=fname;
	  fileBody=fBody;
	  return true;
    }
}