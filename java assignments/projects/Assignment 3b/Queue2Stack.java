
/**
 * Write a description of class Stacks here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.Stack;
public class Queue2Stack <T>
{
    private int size;
    private Stack <T> firstStack= new Stack<T>();
    private Stack <T> secondStack= new Stack<T>();
    public Queue2Stack(){
        size =0;
        
    }

    public void enqueue(T element){
        firstStack.push(element);
        size++;
    }
    public T dequeue(){
        while(firstStack.empty()==false){
            T i=firstStack.pop();
            secondStack.push(i);
            
        }
        T  s=secondStack.pop();
        while(secondStack.empty()==false){
            T i=secondStack.pop();
            firstStack.push(i);
            
        }
        size--;
        return s;
        
    }
    
    public T first(){
        while(firstStack.empty()==false){
            T i=firstStack.pop();
            secondStack.push(i);
            
        }
        T  p=secondStack.pop();
        while(secondStack.empty()==false){
            T i=secondStack.peek();
            firstStack.push(i);
            
        }
        
        return p;
    }
    public int getSize(){
        return size;
    }

    public boolean isEmpty(){
        boolean i;
        if (size==0){
            i=true;
            return i;
        }
        else{
            i=false;
            return i;
        }
    }
    
}
