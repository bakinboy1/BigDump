
/**
 * Write a description of class Employee here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import bridges.connect.Bridges;
import bridges.data_src_dependent.Tweet;
import bridges.base.SLelement;
import bridges.base.LinkVisualizer;


import java.util.HashMap;
import java.lang.String;
public class Employee
{
    
        int ID;
        String name;
        public Employee(int newID, String newName){
            ID=newID;
            name=newName;
        }
        
        
        public int getID(){
            return ID;
        }
        public String getName(){
            return name;
        }
        public String toString(){
            return "Employee name: ["+ name +"], ID#: [" +ID+"]";
        }
    }
    
    

