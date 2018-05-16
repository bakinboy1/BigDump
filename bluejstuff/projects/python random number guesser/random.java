
/**
 * Write a description of class random here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

//copy of tutorial, explination comments needed 
import java.util.Random;
import java.util.Scanner;
public class random{
    public static void main( String args[]) {
        Scanner scan = new Scanner(System.in);
        Random generator = new Random();
        
        final int Max = 100;
        int answer, guess, attempts;
        attempts=0;
        String another = "y";
        boolean flag = false;
        boolean anotherFlag= true;
        
        while(anotherFlag){
            answer = generator.nextInt(Max) + 1;
            System.out.println("enter your guess: ");
            flag = false;
            while(!flag){
                guess = scan.nextInt();
                attempts++;
                
                if(guess==answer){
                    System.out.println("you guessed correctly!");
                    flag = true;
                }
                if (guess>answer){
                        System.out.println("your guess is too high, try again. You have " + (10 - attempts) + " attempts remaining");
                }
                    
                if(guess<answer){
                        System.out.println("your guess is too low, try again. You have " + (10 - attempts) + " attempts remaining");
                }
                    
                if(attempts>9){
                        System.out.println("You've guessed the maximum amount of times. Game over");
                    
                }
            }
            System.out.println("\nWould you like to play again? (y/n)");
            another = scan.next();
            if(another.equalsIgnoreCase("y") == true){
                anotherFlag = true;
                attempts=0;
            }
            else{
                anotherFlag = false;
                System.exit(0);
                
            }
            
        }
}
} 
