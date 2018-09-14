import java.io.*;
import java.util.*;
import java.util.regex.*;
/**
 * Write a description of class CharArrayDemo here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class CodeConverter
{
    // instance variables - replace the example below with your own
    private int x;
  public static void generate(String fname) 
  {  

    Scanner scan;
    File f = new File(fname + ".PRN");   //The assembled program listing
    try 
    {
       scan = new Scanner(f);
    }
    catch(FileNotFoundException exc) 
    { 
      System.out.println("File Not Found: " + fname +".PRN"); 
      return; 
    } 
    StringBuffer codeList = new StringBuffer();
    //We write out object code temporarily here
    File f1 = new File(fname + ".tmp");
    PrintWriter pw;
    try 
    {
       pw = new PrintWriter(f1);
    }
    catch(FileNotFoundException exc) 
    { 
      System.out.println("File Not Found"); 
      return; 
    } 
    while(scan.hasNextLine())
    {
		String temp = scan.nextLine();     //read a line in the assembled listing
		if (temp.length() >= 23)
		{
		   String temp1 = temp.substring(0,6);    // does it look like the object code?
	       String temp2 = temp.substring(7,23);
		   Scanner scan1 = new Scanner(temp2);
		   temp2 = "bad data";
		   if (scan1.hasNext())
		   {
		      temp2 = scan1.next();
		   }
		   scan1.close();
		   char[]x1 = temp1.toCharArray();
		   char[]x2 = temp2.toCharArray();
		   if (hexDigits(x1, temp1.length()) && hexDigits(x2, temp2.length()))
		   {
	          instructionFormatter(temp1, temp2, codeList);    // yes ... write it out to a StringBuffer
	       }
	    }
	}
	PrintWriter pw1;
	try 
    {
       pw1 = new PrintWriter( fname +".obj");       //the final object code file
    }
    catch(FileNotFoundException exc) 
    { 
      System.out.println("File Not Found"); 
      return; 
    } 
    String kode = insertSpaces(codeList.toString());
	pw1.print(kode);     // add some spaces and write it to a file
	pw1.close();
    scan.close(); 
    pw.close();
  }
  public static void instructionFormatter(String addr, String code, StringBuffer objectCode)
  {
      int loc = Integer.parseInt(addr,16);
      int s = objectCode.length();   //Each object code byte is 2 characters
      while (s < 2 * loc)              //Make sure the loc doesn't excede the size of the arraylist
      {
          objectCode.append("0");  
          s = objectCode.length(); 
      }
      objectCode.insert(2 * loc,code);
  }
      
  public static boolean hexDigits(char[] x, int len)
  {
      boolean result = true;
      for (int i = 0; i < len ; i++)
      {
          if (!(x[i] >= '0' && x[i] <= '9')&& !(x[i] >= 'A' && x[i] <= 'F'))
          { 
              result = false;
              return result;
          }
      }  
      return result;
  }   
  public static String insertSpaces(String s)
  {
      String sout = "";
      for(int i = 0; i < s.length(); i = i+2)
      {
          sout += s.substring(i,i+2);
          sout += " ";
      }
      return sout;
  }
}
