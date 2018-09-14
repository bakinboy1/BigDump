e
/**
 * The menu calss initializes the arraylist for the animals and contains all their values
 * the main function contains the if else statements that allow for user interaction with the data
 * 
 * @author (Fabian Hucke) 
 * @version (3/15/2016)
 */
//include an @(parameter name) tag for each parameter and for return
/**
 * import scanner and arrayList function
 */
import java.util.Scanner;
import java.util.ArrayList;
public class Menu
{
    /**
     * @public Menu() initializes the animal arrayList 
     */
    private ArrayList<Animal> exhibit;
    public Menu(){
        initializeArray();
    }

    /**
     *  @initializeArray creates the initial values for all the animals in the aquarium
     */
    public void initializeArray(){
        exhibit=new ArrayList<>();
        exhibit.add(new Male(true, true, true, "Roman Soldiers", "Hannibal", 180.0, 28, 200, true));
        exhibit.add(new Male(true, true, false, "Seals", "Shamu", 600.0, 14, 899, true));
        exhibit.add(new Female(false, true, false, "Greek Heros", "Medusa", 120.0, 400, 170, 55));
        exhibit.add(new Female(true, true, false, "Grass", "Cow with floaties", 700, 15, 300, 200));
        exhibit.add(new Mammal(true, true, false, "Lettuce", "Fat Manatee", 5000.5, 5, 910));
        exhibit.add(new Mammal(false, true, true, "Clams", "Otter", 25.1, 8, 80));
        exhibit.add(new Fish(true, false, true, true, "Nails, no milk", "Bad Bass Fish", 200.8, 44));
        exhibit.add(new Fish(false, false, false, true,"Australians", "Great White Shark", 899.2, 23));
        exhibit.add(new Fish(true, false, true, true,"Crabs", "Manta Ray", 210.3, 13));
    }

    /**
     * @ public ArrayList<Animal>getExhibit() returns exhibit values with corresponding arraylist position 
     * entered into the ()
     */
    public ArrayList<Animal>getExhibit(){
        return exhibit;
    }

    /**
     * @m creates a new Menu object
     * @input initializes a new scanner for the user
     * @userChoice stores the input of the user
     * @counter is used to store the arrayList position of the animal the user has requested
     */
    public static void main(String[] args){
        Menu m = new Menu();
        Scanner input = new Scanner(System.in);
        String userChoice="1";
        //System.out.println(m.getExhibit().get(0));
        //m.getExhibit().get(1).setWeight(100.0);
        int counter=0;

        System.out.println("Welcome to the Atlanta aquarium \n enter a number 0-8 to display an animal's details \n enter -on- or -off- to change whether or not its on site \n -here- or -away- to change its transfer schedule,  9 to quit  ");

        while (!(userChoice.equals("9"))){
            System.out.println("enter a number 0-8 or -menu- for more options");
            userChoice= input.nextLine();
            /**
             * for each int 0-8 the user inputs, they system will print out the corresponding animal position 
             * on the arrayList and the counter variable mutates to equal the arrayList position in case the
             * user wants to modify boolean values
             */
            if (userChoice.equals("0")){
                System.out.println(m.getExhibit().get(0));
                counter=0;
            }
            else if (userChoice.equals("1")){
                System.out.println(m.getExhibit().get(1));
                counter=1;
            }
            else if (userChoice.equals("2")){
                System.out.println(m.getExhibit().get(2));
                counter=2;
            }
            else if (userChoice.equals("3")){
                System.out.println(m.getExhibit().get(3));
                counter=3;
            }
            else if (userChoice.equals("4")){
                System.out.println(m.getExhibit().get(4));
                counter=4;
            }
            else if (userChoice.equals("5")){
                System.out.println(m.getExhibit().get(5));
                counter=5;
            }
            else if (userChoice.equals("6")){
                System.out.println(m.getExhibit().get(6));
                counter=6;
            }
            else if (userChoice.equals("7")){
                System.out.println(m.getExhibit().get(7));
                counter=7;
            }
            else if (userChoice.equals("8")){
                System.out.println(m.getExhibit().get(8));
                counter=8;
            }
            else if (userChoice.equals("9")){
                System.exit(0);
            }
            /**
             * if the user enters "on" or "off" into the prompt, it switches the value of the onSite boolean 
             * to "true" or "false"
             */
            else if (userChoice.equals("on")){
                m.getExhibit().get(counter).setOnSite(true);
                System.out.println(m.getExhibit().get(counter).getName() +" is on site?: "+ m.getExhibit().get(counter).getOnsite()+ "\n");
            }
            else if (userChoice.equals("off")){
                m.getExhibit().get(counter).setOnSite(false);
                System.out.println(m.getExhibit().get(counter).getName() +" is on site?: "+ m.getExhibit().get(counter).getOnsite()+ "\n");
            }
            /**
             *if the user enters "here" or "there" into the prompt, it switches the value of the Transfer boolean
             *to "false" or "true"
             */
            else if (userChoice.equals("here")){
                m.getExhibit().get(counter).setTransfer(false);
                System.out.println(m.getExhibit().get(counter).getName() +" is scheduled to be transferred?: "+ m.getExhibit().get(counter).getTransfer()+ "\n");
            }
            else if (userChoice.equals("away")){
                m.getExhibit().get(counter).setTransfer(true);
                System.out.println(m.getExhibit().get(counter).getName() +" is scheduled to be transferred?: "+ m.getExhibit().get(counter).getTransfer()+ "\n");
            }
            /**
             *if the user enters "menu" into the prompt, the program prints out instructions on how to change 
             *the onSite and Transfer boolean values
             */
            else if (userChoice.equals("menu")){
                System.out.println("\n enter -on- or -off- to change whether or not its on site \n  enter -here- or -away- to change its transfer schedule,  9 to quit  ");
            }
            /**
             * if the user enters a string other than what is listed in the while loop it will return an 
             * error message and ask the user to input again
             */
            else{
                System.out.println("you must enter a number between 0-8");
                userChoice= input.nextLine();
            }

        }
    }
}
