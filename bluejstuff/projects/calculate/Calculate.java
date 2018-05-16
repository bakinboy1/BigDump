
/**
 * Provides a concrete implementation of the canCalculate interface
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Calculate implements CanCalculate
{
    public double add (double i, double j){
        return i + j;

    }
    public int add (int i, int j){
        return i + j;
    }
    public double multiply(double x, double y){
        return x*y;
    }
}
