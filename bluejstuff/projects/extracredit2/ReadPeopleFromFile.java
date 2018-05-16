
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

public class ReadPeopleFromFile
{
    public static void main(String[] arg) throws FileNotFoundException
    {
        ArrayList<Person> data = new ArrayList<Person>();
        //try-catch blocks for exception handling
        try{
            //Set up a file object
            File myFile = new File("friends.txt");
            //Set up a scanner for that file 
            Scanner scan = new Scanner(myFile);     

            while(scan.hasNext()){
                String name = scan.nextLine();
                
                Person p = new Person(name);
                System.out.println(p.toString());
                //Add that value to the array list
                data.add(p);
            }

        } catch(IOException e){
            System.out.println("The file called friends was nout found!!");
        }

        for(int i = 0; i < data.size(); i++){
            System.out.println(data.get(i).toString());
        }
        //Sort the array list
        //Sort the array list (by person's name)

        for(int bubble = 1; bubble <=data.size(); bubble++){

            for(int i = 0; i < data.size()-1; i++){
                if(0<data.get(i).getName().compareTo(data.get(i+1).getName())){
                    Person temp = data.get(i);
                    data.set(i, data.get(i+1));
                    data.set(i+1, temp);
                }
            }
        }
        //Add another person to Db
        //Saving the data
        PrintWriter myWriter = new PrintWriter("friends.txt");
        
        for(int i = 0; i < data.size(); i++){
            myWriter.println(data.get(i).getName());
            
        }
        
        myWriter.close();
        
    }
}
