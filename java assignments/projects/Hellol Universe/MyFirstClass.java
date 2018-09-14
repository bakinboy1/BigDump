
/**
 * Says Hello Universe
 * 
 * @author Radhouane Chouchane 
 * @version 8/19/2015
 */
public class MyFirstClass
{
    public static void main(String[] args){
        //System.out.print("Hello Universe\n");
        System.out.println("Hello Universe");
        //Declare a variable 
        int x;
        //Assign a value to the variable
        x = 1;
        //declare a variable and then assign a value to it
        int y = 2;        
        int result;        
        result = x + y;
        System.out.println("The result is " + result);
        
        //Decision
        boolean condition = true;
        if(condition == true){
            System.out.println("Your condition is true");
        }
        else{
            System.out.println("Your condition is false");
        }
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
    
}
