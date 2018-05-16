
/**
 * generates a given input int line of pascal's triangle (5 in this case)
 * 
 * @author Fabian Hucke
 * @version 12/3/2015
 */
public class pascal{
public void myPrint(int n) 
{
  
   {
      int m = n % 10;
      System.out.print(m);
      myPrint(n / 10);
   }
}

}
