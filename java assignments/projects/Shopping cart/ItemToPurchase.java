
/**
 * Write a description of class ItemToPurchase here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class ItemToPurchase
{
    protected String itemName;
    protected int itemPrice;
    protected int itemQuantity;
    protected String itemDescription;
    public ItemToPurchase(){
        String itemName= "none";
        int itemPrice=0;
        int itemQuantity=0;
        String itemDescription="none";

    }

    public ItemToPurchase(String newName, String newDescription, int newPrice, int newQuantity){
        itemName=newName;
        itemPrice=newPrice;
        itemQuantity=newQuantity;
        itemDescription=newDescription;
    }

    public void setName(String newName){
        itemName=newName;
    }

    public String getName(){
        return itemName;
    }

    public void setPrice(int newPrice){
        itemPrice=newPrice;
    }

    public int getPrice(){
        return itemPrice;
    }

    public void setQuantity(int newQuantity){
        itemQuantity=newQuantity;
    }   

    public int getQuantity(){
        return itemQuantity;
    }

    public void setDescription(String newDescription){
        itemDescription=newDescription;
    }

    public String getDescription(){
        return itemDescription;
    }

    public String printCost(){
        return itemName+"  "+ itemQuantity+" @ $"+itemPrice+" "+ " = $" +(itemQuantity*itemPrice);
    }

    public String printDescription(){
        return itemName+": " + itemDescription;
    }

}
