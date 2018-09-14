
/**
 * Write a description of class Lab6Excercise here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Lab6Excercise
{
    public static void main(String[] args){
        //create 2 arrays. one first one last name. randomly generated
        ArrayList<Student> first= new ArrayList<Student>();
        Student a= new Student(1,"a");
        Student b= new Student(2,"b");
        Student c= new Student(3,"c"); 
        first.add(a); 
        first.add(b);
        first.add(c); 
        System.out.println(seqSearch(students, a));
        
        
    }
}
