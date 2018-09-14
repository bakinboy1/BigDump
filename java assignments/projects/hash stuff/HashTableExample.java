import java.util.*;
/**
 * Write a description of class HashTableExample here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class HashTableExample
{
  public static void main(String args[]){
      //use put to add data to hash table and map
      //hashmaps use keySet();
      Hashtable balance = new Hashtable();
      String str;
     Hashtable balance = new Hashtable();
     balance.put("zara", new Double (2332.22));
     balance.put("prara", new Double (2662.22));
     balance.put("iara", new Double (1132.22));
     balance.put("zoro", new Double (2432.22));
     
     //gives you a list of keys you can iterate over
     Enumeration keyList = balance.keys();
     while(keyList.hasMoreElements()){
         //needs to be cast to string using the (String)
         str= (String)keyList.nextElement();
         //balance.get(str) gets the double value 'balance' from the str KEY
         System.out.println( str+ balance.get(str))
        }
    }
}
