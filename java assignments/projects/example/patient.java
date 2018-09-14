
/**
 * Write a description of class patient here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class patient
{
   
    private String name;
    public void setName(String name){
        this.name=name;
    }
    public String getName(){
        return name;
    }
    private int age;
    public void setAge(int age){
        if (age>0){
        this.age=age;
    }
    }
    public int getAge(){
        return age;
    }
    private double weight;
    public void setWeight(double weight){
        if (weight>0){
        this.weight=weight;
    }
    }
    public double getWeight(){
        return weight;
    }
}
