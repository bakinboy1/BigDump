
/**
 * My implentation
 * 
 * @author Radhouane
 * @version 4/4/2016
 */
public class Encryptor1 implements  CanEncrypt
{
    public String cesar(String plaintext){
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
    public String shiftByN(String plaintext, int shiftAmount){
         ///encrypt the plaintext  
      String ciphertext = "";
       //Do work on plaintext
       for(int index = 0; index< plaintext.length(); index++){
           System.out.println(plaintext.charAt(index));
           char cipherLetter = plaintext.charAt(index);
          //cipherLetter = 'A';
           cipherLetter-=shiftAmount;
           ciphertext += cipherLetter;
        }      
       return ciphertext;
    }
    public String substitute (String plaintext, char[] key){
         ///encrypt the plaintext  
      String ciphertext = "";
       //Do work on plaintext
       for(int index = 0; index< plaintext.length(); index++){
           System.out.println(plaintext.charAt(index));
           switch(plaintext.charAt(index)){
               case 'A':
               ciphertext += key[0];
               break;
               case 'B':
               ciphertext += key[1];
               break;
            }
       }
        return ciphertext;
    }
}
