import java.util.*;
/**
 * Write a description of class CompareFreq here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
class CompareFreq  implements Comparator<Word>
{
    @Override
    public int compare(Word f1, Word f2){
        if (f1.getCount()<f2.getCount()){
            return 1;
        }
        if (f1.getCount()>f2.getCount()){
            return -1;
        }
        else{
            return 0;
        }
    }
}
