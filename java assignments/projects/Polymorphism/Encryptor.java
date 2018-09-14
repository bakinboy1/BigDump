
/**
 * Performs several encryption tasks. Company.
 * 
 * @author Radhouane 
 * @version 3/25/2016
 */
public class Encryptor implements CanEncrypt
{
   //Shift by 3 cipher
   //Concrete definition of the method
   public String cesarCrypt(String plaintext){
       ///encrypt the plaintext  
      String ciphertext = "";
       //Do work on plaintext
       for(int index = 0; index< plaintext.length(); index++){
           System.out.println(plaintext.charAt(index));
           char cipherLetter = plaintext.charAt(index);
          //cipherLetter = 'A';
           cipherLetter-=3;
           ciphertext += cipherLetter;
        }      
       return ciphertext;
    }
    // Can add as many other methods as you want
}
