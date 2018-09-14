
/**
 * Defines a Student *data type*
 * 
 * A class name must be a *noun* from the problem domain
 * Must start with an upper case letter (by convention)
 * 
 * @author Radhouane Chouchane
 * @version 10/5/2015
 */
public class Student
{
    //attributes of the data type
    //a.k.a. features
    //a.k.a. instance variables
    private int id;
    private String name;
    private double gpa;
    //not counted as variable as the rest
    //STATIC means it's a CLASS variable not an INSTANCE variable
    // only 1 copy of this variable exists, instead of 3 different ones for the others
    //which is available for everybody to see
    static double jackpot;
    //Superclasses and subclasses
    //student is a superclass and teaching assistant is a subclass
    //teaching assistant IS A student.
    /**
     * Default* Constructor
     * A Constructor for the Student class
     * Its only job is to assign values to the instance variables
     * Will make id == 909 name == "Frank" gpa == 3.5
     */
    public Student(){
        setID(909);
        setName("Frank");
        setGPA(3.5);
    }
    public void setName (String name){
    this.name=name;
    }
    public void setID(int id){
    assert id>0;
    this.id=id;
    }
    /**
     * Custom Constructor
     * A Constructor for the Student class
     * Its only job is to assign values to the instance variables
     * 
     * @param id The ID that we want for this Student object
     * @param name The name that we want for this Student object 
     * @param gpa The gpa that we want for this Student object
     * 
     */
    public Student(int id, String name, 
                 double gpa){
        setID(id);
        setName(name);
        setGPA(gpa);
    }
    /**
     * *Public* interface of the class:
     * A set of public methods that we can invoke on objects 
     * to request services.
     * 
     */
    
    /**
     * This is a set() method
     * It is a *mutator* because it changes the value of an instance variable
     * Assigns the value of the argument to the 'name' instance variable     
     * 
     * @param name The name that we want for this Student object 
     *
     */
    public void setName(String name){
        
        this.name = name;
    }
    /**
     * This is a set() method
     * It is a *mutator* because it changes the value of an instance variable
     * Assigns the value of the argument to the 'id' instance variable     
     * 
     * @param id The id that we want for this Student object 
     *
     */
    public void setID(int id){
        this.id = id;
    }
    /**
     * 
     * 
     * 
     */
    public void playWithID(int id){
        id = 1000; //<-- This statement assigns 1000 to the argument 'id' but not the instance variable 'id' defined above
        //this.id = 1000; <-- This statement assigns 1000 to the instance variable
        //this.id = id;//<-- This statement does the same work as setID() does
    }
    /**
     * This is a set() method
     * It is a *mutator* because it might change the value of an instance variable
     * Assigns the value of the argument to the 'gpa' instance variable under *precondition*    
     * Here we are illustrating Programming By Contract
     * 
     * @param gpa The gp that we want for this Student object 
     * @precondition (0.0 <= gpa <= 4.0)
     */
    public void setGPA(double gpa){
        //Input Validation
        assert gpa >= 0 && gpa <= 4;
        this.gpa = gpa;
        

    }
    public void addToJackpot(double money){
        jackpot = jackpot + money;

    }
    public double getJackpot(){
        return jackpot;

    }

   
    /**
     * This is an *accessor* method, because it reads the value of an instance variable.
     * This is a get() method. Will return the current name of this Student Object
     * 
     * @return Returns the current name of this Student object
     */
    public String getName(){
        return name;
    }
    
     /**
     * This is an *accessor* method, because it reads the value of an instance variable.
     * This is a get() method. Will return the current ID of this Student Object
     * 
     * @return Returns the current ID of this Student object
     */
    public int getID(){
        return id;
    }
    
   
     /**
     * This is an *accessor* method, because it reads the value of an instance variable.
     * This is a get() method. Will return the current GPA of this Student Object
     * 
     * @return Returns the current GPA of this Student object
     */
    public double getGPA(){
        return gpa;
    }
    
   
     /**
     * This is an *accessor* method, because it reads the value of an instance variable.
     * Will return a textual description of this Student Object
     * 
     * @return Returns a textual description of this Student Object
     */
    public String toString(){
        String s = "Student name: " + getName() + " ID: " + getID() + " GPA: "+ getGPA() + " Jackpot: " + jackpot;
        return s;
    }
    
    
}
