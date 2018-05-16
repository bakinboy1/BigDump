import java.util.ArrayList;
public class ArrayListDemo
{
  
  public static void demoCocaColaArrayList(){
      //Create an array list of CocaCola references
      //We want the array list to be initially empty
      //Unlike arrays, array lists can grow and shrink as needed
      //As long as we have room for them in RAM
      ArrayList<CocaCola> myArrayListA = new ArrayList<CocaCola>();
      //Populate the array list. Add as many CocaCola objects as we want
      myArrayListA.add(new CocaCola("Zero", 8, 1.25)); 
      myArrayListA.add(new CocaCola("Fanta", 10, 0.25));
      myArrayListA.add(new CocaCola("Diet", 7, 0.6));
      myArrayListA.add(new CocaCola("Sprite", 2, 1.00)); 
      myArrayListA.add(new CocaCola("OneCoke", 20, 0.5));
      
      //Print the array list. Can use a 'for' loop
      for(int i = 0; i < myArrayListA.size(); i++){
          System.out.println(myArrayListA.get(i));
      }

      
      //Search the array for a specific item. Can use a 'for' loop
 
      for(int i = 0; i < myArrayListA.size(); i++){
          if(myArrayListA.get(i).getUnitPrice()==0.25)System.out.println("Found the Coke costing 1 dollar at index " + i);
      }    
  }
  
  public static void main (String[] args){
      demoCocaColaArrayList();
   }
}
