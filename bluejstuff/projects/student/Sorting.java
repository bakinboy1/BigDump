
/**
 * Write a description of class Sorting here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Sorting
{
    //swaps something. not sure what it does
    //when to use just <T> or <T extends<T>>?
    private static <T> void swap(T array[],int min, int i){
        T Temp=array[index1];
        array[index1]=array[index2];
        array[index2]=Temp;
    }
    //selection sort alg
    //find the smallest element in the collection
    //switch it with the first element in the collection
    //find next smallest element in collection and switch it with the second element
    //repeat until everything is in order
     public static <T extends Comparable<T>> void selectionSort(T[] array){
        // find smallest element y
        // set element to position x- initialized to 0
        // x++
        // find smallest element greater than y
        int min;
        for (int i=0; i<array.length()-1; i++){
            //min stores position of element not element value
            min=i;
            //how do you find smallest value without specifying type???
            //use one of the compare methods apparently, errors with those though
            for (int scan=i+1;scan<array.length;scan++){
                //somehow compareto works for generic types
                //figure out what >0 is for
                //after first iteration smallest element is stored in min
                if (array[min].compareTo(array[scan])>0){
                    min=scan;
                }
            }
            //wtf is swap function
            swap(array,min,i);
        }
    }
    
    // insertion sort alg
    // 39612
    // 36912
    // 13692
    // 12369
    // treat first element as sorted list of 1 element
    // add next element to sorted list
    // shift the element if necessary
    // take the next element and inserti it in the sorted list
    // shift other elements if needed (more than 1 element to move now)
     public static <T extends Comparable<T>> void insertSort(T[] array){
    
    }
    // bubble sort compares 2 elements next to each other
    // if they are in the wrong order they swap positions
    // sorts from largest to smallest
    // scan list, compare each 2 adj elements
    // switch if element a greater than element b
    // repeat until no elements are switched through entire scan
     public static <T extends Comparable<T>> void bubbleSort(T[] array){
        
    }
}
