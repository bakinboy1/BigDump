
public class CocaCola
{
    String kindOfCoke;
    int amount;
    double unitPrice;
    
    public CocaCola(String kindOfCoke, int amount, double unitPrice){
        setKindOfCoke(kindOfCoke);
        setAmount(amount);
        setUnitPrice(unitPrice);        
    }
    public void setKindOfCoke(String kindOfCoke){
        this.kindOfCoke = kindOfCoke;
    }
    public void setAmount (int amount){
        this.amount = amount; 
    }
    public void setUnitPrice(double unitPrice){
        this.unitPrice = unitPrice;
    }
    public String getKindOfCoke(){
        return kindOfCoke;
    }
    public int getAmount(){
        return amount;
    }
    public double getUnitPrice(){
        return unitPrice;
    }
    public String toString(){
        return "There are " + amount + " units of " + 
            kindOfCoke + " at " + unitPrice + " each.";
    }
}
