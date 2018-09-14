
/**
 * Says Hello Universe
 * 
 * @author Radhouane Chouchane 
 * @version 8/19/2015
 */
import java.util.Scanner;
public class MyFirstClass
{
    //Method definition
    public static void forDemo(){
        for(int index = 0; index < 20; index++){
            System.out.println("Hi there. Your position is " + index);
        }
    }
    
    public static void selectionDemo(){
         //Decision
        boolean condition = true;
        if(condition == true){
            System.out.println("Your condition is true");
        }
        else{
            System.out.println("Your condition is false");
        }
        
        int multiCondition = 5;
        Scanner scan = new Scanner(System.in);
        System.out.println("Please a value");
        int value = scan.nextInt();
        
        if(value == multiCondition){
            System.out.println("Your value is equal to " + multiCondition);
        }
        else if(value > multiCondition){
            System.out.println("Your value is greater than " + multiCondition);
        }
        else{
            System.out.println("Your value is less than " + multiCondition);
        }
        
        System.out.println("Please give me a number (between 1 and 5)");
        int value2 = scan.nextInt();
        
        switch(value2){
            case 1:
            System.out.println("Good job. You pressed 1");
            break;
            case 2:
            System.out.println("Bad job. You pressed 2");
            break;
            case 3:
            System.out.println("Good job. Your won the lottery");
            break;
            case 4:
            System.out.println("OK. You got caught");
            break;
            case 5:
            System.out.println("You passed");
            break;
            default:
            System.out.println("Please try again. Need a number between 1 and 5");
        }
    }
    public static void whileDemo(int x){
        
        //Looping
        //Pre-test
        while(x < 10){
            System.out.println("x is: " + x);
            //x += 1;
            //x = x + 1;
            //The increment operator
            x++;
        }
        //Post-test
        do{
            //The decrement operator
            x--;
            System.out.println("x is: " + x);
        }while(x > 0);
    }
    
    public static int factorialDemo(int n){
        int result = 1;
        //Iteration
        for(int i = 1; i <= n; i++){
            result = result * i;
        }
        
        return result;
    }
    public static int recursiveFactorialDemo(int n){
        if(n==1) return 1; //Base Case
        return recursiveFactorialDemo(n-1) * n;//Recursive Step
    }
    /**
     * @precondition n is a power of two
     */
    public static int recursivePowerOfTwoDemo(int n){
        if(n == 2) return 1;//Base case
        return recursivePowerOfTwoDemo(n/2) + 1;
    }
    
    public static boolean recursiveSearch(int[] myArray, int searchNbr, int current){
        if(searchNbr == myArray[current]) return true;
        if(current == myArray.length-1){
            return false;
        }
        else{
            return recursiveSearch(myArray, searchNbr, current+1);
        }
    }
    public static void main(String[] args){
        //System.out.print("Hello Universe\n");
        //System.out.println("Hello Universe");
        
        //System.out.println(factorialDemo(6));
        System.out.println(recursiveFactorialDemo(6));
        System.out.println(recursivePowerOfTwoDemo(32));
        
        int[] workingArray = {4, 6, -7, 45, 100, 1, 2};
        System.out.println(recursiveSearch(workingArray, 62, 0));
        //whileDemo(20);
        //Method call
        //forDemo();
        //Declare a variable 
        //int x;
        //Assign a value to the variable
        //x = 1;
        //declare a variable and then assign a value to it
        //int y = 2;        
        //int result;        
        //result = x + y;
        //System.out.println("The result is " + result);   
        
    }
    
}
