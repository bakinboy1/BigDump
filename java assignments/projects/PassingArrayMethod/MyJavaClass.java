
/**
 * My first Java program
 * Major Topics:
 * 
 * 1) Arrays-- Defining an integer array, initializing an integer array, searching an array 
 * 1) Modular Programming -- Java methods Passing an array to a method
 * 
 * 
 * @author Radhouane
 * @version 1/13/2016
 */
import java.util.Scanner;
public class MyJavaClass
{

    public static double arraySearchDemoRecursive(int[] array)  {
        if(array.length == 1) {return array[0];}
        //Base Case
        //Recursive Step
        int[] shorter = new int[array.length -1];
        for(int i = 0; i< shorter.length; i++){
            shorter[i] = array[i+1];  
        }
        return array[0] + arraySearchDemoRecursive(shorter);
    }
    public static double arraySearchDemo(int[] array)  {
        //Add up the elements of the array
        int sum = 0;
        for(int index =0; index < array.length; index++){    
            sum += array[index];              
        }
       
        return sum;
    }
    public static void main(String[] args){
        //Define and initialize an array of integers
         int[] ages = {1,21,35,60,115};
         //Have the helper method process the array
         System.out.println(arraySearchDemo(ages));
    }
}
