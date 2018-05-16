
/**
 * Write a description of class main here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class main{
    public static void main(String[] args){
    patient p1= new patient();
    p1.setName("jim");
    p1.setAge(33);
    p1.setWeight(180.5);
    
    patient p2=new patient();
    p2.setName("crap");
    p2.setAge(23);
    p2.setWeight(111.1);
    System.out.println(p1.getName());
    System.out.println(p2.getWeight());
    }
}
