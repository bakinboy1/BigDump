
/**
 * Write a description of class Tester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Contacts
{
    // instance variables - replace the example below with your own
    private String name;
    private int number;
    private int ID;
    
    
    public Contacts(){
    
        setName("John Smith");
        setNumber(706);
        setID(589);
        
        
    }
    
    public Contacts(String newName, int newNumber, int newID){
    
        setName(newName);
        setNumber(newNumber);
        setID(newID);
    
    }
    
    public void setName(String newName){
    
        name = newName;
    }
    
    public void setNumber(int newNumber){
        number = newNumber;
    
    }
    
    public void setID(int newID){
        ID = newID;
    }
    
    public String getName(){
        return name;
    }
    public int getNumber(){
        return number;    
    }
    
    public int getID(){
        return ID;
    }
    
    public String toString(){
    
        return name+ "\n" + number + "\n" + ID;
    }
}
