
/**
 * Write a description of class Contacts here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.io.*;
import java.util.*;
import java.util.Scanner;

public class Tester

{
    public static void main(String[] args) throws FileNotFoundException{
        ArrayList<Contacts> myValues = new ArrayList<Contacts>();
        try{
            File inputFile = new File("contacts.txt");
            Scanner scan = new Scanner(inputFile);

            while(scan.hasNext()){

                String name = scan.nextLine();
                int number = Integer.parseInt(scan.nextLine());
                int ID = Integer.parseInt(scan.nextLine());
                Contacts c = new Contacts(name, number, ID);
                myValues.add(c);

            }
        }catch(IOException e){
            System.out.println("Sorry could not find contacts.txt");
        }

        int choice = 6;
        do{
            if(choice == 0){
                break;

            }

            System.out.println("0- End program");
            System.out.println("1- View All Contacts");
            System.out.println("2- Sort Contacts");
            System.out.println("3- Delete a contact");
            System.out.println("4- Modify a contact");
            System.out.println("5- Save Contacts to Text File");
            Scanner scan = new Scanner(System.in);
            choice = Integer.parseInt(scan.nextLine());

            switch(choice){
                case 0:
                System.out.println("Exiting");
                break;

                case 1:
                System.out.println("Displaying Contacts");
                for(int i = 0; i < myValues.size(); i++){
                    System.out.println(myValues.get(i).toString());}
                break;

                case 2:
                System.out.println("Sorting contacts");
                for(int bubble = 1; bubble<=myValues.size(); bubble++){

                    for(int i = 0; i < myValues.size()-1; i++){
                        if(myValues.get(i).getID() > myValues.get(i+1).getID()){
                            //Integer temp = myValues.get(i).getID();
                            //myValues.set(i, myValues.get(i+1).getID());
                            //myValues.set(i+ 1, temp);
                            Contacts c1 = new Contacts(myValues.get(i).getName(),myValues.get(i).getNumber(),myValues.get(i).getID());
                            myValues.set(i, myValues.get(i+1));
                            myValues.set(i+1, c1);
                        }

                    }

                }
                for(int i = 0; i < myValues.size(); i++){
                    System.out.println(myValues.get(i).toString());}

                break;

                case 3:
                System.out.println("Which contact needs to be deleted?");
                Scanner scanKeyboard = new Scanner(System.in);
                
                int a = Integer.parseInt(scanKeyboard.nextLine());
                for(int i = 0; i < myValues.size(); i++){
                    if(myValues.get(i).getID() == a){
                        myValues.remove(i);
                    
                    }
                
                
                }
                 for(int i = 0; i < myValues.size(); i++){
                    System.out.println(myValues.get(i).toString());}

                
                break;

                case 4:
                System.out.println("Which contact do you want to modify?");
                
                Scanner scanContact = new Scanner(System.in);
                
                int b = Integer.parseInt(scanContact.nextLine());
                //
                for(int i = 0; i < myValues.size(); i++){
                    
                    if(myValues.get(i).getID() == b){
                        System.out.println("What would you like to modify? (1 = Name, 2 = Number, 3 = ID");
                        Scanner user = new Scanner(System.in);
                        int c = Integer.parseInt(user.nextLine());
                        if(c == 1){
                        
                            System.out.print("What would you like to change the name to?");
                            String newName = user.nextLine();
                            myValues.get(i).setName(newName);
                            
                        
                        }
                        
                          if(c == 2){
                        
                            System.out.print("What would you like to change the number to?");
                            int newNumber = Integer.parseInt(user.nextLine());
                            myValues.get(i).setNumber(newNumber);
                            
                        
                        }
                        
                          if(c == 3){
                        
                            System.out.print("What would you like to change the ID to?");
                            int newID = Integer.parseInt(user.nextLine());
                            myValues.get(i).setID(newID);
                            
                        
                        }
                    
                    }
                
                
                }
                 for(int i = 0; i < myValues.size(); i++){
                    System.out.println(myValues.get(i).toString());}
                break;

                case 5:
                System.out.println("Saving contacts to text file");
                PrintWriter myWriter = new PrintWriter("DataSource.txt");

                for(int i = 0; i <myValues.size(); i++){

                    myWriter.println(myValues.get(i));

                }

                myWriter.close();
                break;

                default:
                System.out.println("Wrong number. Please try again.");
                break;
            }

        }while(choice >= 1 || choice <=5);

    }
    //Process the array list
    //Maybe sort the list or add to it

    //Then save back to disk

}
