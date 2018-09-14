// Copyright (c) 2012, David E. Woolbright
//  All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are permitted 
// provided that the following conditions are met:
// - Redistributions of source code must retain the above copyright notice, this list of conditions 
//   and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice, this list of conditions 
//   and the following disclaimer in the documentation and/or other materials provided with the 
//   distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
// IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 
// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 

import java.util.HashMap;
import java.util.Scanner;
import java.io.File;
import java.io.IOException;
import javax.swing.JOptionPane;
/**
 * This class implements Mainfram Job Control Language for files.
 * 
 * @author David Woolbright 
 * @version 2012
 */
public class JCL implements java.io.Serializable
{
    // instance variables - replace the example below with your own
    private HashMap<String,String> ddStatements;
    private String jcl;
    private String defaultJCL;

    /**
     * Constructor for objects of class JCL
     */
    public JCL()
    { 

        //Establish some working DDs
        ddStatements = new HashMap<String,String>();   // <DDName,File>
        String ddName = "filein1";
        String fileName = "filein1.txt";
        ddStatements.put(ddName,fileName);
        ddName = "filein2";
        fileName = "unassigned";
        ddStatements.put(ddName,fileName);   
        ddName = "filein3";
        fileName = "unassigned";
        ddStatements.put(ddName,fileName);        
        ddName = "fileout1";
        fileName = "c:/mainframe/fileout1.txt";
        ddStatements.put(ddName,fileName);      
        ddName = "fileout2";
        fileName = "unassigned";
        ddStatements.put(ddName,fileName); 
        ddName = "fileout3";
        fileName = "unassigned";
        ddStatements.put(ddName,fileName);
        loadJCL();
    }
    public void loadJCL()
    {
         jcl  = "filein1 DD " + ddStatements.get("filein1") + " ";
         jcl += "filein2 DD " + ddStatements.get("filein2") + " ";
         jcl += "filein3 DD " + ddStatements.get("filein3") + " ";  
         jcl += "fileout1 DD " + ddStatements.get("fileout1") + " ";  
         jcl += "fileout2 DD " + ddStatements.get("fileout2") + " "; 
         jcl += "fileout3 DD " + ddStatements.get("fileout3") + " ";             

    }
    public String getJCLAsString()
    {
        return jcl;
    }
    public String getPhysicalName(String ddName)
    {
        ddName = ddName.trim();
        String pName = ddStatements.get(ddName).trim();
        return pName;
    }   
    public void setPhysicalName(String ddName, String pName)
    {
        ddStatements.put(ddName,pName);
        loadJCL();
    }
}
