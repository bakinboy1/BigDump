
/**
 * Defines a user-defined data type. Must be a singular noun from the problem domain.
 * 
 * This class *by default* extends Object.
 * @author Radhouane
 * @version 1/29/2016
 */
//This one extends the Object class
public class Person
{
    //Features a.k.a. attributes of a person
    //Data members
    //instance variables
    private String name; 
    //This one is protected. Only the subclass
    //has direct access to it
    
    //Default Constructor
    //Its only job is to initialize the instance variables
    public Person(){
        name = "Joe Darth";
       
    }
    //Custom Constructor
    //Its only job is to initialize the instance variables
    public Person(String newName){
        name = newName;
        
    }
    //Mechanism for showing the name
    //accessor/getter
    public String getName(){
        return name;
    }
    //Mechanism for changing the name
    //Setter/Mutator
    public void setName(String newName){
        name = newName;
    }
    
    //Returns a textual description of a Person object
    public String toString(){
        return  name + "\n";
    }
    
}
