
/**
 * Write a description of class StudentTester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class StudentTester
{
    public static void main(String[] args){
        Student s1 = new Student();
        //We are able to treat a student object as a person object
        s1.getName();
        //We are able to add our own services
        s1.getStudentID();
        System.out.println(s1.toString());
        Student s2 = new Student("Sherlock Holmes", 35, "London", 100.0, false, 007);
    }
}
