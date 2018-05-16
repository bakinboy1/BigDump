import java.util.*;
import java.io.*;
/**
 * Write a description of class Word here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Word 
{
    
    
    private String word;
    private int count;
 public Word(){
    word="";
    count=0;
    }
 public Word (String newWord, int newCount){
    word=newWord;
    count=newCount;
    }
 public void setNewWord(String newWord){
    this.word=newWord;
    }
 public String getWord(){
    return word;
    }
 public void setNewCount(int newCount){
    count=newCount;
    }
 public int getCount(){
    return count;
    }
 public String toString(){
    return this.word+": "+this.count;
    }
}
