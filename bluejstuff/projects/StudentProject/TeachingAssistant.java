
/**
 * This is a Subclass of class Student
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class TeachingAssistant extends Student
{
    private String classTaught;
    private String facultyMentor;
    
    public TeachingAssistant(){
        setClassTaught("CPSC 1302");
        setFacultyMentor("R2D2");
    }
    public void setClassTaught(String classTaught){
        this.classTaught=classTaught;
    }
    public void setfacultyMentor(String facultyMentor){
        this.facultyMentor=facultyMentor;
    }
    public String toString(){
        return "name: " +getName()+"
    }
}

