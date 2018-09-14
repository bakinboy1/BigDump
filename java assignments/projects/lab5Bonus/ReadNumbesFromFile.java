
/**
 * Write a description of class ReadNumbesFromFile here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.io.*;
import java.util.*;
public class ReadNumbesFromFile
{
 public static void main(String[] args) throws FileNotFoundException{
        ArrayList<Numbers> myValues = new ArrayList<Numbers>();
        try{
            File inputFile = new File("numbers.txt");
            Scanner scan = new Scanner(inputFile);
 
            while(scan.hasNext()){
                
                int number = Integer.parseInt(scan.nextLine());
          
                Numbers p = new Numbers(number);
                myValues.add(p);
                //System.out.println(value);
            }
        }catch(IOException e){
            System.out.println("Sorry could not find data");
        }
        
        for(int i = 0; i < myValues.size(); i++){
            System.out.println(myValues.get(i).toString());
        }

        
        //Process the array list
        //Maybe sort the list or add to it
        
        //Then save back to disk
        PrintWriter mySaver = new PrintWriter("numbers.txt");
        for(int i = 0; i < myValues.size(); i++){
            mySaver.println(myValues.get(i).getNumber()+"\n");
          
        }
        mySaver.close();
        
        
        
        
    }
}
