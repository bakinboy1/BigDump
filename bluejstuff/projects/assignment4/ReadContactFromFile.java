
/**
 * Read data from a file
 * 
 * @author Radhouane
 * @version 4/22/2016
 */
import java.util.*;
//import java.io.File;
//import java.io.FileNotFoundException;
import java.io.*;

public class ReadContactFromFile
{
    public static void main(String[] arg) throws FileNotFoundException
    {
        ArrayList<Contact> data = new ArrayList<Contact>();

        String userChoice = " ";
        //try-catch blocks for exception handling
        try{
            //Set up a file object
            File myFile = new File("contacts.txt");
            //Set up a scanner for that file 
            Scanner scan = new Scanner(myFile);  
            //read through file

            while(scan.hasNext()){
                String name = scan.nextLine();
                int age = Integer.parseInt(scan.nextLine());   
                String address = scan.nextLine();
                double income = Double.parseDouble(scan.nextLine());
                String isMarried = scan.nextLine();
                boolean b;
                if(isMarried.equals("true")) {
                    b = true;
                    isMarried.equals("true");
                }
                else {
                    b = false;
                    isMarried.equals("false");
                }
                String city = scan.nextLine();
                Contact p = new Contact(name, age, address, income, b);
                //Add that value to the array list
                data.add(p);
            }

        } catch(IOException e){
            System.out.println("The file called contacts was nout found!!");
        }

        /**
         * While loop containing the menu and designated functions of the program
         */
        //The program won't compile unless i instantiate these outside the try/catch
        Scanner typed= new Scanner(System.in);
        File myFile = new File("contacts.txt");
        Scanner scan = new Scanner(myFile);  

        System.out.println("welcome to the telephone directory.\n to view all contacts, type 'contacts'"+
            "\n To sort contact list, type 'sort' \n to delete a contact, type 'delete', \n press enter,"+
            "then the name of the contact you wish to delete \n to modify a contact, type 'modify', press enter, then"+
            " type \n 'name, age, address, income, or married ' to access and modify that value \n type in 'save' to save any changes "+
            "you've made \n");
        while(!(userChoice.equals("exit"))){
            System.out.println(" contacts, sort, delete, modify, save, exit");
            userChoice= typed.nextLine();        
            /**
             * prints out all contacts
             */
            if(userChoice.equals("contacts")) {

                for(int i = 0; i < data.size(); i++){
                    System.out.println(data.get(i).toString());

                }

            }
            /**
             * sorts contacts alphabetically
             * 
             */
            else if(userChoice.equals("sort")){

                for(int bubble = 1; bubble <=data.size(); bubble++){

                    for(int i = 0; i < data.size()-1; i++){
                        if(0<data.get(i).getName().compareTo(data.get(i+1).getName())){
                            Contact temp = data.get(i);
                            data.set(i, data.get(i+1));
                            data.set(i+1, temp);
                        }
                    }
                }
                for(int i = 0; i < data.size(); i++){
                    System.out.println(data.get(i).toString());
                }
            }
            /**
             * deletes a contact
             */
            else if(userChoice.equals("delete")){
                System.out.println("Which contact do you want to remove?");
                //print only contact names
                userChoice= typed.nextLine();
                //search for user input to delete string
                for(int i=0;i<data.size();i++){
                    //deletes Contact -i- info
                    //DOUBLE CHECK TO MAKE SURE THIS WORKS CORRECTLY
                    if(userChoice.equals(data.get(i).getName())){
                        data.remove(i);
                        System.out.println("you've successfully removed the contact");
                    }
                }
            }
            /**
             * allows the user to choose a contact by name.
             * then the user enters which aspect they wish to modify (name, age, address, income, or married)
             * then the user enters the modification to that aspect
             */
            else if (userChoice.equals("modify")){
                //print only contact names
                for(int i = 0; i < data.size(); i++){
                    System.out.println(data.get(i).getName());

                }
                System.out.println("Enter the name of the contact you wish to modify");
                
                System.out.println("type 'done' to finish modifying contacts");
                String nameToFind = typed.nextLine();
                
                
                
                for (int i=0;i<data.size();i++){
                    data.get(i).getName();
                    
                    if (nameToFind.equals(data.get(i).getName())){
                        System.out.println("you've chosen to modify "+ nameToFind +"\n");
                        System.out.println("enter what aspect you wish to modify: name, age, address, income, married. 'done'=exit  \n");
                        userChoice= typed.nextLine();
                        while (!(userChoice.equals("done"))) {
                            
                            
                            if(userChoice.equals("name")){
                                System.out.println("type in the new name for the contact \n");
                                String newName=typed.nextLine();
                                data.get(i).setName(newName);
                                System.out.println("your contact's name has been changed to "+ newName);
                                System.out.println("enter what aspect you wish to modify: name, age, address, income, married. 'done'x4=exit  \n");
                                userChoice= typed.nextLine();
                            }

                            else if(userChoice.equals("age")){
                                System.out.println("type in the new age for the contact \n");
                                String newAge=typed.nextLine();
                                data.get(i).setAge(Integer.parseInt(newAge));
                                System.out.println("your contact's age has been changed to "+ newAge);
                                System.out.println("enter what aspect you wish to modify: name, age, address, income, married. 'done'=exit  \n");
                                userChoice= typed.nextLine();
                            }

                            else if(userChoice.equals("address")){
                                System.out.println("type in the new address for the contact \n");
                                String newAddress=typed.nextLine();
                                data.get(i).setAddress(newAddress);
                                System.out.println("your contact's address has been changed to "+ newAddress);
                                System.out.println("enter what aspect you wish to modify: name, age, address, income, married. 'done'=exit  \n");
                                userChoice= typed.nextLine();
                            }
                            else if(userChoice.equals("income")){
                                System.out.println("type in the new income for the contact \n");
                                String newIncome=typed.nextLine();
                                data.get(i).setIncome(Double.parseDouble(newIncome));
                                System.out.println("your contact's income has been changed to "+ newIncome);
                                System.out.println("enter what aspect you wish to modify: name, age, address, income, married. 'done'=exit  \n");
                                userChoice= typed.nextLine();
                            }
                            else if(userChoice.equals("married")){
                                System.out.println("type in the new married status for the contact \n you must enter 'true' or 'false'");
                                String newMarried=typed.nextLine();
                                
                                if(newMarried.equals("true")) {
                                    data.get(i).setIsMarried(Boolean.valueOf("true"));
                                }
                                else {
                                    data.get(i).setIsMarried(Boolean.valueOf("false"));
                                    newMarried="false";
                                }
                               System.out.println("your contact's married status has been changed to "+ newMarried);
                                System.out.println("enter what aspect you wish to modify: name, age, address, income, married. 'done'=exit  \n");
                                userChoice= typed.nextLine();
                            }
                            else if (userChoice.equals("done")){
                            continue;
                            }
                            else{
                                System.out.println("enter what aspect you wish to modify: name, age, address, income, married. 'done'=exit  \n");
                                userChoice= typed.nextLine();
                            }
                            

                        }
                    }
                    else if (nameToFind.equals("done")){
                        continue;
                        
                        
                    }
                    else{
                        System.out.println("You must enter one of the names listed to modify \n");
                    }
                   
                }
           }
            /**
             * saves user's contact list
             * copied from playingWithFiles document
             * not sure if it is correct/complete in this form
             */
            else if (userChoice.equals("save")){
                //Create the print writer within this if statement
                PrintWriter myWriter= new PrintWriter("contacts.txt");
                for(int i = 0; i < data.size(); i++){
                    myWriter.println(data.get(i).getName());
                    myWriter.println(data.get(i).getAge());
                    myWriter.println(data.get(i).getAddress());
                    myWriter.println(data.get(i).getIncome());
                    myWriter.println(data.get(i).getIsMarried());

                }
                //close the print writer WITHIN this statement
                myWriter.close();
                System.out.println("contacts have been saved");
            }
            /**
             * user types in 'exit' to close the program
             * program saves contact list before exiting
             * copied from playingWithFiles
             * not sure if it is correct/complete in this form
             */
            else if (userChoice.equals("exit")){
                PrintWriter myWriter= new PrintWriter("contacts.txt");
                for(int i = 0; i < data.size(); i++){
                    myWriter.println(data.get(i).getName());
                    myWriter.println(data.get(i).getAge());
                    myWriter.println(data.get(i).getAddress());
                    myWriter.println(data.get(i).getIncome());
                    myWriter.println(data.get(i).getIsMarried());
                }
                myWriter.close();
                System.exit(0);
            }
            /**
             * if the user enters input other than one of the given options it will loop back to user input
             */
            else{
                System.out.println("You must enter one of the input options");
                userChoice= typed.nextLine();
            }

        }

    }
}
