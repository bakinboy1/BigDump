
/**
 * Write a description of class Lab6Excercise here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class Lab6Excercise
{
    String[] first={"Rick","Morty","Moriarty","Samus","Promethius","Geiger","Moriarti","Bob","Taco",
            "Asparagus","Shoes","Potato","Dirty","Dan","Spongebob","Space","Nova","Illadin","Orange","Electron"};

    String[] last={"PoopyButthole","Red","Mantis","Toboggan","Oak","Elm","Dumbledore","Potter","Spice","Toothbrush","Argon",
            "Blitz","LazerWolf","Mc-BigMac","King","Queen","Spork","Petrolium","Apple","Trash"};

    //no syntax errors if set to static, but prints out null for everything.
    //problem here or in calling array to print?

    public static Student[] studentArr= new Student[20];
    public Lab6Excercise(){
        initializeArray();
    }

    public void initializeArray(){
        for (int i = 0; i < studentArr.length; i++){
            //this one seems correct but it cant find the symbol method- setStudentID etc. methods
            // online it said to try (Student)studentArr.setStudentID(id())
            //which explicitely casts it

            //seems to work
            //http://stackoverflow.com/questions/29328569/setting-values-to-an-array-of-objects
            studentArr[i]= new Student();
            studentArr[i].setStudentID(id());
            studentArr[i].setFirstName(First());
            studentArr[i].setLastName(Last());
            studentArr[i].setGrade(Grades());

            //other way?probably wrong
            //studentArr[i]= new Student(studentArr.id(),
            //studentArr.First(),
            //studentArr.Last(),
            //studentArr.Grades());
        }
    }

    public Student[] getStudentArr(){
        return studentArr;
    }
    //do i even need this?
    //public Lab6Excercise getLab(){
    //    return lab;
    //}
    
        
        
    
    



    public static void main(String[] args){
        //randomly generate double grade, student id;
        //create 2 arrays, first name, last name. pull randomly for name generation

        //necessary? 
        Lab6Excercise lab= new Lab6Excercise();
        
        //prints out hash or something
        //System.out.println(lab.studentArr.toString());
        //prints out nulls
        //    System.out.println(Arrays.deepToString(studentArr));
        
        
        
            
        for(int i=0; i<studentArr.length; i++){
            System.out.println(studentArr[i]);
        }    
        Arrays.sort(studentArr, new FirstNameComparator());
        for(int i=0; i<studentArr.length; i++){
            System.out.println(studentArr[i]);
        }    
        Arrays.sort(studentArr, new GradeComparator());
        for(int i=0; i<studentArr.length; i++){
            System.out.println(studentArr[i]);
        }    
        Arrays.sort(studentArr, new LastNameComparator());
        for(int i=0; i<studentArr.length; i++){
            System.out.println(studentArr[i]);
        }    
       
    }
    
    public int id(){
        int ID=1+(int)(Math.random()*((100-1)+1)); 
        return ID;
    }

    public String First(){
        Random random= new Random();
        int index= random.nextInt(first.length);
        return first[index];
    }

    public String Last(){
        Random random= new Random();
        int index= random.nextInt(last.length);
        return last[index];
    }

    public double Grades(){
        double grade=0+(double)(Math.random()*((4-1)+1));
        double roundoff= (double)Math.round(grade*100)/100;
        return roundoff;
    }
}
