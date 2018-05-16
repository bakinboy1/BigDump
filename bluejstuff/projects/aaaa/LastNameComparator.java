import java.util.*;
public class LastNameComparator implements Comparator <Student>
{
    public int compare(Student a, Student b)
    {
        if (a.getLastName().equals(b.getLastName()))
        {
            GradeComparator comp = new GradeComparator();
            int result = comp.compare(a, b);
            return result * -1;
        }
        else
        {
            return a.getLastName().compareTo(b.getLastName());
        }
        
    }
}
