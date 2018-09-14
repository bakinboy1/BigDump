
/**
 * Write a description of class FirstNameComparator here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;

public class FirstNameComparator implements Comparator<Student>
{
    //order students a-z first name basis
    @Override
    public int compare(Student f1, Student f2){
            return f1.getFirstName().compareToIgnoreCase(f2.getFirstName());
}
}
