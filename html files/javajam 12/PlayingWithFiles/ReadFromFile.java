import java.io.*;
import java.util.*;
/**
 * @author Julie Tran
 * @version 5/2/2016
 */
public class ReadFromFile
{
    public static void main(String[] args) throws FileNotFoundException{
        ArrayList<Integer> myValues = new ArrayList<Integer>();
        try{
            File inputFile = new File("myData.txt");
            Scanner scan = new Scanner(inputFile);

            while(scan.hasNext()){
                int value = Integer.parseInt(scan.nextLine());

                myValues.add(value);
                //System.out.println(value);
            }
        }catch(IOException e){
            System.out.println("Sorry could not find myData.txt");
        }
        System.out.println("Array list before sorting");
        for(int i = 0; i < myValues.size(); i++){
            System.out.print(myValues.get(i) + " ");
        }
        System.out.println();

        //Process the array list
        //Maybe sort the list or add to it
        //Bubble sort
        for(int bubble = 1; bubble <= myValues.size(); bubble++){
            for(int i = 0; i < myValues.size() - 1; i++){
                if(myValues.get(i) > myValues.get(i+1)){
                    Integer temp = myValues.get(i);
                    myValues.set(i, myValues.get(i+1));
                    myValues.set(i+1, temp);
                }
            }
        }
        System.out.println("Array list after sorting");
        for(int i = 0; i < myValues.size(); i++){
            System.out.print(myValues.get(i) + " ");
        }
        System.out.println();
        //Then save back to disk
//         PrintWriter mySaver = new PrintWriter("myData.txt");
//         for(int i = 0; i < myValues.size(); i++){
//             mySaver.println(myValues.get(i));
//         }
//         mySaver.close();

        
    }
}
