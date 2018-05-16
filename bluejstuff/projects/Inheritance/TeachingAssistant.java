
/**
 * Extends class Student
 * 
 * @author Radhouane  
 * @version 10/07/2015
 */
public class TeachingAssistant extends Student
{
    private String classTaught;
    private String facultyMentor;
    
    public TeachingAssistant(){
        
        setClassTaught("CPSC 1302");
        setFacultyMentor("R2 D2");
        setName("Darth Vader");
    }
    //Method overriding
    public void setGPA(boolean gpa){
        assert gpa > 3.5;
        super.setGPA(gpa);
    }
    public void setClassTaught(String classTaught){
        this.classTaught = classTaught;
    }
    public void setFacultyMentor(String facultyMentor){
        this.facultyMentor = facultyMentor;
    }
    
     public String toString(){
        return super.toString() + 
               "\nClass taught" + classTaught +
               "\nFaculty mentor" + facultyMentor;
    }
}
