
/**
 * Tests the Student class
 * 
 * @author Radhouane 
 * @version  10/7/2015
 */
public class StudentTester
{
   public static void main(String[] args){
       Student s1 = new Student();
       s1.setGPA(2.6);
       Student s2 = new Student();
       s2.setName("Luke");
       
       TeachingAssistant ta = new TeachingAssistant();
       System.out.println(ta.toString());
       ta.setGPA(2.8);
    }
}
