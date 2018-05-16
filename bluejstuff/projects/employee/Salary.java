
/**
 * Write a description of class Salary here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Salary extends Employee
{
    protected int Salary;
    public void printDescription(){
        System.out.println("name: "+ name +"number: "+number+"salary:"+ Salary);
    }
    public void setSalary( int newSalary){
    Salary=newSalary;
    }
    public int getSalary(){
    return Salary;
    }
    public Salary (String name,int number,int salary){
        setSalary(Salary);
    }
}
