
/**
 * Write a description of class Calculate here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
class Calculate 
{
    
    private doMath math;
    public Calculate(doMath type){
        this.math= type;
    }
    public int go(int v1, int v2){
        return math.doMath(v1, v2);
    }
}

