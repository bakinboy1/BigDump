
/**
 * Tests the Person class
 * 
 * @author Radhouane
 * @version 1/29/2016
 */
import java.util.Scanner;
public class TestPrivacy
{
   public static void main(String[] args){
       //Create a Person object
       //a.k.a. Instantiate a Person object
       //Construct a Person object
       Person p1 = new Person();

       System.out.println("Here is P1 before mutation:");
       System.out.println(p1.toString());
       //Want to change the age to under 21
       //Not allowed, since age is private
       //p1.age = 17;
       p1.setAge(4);
       System.out.println(p1.getName());
       System.out.println("Here is P1 after mutation:");
       System.out.println(p1.toString());
      
      
    }
}
