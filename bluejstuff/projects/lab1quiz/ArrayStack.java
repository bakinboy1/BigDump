/**
 * Write a description of class Stacks here.
 * 
 * @author (Fabian Hucke) 
 * @version (v1)
 */

import java.util.*;


public class ArrayStack<T> 
{
   private final int DEFAULT_CAPACITY = 10;
   private int top;  // indicates the next open slot
   private  T[] stack; 

   //-----------------------------------------------------------------
   //  Creates an empty stack using the default capacity.
   //-----------------------------------------------------------------
   
   public ArrayStack()
   {
      top = 0;
      stack = (T[])(new Object[DEFAULT_CAPACITY]);
   }

   //-----------------------------------------------------------------
   //  Creates an empty stack using the specified capacity.
   //-----------------------------------------------------------------
   public ArrayStack (int initialCapacity)
   {
      top = 0;
      stack = (T[])(new Object[initialCapacity]);
   }

   //-----------------------------------------------------------------
   //  Adds the specified element to the top of the stack, expanding
   //  the capacity of the stack array if necessary.
   //-----------------------------------------------------------------
   public void push (T element)
   {
      //write your code here
      if (size() == stack.length) {
         expandCapacity();
         stack[top] = element;
         top++;
    }
   }

   //-----------------------------------------------------------------
   //  Removes the element at the top of the stack and returns a
   //  reference to it. Throws an EmptyStackException if the stack
   //  is empty.
   //-----------------------------------------------------------------
   public T pop() throws EmptyStackException
   {
      if (isEmpty())
         throw new EmptyStackException();

      top--;
      T result = stack[top];
      stack[top] = null; 
 
      return result;
   }
   
   //-----------------------------------------------------------------
   //  Returns a reference to the element at the top of the stack.
   //  The element is not removed from the stack.  Throws an
   //  EmptyStackException if the stack is empty.  
   //-----------------------------------------------------------------
   public T peek() throws EmptyStackException
   {
       if (isEmpty())
         throw new EmptyStackException();
    

       return stack[top-1];
   }

   //-----------------------------------------------------------------
   //  Returns true if the stack is empty and false otherwise. 
   //-----------------------------------------------------------------
   public boolean isEmpty()
   {
       //write your code here
        return (top == 0);
   }
 
   //-----------------------------------------------------------------
   //  Returns the number of elements in the stack.
   //-----------------------------------------------------------------
   public int size()
   {
       //write your code here
       return top;
   }

   //-----------------------------------------------------------------
   //  Returns a string representation of the stack. 
   //-----------------------------------------------------------------
   public String toString()
   {
      String result = "";

      //write your code here
       for (int scan=0; scan < top; scan++) 
         result = result + stack[scan].toString() + "\n";

      return result;
   }

   //-----------------------------------------------------------------
   //  Creates a new array to store the contents of the stack with
   //  twice the capacity of the old one.
   //-----------------------------------------------------------------
   private void expandCapacity()
   {
      T[] larger = (T[])(new Object[stack.length*2]);

      for (int index=0; index < stack.length; index++)
         larger[index] = stack[index];

      stack = larger;
   }
   
   public static String reverseWords(String sentence) {
   // write your code here
   
   String reversed="";
   String cut[]= sentence.split(" ");
   for(int i=0;i<cut.length;i++){
    System.out.println("");
    
    
    }
    for (int i=cut.length-1;i>=0;i--){
        reversed=reversed+cut[i]+" ";
    }
   return reversed;
}

   public static void main (String [] args)
   {
       System.out.print(reverseWords("The quick brown fox jumps over the lazy dog"));
   }

}
