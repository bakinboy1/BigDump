
/**
 * Tests the Student data type
 * 
 * @author Radhouane Chouchane
 * @version 10/5/2015
 */
public class StudentTester
{
    public static void main(String[] args){
        /**
         * Instantiating an object of type Student
         * a.k.a. constructing
         */
        System.out.println("This program illustrates a major difference between static variables and instance variables");
        
        Student s1 = new Student();
        
        
        System.out.println(s1.toString());
        s1.setID(7);
        s1.setName("Kenny");
        s1.setGPA(4.0);
        System.out.println(s1);
        
        Student s2 = new Student(1, "Luke Skywalker", 3.5);
        System.out.println(s2);
        
        Student s3 = new Student(2, "Jenny", 3.6);
        System.out.println(s3);
        System.out.println();
        
        //Now these three students will each add money to the jackpot
        //The 'jackpot' variable has been declared as static, so
        //this Jackpot variable is shared by these three students
        //Think of this variabel as a pot of money that is shared
        //by these three students. 
        
       System.out.println("Now let us see what these three students see inside of Jackpot");
      
       System.out.println("s1 sees: " + s1.getJackpot());
       System.out.println("s2 sees: " + s2.getJackpot());
       System.out.println("s3 sees: " + s3.getJackpot());
       
       System.out.println("Now s1 will add $100 to 'jackpot'");
       s1.addToJackpot(100);
       
       System.out.println("Now let us see what these three students see inside of Jackpot");
       System.out.println("s1 sees: " + s1.getJackpot());
       System.out.println("s2 sees: " + s2.getJackpot());
       System.out.println("s3 sees: " + s3.getJackpot());
       
      System.out.println("Now s3 will add $25 to 'jackpot'");
       s3.addToJackpot(25);
       
       System.out.println("Now let us see what these three students see inside of Jackpot");
       System.out.println("s1 sees: " + s1.getJackpot());
       System.out.println("s2 sees: " + s2.getJackpot());
       System.out.println("s3 sees: " + s3.getJackpot());
       
       System.out.println("So we now know that the jackpot variable is shared. \n If one student changes it, the change will be see by all of the other students.");
       System.out.println("This makes jackpot much different than 'id' and the other instance variables of Student.");
       System.out.println("Each student has his/her own copy of 'id' (so they can mutate it independently) but they have to share a single copy/instance of 'jackpot'");
    }
}
