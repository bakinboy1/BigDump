import java.io.*;
import java.util.*;
import java.util.regex.*;
/**
 * Write a description of class CharArrayDemo here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class GoodAssembly
{
    // instance variables - replace the example below with your own
    private int x;
  public static boolean check(String fname) 
  {  

    Scanner scan;
    File f = new File(fname + ".ERR");   //The assembled program listing
    try 
    {
       scan = new Scanner(f);
       String line = "";
       while (scan.hasNextLine())
       {
           line = scan.nextLine();
       }
       scan.close();
       if (line.contains("ENDED   RC= 0"))
         return true;
       else
         return false;
    }
    catch(FileNotFoundException exc) 
    { 
      System.out.println("File Not Found: " + fname +".ERR"); 
      return false; 
    } 
  }
}
