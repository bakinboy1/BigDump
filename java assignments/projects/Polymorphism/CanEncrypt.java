
/**
 * Specifies the *required* behaviors/algorithms
 * for the job
 * 
 * @author Company 
 * @version 3/28/2016
 */
public interface CanEncrypt
{
    //Abstract method definition
    /**
     * This method is supposed to implement the shift by 3 caesar cipher
     * It abstract (i.e., does notheting)
     * Has no access specifier
     */
    String cesar(String plaintext);
    
    //Can have other abstract method definitions
    String shiftByN(String plaintext, int shiftAmount);
    //The simple substitution cipher
    String substitute (String plaintext, char[] key);

    
}
