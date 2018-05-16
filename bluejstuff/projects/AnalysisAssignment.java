/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datastructues;

import java.util.Random;

/**
 *
 * @author csu
 */
public class AnalysisAssignment 
{
   
    // fill the contents of the array passed as parameter at random
    public static void fillArray(int array[])
    {
        Random rnd = new Random();
        for(int i =0; i < array.length; i++)
        {
            array[i] = rnd.nextInt(Integer.MAX_VALUE);
        }    
        
    }        
    
    // returns a new array with a copy of each of the values from the array passed as parameter
    public static int[] copyArray(int[] array)
    {
        int array1[] = new int[array.length];
        for(int i = 0 ; i < array.length; i++)
        {
            array1[i] = array[i];
        }    
        return array1;
    }      
    
    public static int alg1(int array[])
    {
        int operations_alg1 = 0;
        for(int i = 0; i < array.length; i++)
        {
            for(int j = i; j < array.length; j++)
            {
                operations_alg1++;
                if(array[j] < array[i])
                {
                    exchangeNumbers(i, j, array);
                }  
            }    
        }   
        
        return operations_alg1;
    }        
    
    public static int alg2(int array[])
    {
        return alg3(0, array.length - 1, array);
    }        
    
    public static int alg3(int lowerIndex, int higherIndex, int array[]) {
         
        int i = lowerIndex;
        int j = higherIndex;

        int pivot = array[lowerIndex+(higherIndex-lowerIndex)/2];

        int count = 0;
        
        while (i <= j) {
            while (array[i] < pivot) {
                i++;
                count++;
            }
            while (array[j] > pivot) {
                j--;
                count++;
            }
            
            count++;
            if (i <= j) {
                exchangeNumbers(i, j, array);
                i++;
                j--;
            }
        }
        
        if(lowerIndex < j)
        {    
            return count + alg3(lowerIndex, j, array);
        }    
        if(i < higherIndex)
        {    
            return count + alg3(i, higherIndex, array);
        }    
        return count;
    }
 
    public static void exchangeNumbers(int i, int j, int[] array)
    {
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    
}
