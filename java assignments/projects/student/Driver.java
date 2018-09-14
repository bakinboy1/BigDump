
/**
 * Write a description of class Driver here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Driver
{
   public static void main(String[] args){
    Student[] studentArr= new Student[4];
    
    studentArr[0]=(new Student("jay",9));
    studentArr[1]=(new Student("ray",2));
    studentArr[2]=(new Student("spork",12));
    studentArr[3]=(new Student("blue",33));
    
    sorting.selectionSort(studentArr);
    System.out.println(studentArr);
    }
}
