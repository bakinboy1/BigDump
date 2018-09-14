
/**
 * Write a description of class MyJavaClass here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.Scanner;
public class MyJavaClass
{
    public static void beNice(){
        System.out.println("hello");
    }
    public static void normalCalc(){
    double i, j, result, difference, product, quotient, remainder;
    i=7;
    j=2;
    
    result=i+j;
    difference=i-j;
    product=i*j;
    quotient=i/j;
    remainder=i%j;
    
    System.out.println("result = "+ result);
    System.out.println("i = "+ i);
    System.out.println("j = "+ j);
    System.out.println("\n difference = "+ difference);
    System.out.println("product = "+ product);
    System.out.println("quotient = "+ quotient);
    System.out.println("remainder = "+ remainder);
    
    i++;
    System.out.println("i= "+i);
    i--;
    System.out.println("i= "+i);
    }
    public static void arrayDemo(){
        int[] myArray={3,7,-4,0,10,14};
    System.out.println("\n element at index 0 = "+ myArray[0]);
    for (int index=0; index<5; index++){
        if (myArray[index]>5){
        System.out.println("element at index" + index+" = "+myArray[index]);
    }
    }
    }
   public static void main (String[] args){
    int userChoice=0;
       Scanner input=new Scanner(System.in);
    while (userChoice!=string){
    
        System.out.println("hello, please enter a number, or press 1 to quit");
    userChoice=input.nextInt();
       
    if (userChoice==0){
           beNice();
           
    }
    if (userChoice<5){
        normalCalc();
        
        }
    if (userChoice>5){
        arrayDemo();
        
    }
    if (userChoice==1){
           System.exit();
    }
    else {
        System.out.println("sorry, you must input an integer \n");
           System.out.println("hello, please enter a number, or press 1 to quit");
    userChoice=input.nextInt();
    }
}
    
    }
}

