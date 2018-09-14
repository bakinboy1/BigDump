import java.util.*;

public class GradeComparator implements Comparator<Student>
{
    public int compare(Student a, Student b)
    {
        return Double.compare(a.getGpa(), b.getGpa());
    }
}
        