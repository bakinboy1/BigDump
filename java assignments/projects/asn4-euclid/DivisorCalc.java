
/**
 * finds the greatest common multiple between two numbers recursively.
 * 
 * @author Fabian Hucke
 * @version 12/3/2015
 */

import java.util.Scanner;
public class DivisorCalc{
    /**
     * Finds greatest common multiple between two numbers by checking remainders
     */
    public static int number(int i, int k){
       if (k==0){
           return i;}
       return number(k,i%k);
    }
    /**
     * takes in user input for 2 numbers
     */
    public static void main (String[] args){
    Scanner numbers=new Scanner(System.in);
    System.out.println("type in your first number \n");
    int i=numbers.nextInt();
    System.out.println("type in your second number\n");
    int k=numbers.nextInt();
     
    System.out.println("the largest denominator for these two numbers is: "+ number(i,k));
    }
}
