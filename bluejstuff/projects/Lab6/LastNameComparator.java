
/**
 * Write a description of class LastNameComparator here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class LastNameComparator implements Comparator<Student>
{
    //order students by last name first to last
    //after names have been alphabetically ordered, 
    //order identical last names by gpa
    @Override
    public int compare(Student o1, Student o2){
            //return l1.getLastName().compareToIgnoreCase(l2.getLastName());
            String s1=((Student) o1).getLastName();
            String s2=((Student) o2).getLastName();
            int s= s1.compareTo(s2);
            if(s!=0){
                return s;
            }
            else{
                Double ss1=((Student)o1).getGrade();
                Double ss2=((Student)o2).getGrade();
                return ss1.compareTo(ss2);
            }
}
        
      
}
