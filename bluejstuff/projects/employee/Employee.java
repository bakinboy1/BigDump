
/**
 * Write a description of class Employee here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public abstract class Employee
{
  protected String name;
  protected int number;
  public void setName(String newName){
    name=newName;
    }
  public String getName(){
    return name;
    }
  public abstract void printDescription();
    
    
    
}
