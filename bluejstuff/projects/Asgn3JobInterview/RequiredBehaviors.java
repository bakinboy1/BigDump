
/**
 * This interface lists the algorithms that the company requires
 * 
 * @author Columbus,GA Company 
 * @version 4/4/2016
 */
public interface RequiredBehaviors
{
    /**
     * An implementation of this method must correctly compute the factorial
     * of the parameter. 
     * The parameter is assumed to be a positive integer.
     * 
     * @param  number    a positive integer
     * @return        the factorial of number 
     */
    int factorial(int number);
    
    /**
     * An implementation of this method must correctly return
     * the number of times that searchChar can be found in toBeSearched
     * 
     * @param  toBeSearched    a string to be searched
     * @param  searchChar      a character that we are looking for in toBeSearched
     * @return        the number of occurrences of searchChar in toBeSearched
     */
    int nbrOccurrences(String toBeSearched, char searchChar);
    
    /**
     * An implementation of this method must correctly 
     * return true if the parameter is a multiple of 2
     * Must return false otherwise
     * 
     * @param  x   a positive integer
     * 
     * @return true if x is an even number, false otherwise
     */
    boolean isEven(int x);
    
    /**
     * An implementation of this method must correctly 
     * scan the array of data and return the sum 
     * of the elements that are greater than the threshold; -1 if none. 
     *  
     * @param  data   an array of positive integers
     * @param threshold a positive integer
     * @return  the sum of the elements that are greater than the threshold
     */
    int sumUpper(int[] data, int threshold);
}
