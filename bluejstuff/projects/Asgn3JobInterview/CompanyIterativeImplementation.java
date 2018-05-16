//
/**
 * This class provide iterative implementations of the required behaviors
 * 
 * @author Columbus,GA Company
 * @version 4/4/2016
 */
public class CompanyIterativeImplementation implements RequiredBehaviors
{
    
    public int factorial(int number){
        int result = 1;
        if(number == 1){ return 1;}
        for(int i = 1; i <= number; i++){
            result *= i;
        }
        return result;
    }
    
   
    public int nbrOccurrences(String toBeSearched, char searchChar){
        int count = 0;
        for(int i = 0; i < toBeSearched.length(); i++){
            if(toBeSearched.charAt(i) == searchChar){
                count++;
            }
        }
        return count;
    }
   
    public boolean isEven(int x){
        while(x > 0){
            x -= 2;
        }
        if (x == 0) {
            return true;}
        else{
            return false;
        }
    }
    
    public int sumUpper(int[] data, int threshold){
         int sum = -1;
         for(int i = 0; i < data.length; i++){
            if(data[i] > threshold){
                sum += data[i];
            }
        }
        return sum;
    }
}
