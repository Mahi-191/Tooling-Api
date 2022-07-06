public class wraperclassstore {
    List <WrapClass> myList=null;
    public List <WrapClass> cartList{get;Set;}
    public List <WrapClass> shopList{get;set;}
    
    public List<WrapClass> getRecord()
    {
        if(myList==null)
        {
            myList=new List<WrapClass>();
        }
List<Merchandise__c> myMerchandise=[SELECT Id,Name,Job_DEscription__c,Price__c,Total_Inventory__c FROM Merchandise__c];
        
        for(Merchandise__c merch:myMerchandise)
        {
            myList.add(new WrapClass(merch));
        }
        return myList;
    }
    
    public PageReference addToCart()
    {
        if(cartList==null)
        {
            cartList=new List<WrapClass>();
        }
        for(WrapClass obj:myList)
        {
            if(obj.qtyToBuy>0)
            {
                obj.totalAmount=obj.qtyToBuy*obj.Price;
                cartList.add(obj);
            }
        }
        return null;
    }
    
    public PageReference shopNow()
    {
        if(shopList==null)
        {
            shopList=new List<WrapClass>();
        }
        for(WrapClass obj:cartList)
        {
            if(obj.checkStatus==true)
            {
                shopList.add(obj);
            }
        }
        return null;
    }
    
    public class WrapClass
    {
        Merchandise__c merch;
        public WrapClass(Merchandise__c merch)
        {
            this.Merch=merch;
        }
        public String Name{get{return merch.Name;}}
        public String Description{get{return merch.Job_Description__c;}}
        public Decimal Price{get{return merch.Price__c;}}
        public Boolean Stock{get { return (0 < merch.Total_Inventory__c);}}
        public Integer qtyToBuy{get;set;}
        public Boolean checkStatus{get;set;}
        public Decimal totalAmount{get;set;}
    }
}