/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author csu
 */
public class SortQuiz 
{
    // write the code that given the array, it sorts the array using insertion sort in ascending order
    // e.g. if array1 = [82, 70,58,91,60,] then insertionSort(array1) converts the array into array1 = [58, 60, 70, 82, 91]
    public static void insertionSort(int[] array)
    {
        int sorted;
        int temp;
        int i;
        for (sorted=1; sorted<array.length; sorted++)   
        {
            temp=array[sorted];
            for(i=sorted-1; (i>=0) && (array[i]>temp); i--)  
            {
                array[i+1]=array[i];
            }
            array[i+1]=temp;   
        }
    }

    public static boolean checkSorted(int[] array)
    {
        for(int i = 0; i < array.length - 1;i++) 
        {
            if(array[i] > array[i+1])
            {
                return false;
            }    
        }    
        return true;
    }        

    public static void main(String args[])
    {
        int array[] = new int[5];

        for(int i = 0; i < array.length; i++)
        {
            array[i] = (int)(100.0*Math.random());
        }     

        System.out.println("Before sorting");
        for(int i = 0; i < array.length; i++)
        {
            System.out.println(array[i]);
        } 

        insertionSort(array);
        System.out.println("After sorting");
        for(int i = 0; i < array.length; i++)
        {
            System.out.println(array[i]);
        } 

        if(checkSorted(array))
        {
            System.out.println("Correct! Your program sorts the array correctly");
        }    
        else
        {
            System.out.println("Incorrect! Your program does not sort the array");
        }    
    }        
}
