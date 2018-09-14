
/**
 * This main method is used by the company to test the required behaviors
 * for your job interview. They only need to change the first line to test what you have.
 * 
 * @author Columbus,GA Company
 * @version 4/4/2016
 */
import java.util.Scanner;
public class CompanyTester
{
   public static void main(String[] args){
       RequiredBehaviors obj = new FabianRecursiveImplementation();
       
       //The job interviewer will be using the below code
       //to test your class.
       Scanner scan = new Scanner(System.in);
       
       System.out.println("Enter a positive integer to test the applicant's factorial: ");
       int choice = Integer.parseInt(scan.nextLine());
       System.out.println("Factorial is : " + obj.factorial(choice));
       
       System.out.println("Enter a String to test the applicant's search function: ");
       String word = scan.nextLine();
       System.out.println("What char are you looking for: ");
       char c = scan.nextLine().charAt(0);
       System.out.println(" This char occurs " + obj.nbrOccurrences(word, c) + " times.");
       
       System.out.println("Enter a positive integer to test the applicant's isEven method: ");
       int nbr = Integer.parseInt(scan.nextLine());
       System.out.println("The applicant says that isEven(nbr) is " + obj.isEven(nbr));
       
       int[] testData = {8, 458, 13, 45, 12, 16, 13, 78, 100, 1, 46, 22};
       System.out.println("Enter a threshold to test the applicant's sumUpper method: ");
       int thresh = Integer.parseInt(scan.nextLine());
       System.out.println("The applicant says that the numbers above this thresh add up to " + obj.sumUpper(testData, thresh));
   }
}
