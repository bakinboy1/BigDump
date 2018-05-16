
/**
 * Write a description of class PersonTester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class PersonTester
{
    public static void main (String[] args){
        Person p1= new Person();
        System.out.println(p1.toString());
        Person p2= new Person();
        p2.setName("joe");
        System.out.println(p2.toString());
    }
}
