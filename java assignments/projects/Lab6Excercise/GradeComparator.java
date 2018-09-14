
/**
 * Write a description of class GradeComparator here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;

class GradeComparator implements Comparator<Student>
{
    @Override
    //order students by grade
   public int compare(Student num1, Student num2){
            if (num1.getGrade()>num2.getGrade()){
                return 1;
            }
            if (num1.getGrade()<num2.getGrade()){
                return -1;
            }
            else{
                return 0;
            }
        }
}
