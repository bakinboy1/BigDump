/**
 * Student is a *subclass* of Person
 * This means that Person is the *superclass*
 * Of Student
 * @author Radhouane 
 * @version 2/26/2016
 */
public class Student extends Person
{
    //Instance variable
    private int studentID;
    
    public Student(){
        
        setStudentID(1);
        age =18;
    }
    //Its only job is to initialize the instance variables
    public Student(String newName, int newAge, 
                 String newAddress, double newIncome, 
                 boolean newIsMarried, int newstudentID){
              
            //shortcut (for superclsss to self-construct)
            super(newName, newAge, 
                 newAddress, newIncome, 
                  newIsMarried);
            setStudentID(newstudentID);
    }
    public int getStudentID(){
        return studentID;
    }
     
    public void setStudentID(int newStudentID){
        studentID = newStudentID;
    }
    //Method overriding
    public String toString(){
        return super.toString() +"\nID is " + studentID;
    }
    
    
}
