
/**
 * This program demonstrates some of the common operations on arrays
 * 
 * @author Radhouane 
 * @version Nov/19/2015
 */
public class ArrayDemo
{
  public static void demoIntegerArray(){
      //Create an array of integers
      //We want the array to be of size 5. Each integer holds the value 0
      int[] arrayA = new int[5];
      //Populate the array. Place an integer value of our choosing in each cell
      arrayA[0] = -7; arrayA[1] = -10; arrayA[2] = 3;
      arrayA[3] = 0; arrayA[4] = 8;
      
      //Print the array. Can use a 'for' loop
      for(int i = 0; i < arrayA.length; i++){
          System.out.print(arrayA[i] + " ");
      }
      System.out.println();
      //Search the array for a specific item. Can use a 'for' loop
      int searchValue = 3;
      for(int i = 0; i < arrayA.length; i++){
          if(arrayA[i] ==3)System.out.println("Found the value " + searchValue + " at index " + i);
      }    
  }
  
  public static void demoCocaColaArray(){
      //Create an array of CocaCola references
      //We want the array to be of size 5. Each reference holds the value null
      CocaCola[] arrayA = new CocaCola[5];
      //Populate the array. Place a CocaCola object of our choosing in each cell
      arrayA[0] = new CocaCola("Zero", 8, 1.25); arrayA[1] = new CocaCola("Fanta", 10, 0.25); arrayA[2] = new CocaCola("Diet", 7, 0.6);
      arrayA[3] = new CocaCola("Sprite", 2, 1.00); arrayA[4] = new CocaCola("OneCoke", 20, 0.5);
      
      //Print the array. Can use a 'for' loop
      for(int i = 0; i < arrayA.length; i++){
          System.out.println(arrayA[i]);
      }
      
      //Search the array for a specific item. Can use a 'for' loop
      for(int i = 0; i < arrayA.length; i++){
          if(arrayA[i].getUnitPrice()==0.25)System.out.println("Found the Coke costing 25 cents at index " + i);
      }    
  }
  
  public static void main (String[] args){
      demoIntegerArray();
      demoCocaColaArray();
   }
}
