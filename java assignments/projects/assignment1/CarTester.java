

/**
 * User inputs a number between 1 and 3, program returns car name, 
 * 
 * @author Fabian Hucke, Micah Edwards 
 * @version 2/8/2015
 */
import java.util.Scanner;
public class CarTester
{
    /**
     * main function of program.
     * asks user for input to display certain object values
     * contains mutated values for objects
     * instatiates car mutated values
     */
    public static void main (String[] args){
        Scanner input=new Scanner(System.in);
        String userChoice="1";
        Car c1= new Car();
        Car c2= new Car("Porshe", 2003, 180000.00, true);
        Car c3= new Car("Geo metro", 1992, 2000.00, true);
        Car c4= new Car("Prius", 2010, 15000.00, true);
        Car c5= new Car("audi R8", 2016, 190000.00, false);

        System.out.println("hello, please type in a number between 1 and 5 \n to print out your car information \n");
        userChoice=input.nextLine();
        /**
         * while loop that gives certain outputs based on user inputs
         */
        //not sure why the ! needs to be on the outside of the equalsIgnoreCase
        //unsure of the difference between .equals and .equalsIgnoreCase
        //is there a way to make this work while still keeping the user inputs as int values instead of Strings?
        while (!(userChoice.equalsIgnoreCase("0"))){
            System.out.println("please enter a number, or press 0 to quit \n 6,7,8 will mutate values for certain cars");
            userChoice=input.nextLine();
            if (userChoice.equalsIgnoreCase("1")){
                System.out.println(c1.toString());
            }
            else if (userChoice.equalsIgnoreCase("2")){
                System.out.println(c2.toString());
            }
            else if (userChoice.equalsIgnoreCase("3")){
                System.out.println(c3.toString());
            }
            else if (userChoice.equalsIgnoreCase("4")){
                System.out.println(c4.toString());
            }
            else if (userChoice.equalsIgnoreCase("5")){
                System.out.println(c5.toString());
            }
            else if (userChoice.equalsIgnoreCase("6")){
                c2.setPrice(120000.00);
                c2.setYear(1998);
                System.out.println(c2.toString());
            }
            else if (userChoice.equalsIgnoreCase("7")){
                c4.setYear(2017);
                c4.setPrice(21000);
                System.out.println(c4.toString());
            }
            else if (userChoice.equalsIgnoreCase("8")){
                c5.setIsUsed(true);
                c5.setPrice(133000.00);
                System.out.println(c5.toString());
            }
            else if (userChoice.equalsIgnoreCase("0")){
                System.exit(0);
            }
            else {
                System.out.println("please enter a number, or press 0 to quit");
                userChoice=input.nextLine();
            }
        }


    }
}
