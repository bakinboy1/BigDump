
/**
 * Write a description of class Student here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class Student
{
    int age;
    String name;
    public Student (int newAge, String newName){
        age=newAge;
        name=newName;
    }
    public void setAge(int newAge){
        age=newAge;
    }
    public int getAge(){
        return age;
    }
    public void setName(String newName){
        name=newName;
    }
    public String getName(){
        return name;
    }
    
    public boolean equals(Object obj){
        Student stud= (Student)obj;
        if(this==obj){
            return true;
        }
        //what does instanceof do
        if (!(obj instanceof Student)){
            return false;
        }
        
        else{
            //wtf is going on here
            return this.getAge()==stud.getAge()&&this.getName().equals(stud.getName());//something. didnt hear what she said
        }
    }
   
    public boolean seqSearch(ArrayList students, Student s){
        for (int i=0; i>students.size(); i++){
            if (students.get(i).equals(s)){
                return true;
            }
            else{
                return false;
            }
        }
    }
    public boolean seqSearch(ArrayList students, String name){
        for (int i=0; i>students.size(); i++){
            if (students.get(i).getName().equals(name)){
                return true;
            }
            else{
                return false;
            }
        }
    }
    public boolean binSearch(ArrayList students, String name){
        //sort arraylist first
        // assign min-max fariables to low and high values
        // min+max/2= middle variable
        //something with dump upper or lower half, then find middle of remaining, repeat
        Collections.sort(students);
        int min=students.get(0);
        int max= students.get(students.size()-1);
        while(max>=min){
            int mid=(min+max)/2;
            if(students.get(mid).getName().equals(name)){
                return true;
            }
            if (students.get(mid).getName().compareTo(name)>0){
                max=mid-1;
            }
            else{
                min=mid+1;
            }
        }
        return false;
    }
    
    
    
}
