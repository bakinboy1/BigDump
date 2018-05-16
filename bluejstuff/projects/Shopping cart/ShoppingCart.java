
/**
 * Write a description of class ShoppingCart here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;
public class ShoppingCart extends ItemToPurchase
{
    private String customerName;
    private String currentDate;
    private Scanner scan=new Scanner(System.in);
    private ArrayList<ItemToPurchase> cartItems= new ArrayList<ItemToPurchase>();
    public ShoppingCart(){
        String customerName="none";
        String currentDate="January 1, 2016";

    }

    public ShoppingCart(String newCustomerName, String newCurrentDate){
        customerName=newCustomerName;
        currentDate=newCurrentDate;
    }

    public void setCustomerName(String newCustomerName){
        customerName=newCustomerName;
    }

    public String getCustomerName(){
        return customerName;
    }

    public void setCurrentDate(String newCurrentDate){
        currentDate=newCurrentDate;
    }

    public void addItem(ItemToPurchase newAddItem){
      System.out.print("name: ");
        newAddItem.setName(scan.nextLine());
        
        System.out.print("description: ");
        newAddItem.setDescription(scan.nextLine());
        
        System.out.print("quantity: ");
        newAddItem.setPrice(scan.nextInt());
        
        System.out.print("Enter price: ");
        cartItems.add(newAddItem);
    }
    
    public void removeItem(ItemToPurchase newRemoveItem){
        if (cartItems.size()==0){
            System.out.println("ITEM NOT FOUND IN CART");
        }
        else{
            cartItems.remove(newRemoveItem);
        }
    }
    //works up to here
   
    public void modifyItem(String newModifyItem){
        Scanner scan = new Scanner(System.in);
        scan.nextLine();
        for(int m = 0; m < cartItems.size(); m++){
            if(cartItems.get(m).getName()==newModifyItem){
                String newDescription="description";
                String newPrice="price";
                String newQuantity="quantity";
                String done="done";
                System.out.println("Type description, price, or quantity in order to edit that feature");
                System.out.println("type done to quit editing");
                if(newDescription == scan.nextLine()){
                    System.out.println("Edit Description");
                    cartItems.get(m).setDescription(scan.nextLine());
                }
                System.out.println("Edit Price");
                if(newPrice == scan.nextLine()){
                    System.out.println("Set new price");
                    cartItems.get(m).setPrice(Integer.parseInt(scan.nextLine()));
                }
                System.out.println("Edit Quantity");
                if(newQuantity== scan.nextLine()){
                    System.out.println("set new quantity");
                    cartItems.get(m).setQuantity(Integer.parseInt(scan.nextLine()));
                }
                if (done==scan.nextLine()){
                    break;
                }
            }
        }
    }
    
    public int getNumItemsInCart(){
       
        return cartItems.size();
    }
    
    public int getCostOfCart(){
        int cartCost=0;
        
        
        for(int i=0; i<cartItems.size(); i++){
            cartCost+= cartItems.get(i).getPrice()  *  cartItems.get(i).getQuantity();
        }
        return cartCost;
        
    }
    public void printTotal(){
            System.out.println("Customer: "+customerName +"\nDate: "+currentDate);
            System.out.println("Total Items " + cartItems.size()+"\n");
            
            for(int i = 0; i < cartItems.size(); i++){
                System.out.println("ITEMIZED LIST: "+cartItems.get(i).getName() + " " +
                cartItems.get(i).getQuantity() + " @ $" +
                cartItems.get(i).getPrice() + " = " +
                cartItems.get(i).getPrice() * cartItems.get(i).getQuantity());
            
            }
            System.out.println("Total: " + getCostOfCart());
        
    }

    public void printDescriptions(){
        System.out.println("Description list \n");
        for(int i = 0; i < cartItems.size(); i++){
            System.out.println(cartItems.get(i).getName() + ": " + cartItems.get(i).getDescription()+"\n");
        }
    }

}
