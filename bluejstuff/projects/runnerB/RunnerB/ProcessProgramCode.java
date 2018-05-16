import java.io.*;
import java.util.concurrent.*;
import javax.swing.JOptionPane;
/**
 * Write a description of class ProcessTest here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class ProcessProgramCode
{
          public static void assemble(String fname)
          {
             try 
             {
                 String e = fname;
                 File f = new File(fname + ".MLC");
                 File ferr = new File(fname + ".ERR");
                 if(! f.exists()) { 
                     JOptionPane.showMessageDialog(Runner.getFrame(), "Can't find " + fname + ".mlc" );
                 }
                 else
                 {
                     String e1 = Runner.getz390Path() + "\\" + "MAC.BAT ";
                     Process p = Runtime.getRuntime().exec(Runner.getz390Path()+ "\\" +"MAC.BAT " + fname);     //run macro processor  
                     p = Runtime.getRuntime().exec(Runner.getz390Path()+ "\\" +"ASM.BAT " + fname + ".mlc");    //run assembler
                     JOptionPane.showMessageDialog(Runner.getFrame(), "Assembling code ...");
                     p.waitFor(50L, TimeUnit.MILLISECONDS);
                     JOptionPane.showMessageDialog(Runner.getFrame(), "Be sure to check " + fname + ".ERR" + " for errors." + 
                           "\nIf no errors, " + fname + ".OBJ" + " is the VisibleZ object code file.");
                 }
             }  
             catch (IOException ioe)
             {
                System.out.println("Problem generating object code.");
             }
             catch (InterruptedException ie)
             {
                System.out.println("Conversion interrupted.");
             }
          }
}