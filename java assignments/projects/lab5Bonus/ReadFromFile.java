
/**
 * Write a description of class ReadFromFile here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.io.*;
import java.util.*;
public class ReadFromFile
{
    public static void main (String[] args) throws FileNotFoundException{
        ArrayList<Integer> myValues= new ArrayList<Integer>();
        try{
            File inputFile= new File ("numbers.txt");
            Scanner scan= new Scanner(inputFile);
            while(scan.hasNext()){
            int value= Integer.parseInt(scan.nextLine());
            myValues.add(value);
            
            }
        }
        catch(IOException e){
        System.out.println("file could not be found");
        }
        for(int i=0; i<myValues.size(); i++){
            
            System.out.print(myValues.get(i)+" ");
        
        }
        
        System.out.println();
        
        PrintWriter mySaver= new PrintWriter("numbers.txt");
        for (int bubble=1; bubble<=myValues.size(); bubble++){
        for (int i=0; i< myValues.size()-1; i++){
        if (myValues.get(i)>myValues.get(i+1)){
        Integer temp= myValues.get(i);
        myValues.set(i, myValues.get(i+1));
        myValues.set(i+1, temp);
        }
        }
        }
        Scanner scan= new Scanner(System.in);
        System.out.println("remove");
        int choice= Integer.parseInt(scan.nextLine());
        myValues.remove(choice);
        
        PrintWriter myWriter= new PrintWriter("numbers.txt");
        
        for(int i=0; i<myValues.size(); i++){
            mySaver.println(myValues.get(i)+"\n");
        }
        
        mySaver.close();
    }
}
