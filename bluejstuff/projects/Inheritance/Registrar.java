
/**
 * Helps with student registration
 * 
 * @author Radhouane
 * @version 3/4/2016
 */
import java.util.Scanner;
import java.util.ArrayList;
public class Registrar
{
    public static void showInventory(Student[] arr){
        //Show inventory
        for(int index = 0; index < arr.length;index++){
            System.out.println("========="+index+"==========");
            System.out.println(arr[index].toString());
            
        }
    }
    
    public static void changeName(Student[] arr){
        System.out.println("Which student record are looking for");
        Scanner scan = new Scanner (System.in);
        int choice = Integer.parseInt(scan.nextLine());
        
        for(int index = 0; index < arr.length;index++){
            if(index == choice){
              System.out.println(arr[index].toString());
              arr[index].setName("Kenny McCormick");
              System.out.println("========="+index+"==========");
              System.out.println(arr[index].toString());
            }
        }
    }
    //This method will accept
    //An array of *any type*
    //As long as it *is a * Person
    public static void showAges(Person[] ar){
        //Show ages
        for(int index = 0; index < ar.length;index++){
            System.out.println("========="+index+"==========");
            System.out.println(ar[index].getName() + " "+ar[index].getAge());
            
        }
    }
    
    //This method will accept
    //An array list of *any type*
    //As long as it *is a * Person
    public static void showAges(ArrayList<Person> ar1){
        //Show ages
        for(int index = 0; index < ar1.size();index++){
            System.out.println("========="+index+"==========");
            System.out.println(ar1.get(index).getName() + " "+ar1.get(index).getAge());
            
        }
    }
    public static void main(String[] args){
        Student[] students = new Student[25];
        //Populate your array
        for(int index = 0; index < students.length;index++){
            students[index] = new Student();
        }
        //menu
        showInventory(students);
        changeName(students);
        
        //Let's make things convenient
        //An array of type the superclass
        //holds elments of type the subclasses
        Person[] persons = new Person[10];
        persons[0] = new Person();
        persons[1] = new Student();
        
        showAges(persons);
        showAges(students);
        //Let's make things even more convenient
        //Instantiate an array list
        //Empty at the beginning
        //Do not have to commit to a asize
        ArrayList<Person> personsMoreFun = new ArrayList<Person>();
        personsMoreFun.add(new Person());
        personsMoreFun.add(new Person());
        personsMoreFun.add(new Person());
        personsMoreFun.add(new Person());
        
        
    }
}
