
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

public class ReadFromFile
{
    public static void main(String[] arg) throws FileNotFoundException
    {
        ArrayList<Integer> data = new ArrayList<Integer>();
        //try-catch blocks for exception handling
        try{
            //Set up a file object
            File myFile = new File("friends.txt");
            //Set up a scanner for that file 
            Scanner scan = new Scanner(myFile);     

          

        } catch(IOException e){
            System.out.println("The file called friends was nout found!!");
        }

        for(int i = 0; i < data.size(); i++){
            System.out.println(data.get(i));
        }
        //Sort the array list

        for(int bubble = 1; bubble <=data.size(); bubble++){

            for(int i = 0; i < data.size()-1; i++){
                if(data.get(i)>data.get(i+1)){
                    Integer temp = data.get(i);
                    data.set(i, data.get(i+1));
                    data.set(i+1, temp);
                }
            }
        }
        
        //Remove element at index choice
        Scanner scankeyboard = new Scanner(System.in);
        System.out.println("Which one to remove?");
        int choice = Integer.parseInt(scankeyboard.nextLine());
        data.remove(choice);
        
        
        //Saving the data
        PrintWriter myWriter = new PrintWriter("friends.txt");

        for(int i = 0; i < data.size(); i++){
            myWriter.println(data.get(i));
        }

        myWriter.close();

    }
}
