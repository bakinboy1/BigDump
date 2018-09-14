
/**
 * program that generates a random number of whoozits and whatzits recursively
 * 
 * @author Fabian Hucke
 * @version 12/3/2015
 */
public class Blurbs
{
    /**
     * establish blank values for blurb, whozits, and whatzits
     */
    private String blurb;
    private String whozit="";
    private String whatzit="";
    public Blurbs()
    {
        blurb = who((int) (Math.random()*3));
    }

     /**
      * creates a random whatzit
      */

    private String what()
    {
        int x=(int)(Math.random()*3);
        if (x==0)
            return "qz"+who((int)(Math.random()*3));
            
        return "qd"+ who((int)(Math.random()*3));
    }
     /**
      * creates a random whozit and then adds a y to the end of it
      */
    private String who(int x)
    {
        if (x==0){
            return("x"+whozit);}
            x=(int)(Math.random()*3);
            whozit+="y";
            
            return who(x);
    }
    
    /**
     * combines whozits and whatzits generated to create a blurb
     */
    private String Blurbs(int x)
    {
        if (x==0)
            return blurb+what();
            blurb+=what();
        x=(int)(Math.random()*3);
        
        return Blurbs(x);
    }
    /**
     * prints blurb
     */
    public static void main (String[] args){
    Blurbs b= new Blurbs();
    int x=(int)(Math.random()*3);
    
    System.out.println(b.Blurbs(x));
    }
}
