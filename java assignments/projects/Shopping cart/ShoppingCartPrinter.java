
/**
 * Write a description of class ShoppingCartPrinter here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.Scanner;
public class ShoppingCartPrinter
{
    public static void main (String args[]){
        Scanner scnr= new Scanner(System.in);

        ItemToPurchase item1= new ItemToPurchase();
        ItemToPurchase item2= new ItemToPurchase();

        System.out.println("Item 1");
        System.out.println("Enter the item name: ");
        while (scnr.hasNextLine()){
            String item1Name= scnr.nextLine();
            item1.setName(item1Name);
        }
        

        System.out.println("Enter the item price: ");
        while (scnr.hasNextLine()){
            int item1Price= scnr.nextInt();
                    item1.setPrice(item1Price);
        }


        System.out.println("Enter the item quantity: ");
        while (scnr.hasNextLine()){
            int item1Quantity= scnr.nextInt();
                    item1.setQuantity(item1Quantity);
        }


        System.out.println("\nItem 2");
        System.out.println("Enter the item name: ");
        Scanner scnr2= new Scanner(System.in);
        while (scnr.hasNextLine()){
            String item2Name= scnr2.nextLine();
                    item2.setName(item2Name);
        }


        System.out.println("Enter the item price: ");
        while (scnr.hasNextLine()){
            int item2Price= scnr2.nextInt();
                    item2.setPrice(item2Price);
        }


        System.out.println("Enter the item quantity: ");
        while (scnr.hasNextLine()){
            int item2Quantity= scnr2.nextInt();
                    item2.setQuantity(item2Quantity);
        }


        System.out.println("Total Cost");
        System.out.println(item1.printCost());
        System.out.println(item2.printCost());
        int total= item1.getPrice()*item1.getQuantity()+item2.getPrice()*item2.getQuantity();
        System.out.println("Total: $" + total);

    }
}
