
/**
 * Write a description of class Numbers here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Numbers
{
  private int number;
  
  public Numbers(){
    setNumber(0);
    }
    public Numbers(int newNumber){
    setNumber(newNumber);
    }
    public void setNumber(int newNumber){
    number=newNumber;
    }
    public int getNumber(){
    return number;
    }
    public String toString(){
    return number + "\n";
    }
}
