
/**
 * Tests the Person class
 * 
 * @author Radhouane
 * @version 1/29/2016
 */
import java.util.Scanner;
public class PersonTester
{
   public static void main(String[] args){
       //Create a Person object
       //a.k.a. Instantiate a Person object
       //Construct a Person object
       Person p1 = new Person();

       System.out.println("Here is P1:");
       System.out.println(p1.getName());
       
       Person p2 = new Person();
       System.out.println("Here is P2:");
       System.out.println(p2.toString());
       
       System.out.println("Here is P3:");
       Person p3 = new Person("Leah", 35, "Earth", 100000.00, true);
       System.out.println(p3.toString());
       
       System.out.println("Here is P4:");
       Person p4 = new Person("Chewey", 200, "Up There", 1.00, true);
       System.out.println(p4.toString());
       
       //Change it up
       p2.setName("John Solo");
       System.out.println(p2.toString());
       p1.setName("Java the Hut");
       System.out.println(p1.toString());
       
       //Array Declaration + instantiation
       Person[] people = new Person[4]; 
       people[0] = new Person("Leah1", 35, "Earth", 1200.00, true);
       people[1] = new Person("Leah2", 35, "Alderon", 5.00, true);
       people[2] = new Person("Leah3", 35, "Earth", 100000.00, true);
       people[3] = new Person("Leah4", 35, "Earth", 1.00, true);
                  
       for(int index =0; index < people.length; index++){    
            System.out.println("element at index "+ index+" = " 
                        + people[index]);     
      }
      //Filter people by income
      System.out.println("Give me a threshold on income so I can filter");
      Scanner scan = new Scanner (System.in);
      double choice = Double.parseDouble(scan.nextLine());
       for(int index =0; index < people.length; index++){
           if( people[index].getIncome() > choice){
            System.out.println("element at index "+ index+" = " 
                        + people[index]);     
           }
      }
      System.out.println("Give me an address so I can filter");
      String adrChoice = scan.nextLine();
      for(int index =0; index < people.length; index++){
          //use .equals() to compare Strings
          //== does not work
           if(adrChoice.equalsIgnoreCase( people[index].getAddress())){
            System.out.println("element at index "+ index+" = " 
                        + people[index]);     
           }  
           
        
      }
      
      
      
    }
}
