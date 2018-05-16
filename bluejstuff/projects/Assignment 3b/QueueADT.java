
/**
 * Write a description of interface Interface here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public interface QueueADT<T>
{
    //add an element to rear of queue
    public void enqueue(T element);
    //remove and return element at front of queue.
    public T dequeue();
    //returns without removing element at front of queue. (peek)
    public T first();
    //returns if this queue has no elements
    public boolean isEmpty();
    //returns number of queue elements
    public int size();
    //returns a string representation of this queue
    public String toString();
}
