
/**
 * Write a description of class Person here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Person
{
    String name;
    int age;
    String address;
    double income;
    boolean isMarried;
    public Person(){
        name="Joe Darth";
        age=45;
        address="Death Star";
        income=145265.00;
        isMarried=false;
       
    }
    public String getName(){
        return name;
    }
    //Void means no values are returned
    public void  setName(String newName){
        name=newName;
    }
    public String getAddress(){
        return address;
    }
    public int getAge(){
        return age;
    }
    public double getIncome(){
        return income;
    }
    public boolean getIsMarried(){
        return isMarried;
    }
    public String toString(){
        return name+"\n"+age+"\n"+address+"\n"+income+"\n"+isMarried;
    }
}
