
/**
 * Provides a concrete implementation of the canCalculate interface
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Calculator2 implements CanCalculate
{
  public int add (int i, int j){
        int result = 0;
        for(int k = 1; k<= i; k++){
            result++;
        }
        for(int l = 1; l<= i; l++){
            result++;
        }
        return result;
    }
}
