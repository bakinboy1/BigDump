
/**
 * Write a description of class FabianRecursiveImplementation here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class FabianRecursiveImplementation implements RequiredBehaviors
{
    /**
     * An implementation of this method must correctly compute the factorial
     * of the parameter. 
     * The parameter is assumed to be a positive integer.
     * 
     * @param  number    a positive integer
     * @return        the factorial of number 
     */
    // int factorial(int number);
    public int factorial (int number){
        
        if (number==1){
            
            
            return 1;
            
        }
        else{
            return factorial(number-1)*number;
        }
        
    }

    /**
     * An implementation of this method must correctly return
     * the number of times that searchChar can be found in toBeSearched
     * 
     * @param  toBeSearched    a string to be searched
     * @param  searchChar      a character that we are looking for in toBeSearched
     * @return        the number of occurrences of searchChar in toBeSearched
     */
    //int nbrOccurrences(String toBeSearched, char searchChar);
    public int nbrOccurrences(String toBeSearched, char searchChar){

        if (toBeSearched.length() == 0)
        {
            return 0;
        }
        else if(toBeSearched.charAt(0) == searchChar){
            return 1 + nbrOccurrences(toBeSearched.substring(1, toBeSearched.length()), searchChar);
        }
        else{
            return nbrOccurrences(toBeSearched.substring(1, toBeSearched.length()), searchChar);
        }

    }

    /**
     * An implementation of this method must correctly 
     * return true if the parameter is a multiple of 2
     * Must return false otherwise
     * 
     * @param  x   a positive integer
     * 
     * @return true if x is an even number, false otherwise
     */
    // boolean isEven(int x);
    public boolean isEven(int x){
        
        if (x==0){
            
            return true;
        }
        if (x==-1){
            return false;
        }
        else{
           return isEven(x-2);
        }
        
    }

    /**
     * An implementation of this method must correctly 
     * scan the array of data and return the sum 
     * of the elements that are greater than the threshold; -1 if none. 
     *  
     * @param  data   an array of positive integers
     * @param threshold a positive integer
     * @return  the sum of the elements that are greater than the threshold
     */
    // int sumUpper(int[] data, int threshold);
    public int sumUpper(int[] data, int threshold){
        
        if(threshold==-1){
        return 0;
        }
        if (threshold>11){
        threshold=11;
        return data[threshold]+sumUpper(data, threshold-1);
        }
        else{
        return data[threshold]+sumUpper(data, threshold-1);
        }
    }
}
