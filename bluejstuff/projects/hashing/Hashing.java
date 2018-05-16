import java.util.*;
/**
 * Write a description of class Hashing here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

public class Hashing
{
    public static void main(String[] args){
        HashMap <String,Integer> myTable = new HashMap<String, Integer>();
        myTable.put("zara",2345);
        myTable.put("zoro",2325);
        myTable.put("ziri",2385);
        myTable.put("zere",2395);
        myTable.put("zara",2225);
        
        System.out.println(myTable);
        for (String key : myTable.keySet()){
            System.out.println("key : " + key);
        }
        for (int value : myTable.values()){
            System.out.println("value : " + value);
        }
        TreeMap <String,Integer> myMap = new TreeMap<String, Integer>();
        myMap.putAll(myTable);
        for (String key : myMap.keySet()){
            System.out.println("key : " + key);
        }
        //only requires 1 object
        HashSet <String> mySet = new HashSet<String>();
        mySet.add("CA");
        mySet.add("WA");
        mySet.add("DA");
        mySet.add("GA");
        
        mySet.add("WA");
        System.out.println(mySet);
        //if (mySet.contains("WA")){
        //    System.out.println("element found");
        //    else{
        //        mySet.add("WA");
        //    }
        //}
    }
    
}
