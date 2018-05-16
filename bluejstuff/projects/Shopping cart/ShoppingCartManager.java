
/**
 * Write a description of class ShoppingCartManager here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.Scanner;
public class ShoppingCartManager
{
    public static void main(String [] args){
        
        ShoppingCart customer = new ShoppingCart();
        Scanner scan = new Scanner(System.in);
        System.out.print("Name: ");
        customer.setCustomerName(scan.nextLine());
        
        System.out.print("Date: ");
        customer.setCurrentDate(scan.nextLine());
        
        System.out.println("Press the Enter key to continue.");
        printMenu(customer);
    }
    public static void printMenu(ShoppingCart shoppingCart){
        
       
        Scanner input = new Scanner(System.in);
        String userChoice="1";
        
        while(userChoice != "quit"){
          
            System.out.println("Type in 'add' to add item \n'remove' to remove item");
            
            System.out.println("\n'describe' to view description\n'quantity' to change quantity");
            
            System.out.println("\n'total'to view shopping cart\n'exit' to end program \n");
            userChoice= input.nextLine();
                if(userChoice.equals("add")){
                    System.out.println("Enter item you wish to have added");
                    shoppingCart.addItem(new ItemToPurchase());
                }
                
                
                else if(userChoice == "remove"){
                    System.out.println("Enter item you wish to have removed");
                    shoppingCart.removeItem(new ItemToPurchase());
                }
                
                
                else if(userChoice == "quantity"){
                    System.out.println("Enter new Quantity: ");
                    shoppingCart.modifyItem(input.nextLine());
                }
                
                
                else if(userChoice == "describe"){
                   shoppingCart.printDescriptions();
                }
                
                
                else if(userChoice == "total"){
                    shoppingCart.printTotal();
                }
               else if( userChoice== "exit"){
                   System.exit(0);
             }
        }
        
    }
}
