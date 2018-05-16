
/**
 * Write a description of class slist here.
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

public class slist
{
    public static void main (String [] args) throws Exception {
        
        Bridges <String, Tweet> bridges = new Bridges <String, Tweet> (3, "348491175347", "fhucke");
        
        Employee jane= new Employee(11, "Jane");
        Employee thomas= new Employee(2, "Thomas");
        Employee potato= new Employee(66, "potato");
        Employee mr= new Employee(711, "Mr. PoopyButthole");
        
        SLelement<Tweet> el0 = new SLelement <Tweet> (jane.toString(), new Tweet ("0"));
        SLelement<Tweet> el1 = new SLelement <Tweet> (thomas.toString(), new Tweet ("1"));
        SLelement<Tweet> el2 = new SLelement <Tweet> (potato.toString(), new Tweet ("2"));
        SLelement<Tweet> el3 = new SLelement <Tweet> (mr.toString(), new Tweet ("3"));
        
        
        el0.setNext(el1);
        el1.setNext(el2);
        el2.setNext(el3);
        
        el0.getLinkVisualizer (el1).setColor ("yellow");
        el0.getLinkVisualizer (el1).setThickness(4);
        
        el1.getLinkVisualizer (el2).setColor ("green");
        el1.getLinkVisualizer (el2).setThickness(5);
        
        el2.getLinkVisualizer (el3).setColor ("magenta");
        el2.getLinkVisualizer (el3).setThickness(6);
        
        bridges.setDataStructure(el0);
        
        bridges.setTitle ("A Singly Linked List Example");
        
        bridges.visualize();
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
