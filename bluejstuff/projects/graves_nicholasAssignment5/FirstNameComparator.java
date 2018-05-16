import java.util.*;
public class FirstNameComparator implements Comparator<Student>
{
    public int compare(Student a, Student b)
    {
        return (a.getFirstName().compareTo(b.getFirstName()));
    }
}