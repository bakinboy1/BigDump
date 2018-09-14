
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.*;
/**
 *
 * @author csu
 */
public class AnalysisAssignment 
{
    
    
    public static int remainder(int entry){
        int entry, remainder;

        
        ArrayList a = new ArrayList();
        while (entry>1){
            if(remainder/2!=0){a.add(0);
                entry=remainder;
            }
            else if(remainder>0) {
                a.add(1);
                entry=remainder;
            }
            else if(entry<1){
                for(i=a.size(); i>0;i-- ){
                System.out.println(a.get(i));
            }
            }
        }
    }
}
