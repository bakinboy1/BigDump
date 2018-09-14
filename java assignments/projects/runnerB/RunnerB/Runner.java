// Copyright (c) 2012, David E. Woolbright, Vladimir Zanev
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

import javax.swing.JFrame;
import javax.swing.JTabbedPane;
import javax.swing.JToolBar;
import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.JMenuBar;
import javax.swing.JMenu;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.ButtonGroup;
import javax.swing.JScrollPane;
import javax.swing.SwingUtilities;
import java.awt.*;
import java.io.*;
import java.awt.event.*;
import java.util.Scanner;
public class Runner
{
   //public static int MEMSIZE = 1368;                    // the number of bytes in memory
   public static int MEMSIZE = 4096;
   //public static int SAVEAREAADDRESS = MEMSIZE - 88;  // allow for 18 fullwords 
   //public static int OSSTART = MEMSIZE - 424;           // start of Operating System code area
   public static int PARMSIZE = 36;
   public static int SAVEAREAADDRESS = MEMSIZE - 408;   // allow for 18 fullwords 
   public static int PARMTABLE = MEMSIZE - 336;         // table of parm addresses
   public static int PARMDATA = MEMSIZE - 304;          // the parameters
   public static int PARM1ADDR = PARMDATA;
   public static int PARM2ADDR = PARM1ADDR + PARMSIZE;
   public static int PARM3ADDR = PARM2ADDR + PARMSIZE;
   public static int PARM4ADDR = PARM3ADDR + PARMSIZE;
   public static int PARM5ADDR = PARM4ADDR + PARMSIZE;
   public static int PARM6ADDR = PARM5ADDR + PARMSIZE;
   public static int PARM7ADDR = PARM6ADDR + PARMSIZE;
   public static int PARM8ADDR = PARM7ADDR + PARMSIZE;   
   public static int FILEREADER = MEMSIZE - 16;       // device driver for reading from a file
   public static int FILEPRINTER = MEMSIZE - 12;      // device driver for printing to a file   
   public static int OSRETURNADDRESS = MEMSIZE - 8;   // restart the program at byte 0
   public static int PROGRAMSTART = 0;                // start execution here
   public static CPU cpu;
   public static Converter converter;
   public static String codesPath;
   public static String asmPath;
   public static JFrame myFrame;
   // High resolution settings (1920x1080)
   // FONT0 = 16; FONT1 = 20; FONT2 = 18; FONT3 = 20; FONT4 = 24; FONT5 = 30 HEIGHT = .65
   public static final int FONT0 = 16;  //Button panel
   public static final int FONT1 = 20;  //Register panels
   public static final int FONT2 = 18;
   public static final int FONT3 = 20;
   public static final int FONT4 = 24;  //PSW panel
   public static final int FONT5 = 30;  //Memory panel header
   public static final double HEIGHTFACTOR = .65; 
   
   // Low resolution settings(1366x768) 
   // FONT0 = 12; FONT1 = 12; FONT2 = 16; FONT3 = 16; FONT4 = 16; FONT5 = 24 HEIGHT=.70
//    public static final int FONT0 = 12;  //Button panel
//    public static final int FONT1 = 12;  //Register panels
//    public static final int FONT2 = 16;
//    public static final int FONT3 = 16;
//    public static final int FONT4 = 16;  //PSW panel
//    public static final int FONT5 = 14;  //Memory panel header
//    public static final double HEIGHTFACTOR = .70;  //Register panel height
   //-----------------------------------------------------------------
   //  Creates and displays the application frame.
   //-----------------------------------------------------------------
   public static void main (String[] args) throws IOException
   {
       SwingUtilities.invokeLater(new Runnable(){
          public void run() {
              try {
                    new Runner();
              }
              catch(IOException ioe)
              {
                  System.out.println("IOException:" + ioe);
              }
          }
       });
   }
   public Runner() throws IOException
   {
      cpu = new CPU(MEMSIZE); 
      converter = new Converter();
      codesPath = "c:/Codes";
      asmPath = "c:/z390";
      JFrame frame = new JFrame ("VisibleZ"); 
      frame.setResizable(true);
      frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
      frame.setDefaultCloseOperation (JFrame.EXIT_ON_CLOSE);
      JPanel panel = new JPanel();
      panel.setLayout(new BorderLayout());
      Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
      int swidth = screenSize.width ;
      int sheight = screenSize.height;      
      panel.setPreferredSize(new Dimension(swidth,sheight));
      PSWPanel pswp = new PSWPanel(cpu);
      panel.add(pswp, BorderLayout.PAGE_START);
      MemoryPanel mp = new MemoryPanel(cpu);
      RegisterPanel rp = new RegisterPanel(cpu);
      JScrollPane sprp = new JScrollPane(rp);
      FRegisterPanel frp = new FRegisterPanel(cpu);
      ParmPanel parmp = new ParmPanel(cpu,mp,rp);
      panel.add(mp,BorderLayout.CENTER);  
      panel.add(new ButtonPanel(cpu, mp, pswp, rp), BorderLayout.PAGE_END);
      JTabbedPane tpr = new JTabbedPane();   
      tpr.addTab("GPR Registers",rp);
      tpr.addTab("FPR",frp);
      tpr.setFont(new Font("Courier", Font.BOLD, Runner.FONT2)); //18
      tpr.setPreferredSize(new Dimension(250,sheight));
      panel.add(tpr, BorderLayout.LINE_END);  
      JPanel filePanel = new JCLPanel(cpu, mp, pswp, rp); 
      JPanel settingsPanel = new SettingsPanel();
      JPanel objectCodePanel = new ObjectCodePanel(cpu, mp, pswp, rp);
      JTabbedPane tp = new JTabbedPane();                       
      tp.addTab("Enterprise",panel);
      tp.addTab("JCL",filePanel);
      tp.addTab("Parameters", parmp);
      tp.addTab("Settings",settingsPanel);
      tp.addTab("Generate Object Code",objectCodePanel);
      tp.setFont(new Font("Courier", Font.BOLD, Runner.FONT2));  //18
      frame.add(tp);
      frame.pack();
      frame.setVisible(true);
   }
   public static CPU getCPU()
   {
       return cpu;
   }
   public static String getCodesPath()
   {
        try
       {
           Scanner pathFile = new Scanner(new File("c:\\codes\\pname.txt"));
           codesPath = pathFile.next();
           pathFile.close();
       }
       catch (IOException ioe)
       {
           codesPath = "c:\\codes";
       }
       return codesPath;
   }
   public static String getz390Path()
   {
        try
       {
           Scanner pathFile = new Scanner(new File("c:\\codes\\zname.txt"));
           asmPath = pathFile.next();
           pathFile.close();
       }
       catch (IOException ioe)
       {
           asmPath = "c:\\z390";
       }
       return asmPath;
   }
   public static void setCodesPath(String p)
   {
       codesPath = p;
       Scanner scan = null;
       try
       {
           FileWriter pathFile = new FileWriter("c:\\codes\\pname.txt");
           pathFile.write(p);
           pathFile.write("\r\n");
           pathFile.close();
       }
       catch (IOException ioe)
       {
           codesPath = "c:\\codes";
       }
    }
   public static void setz390Path(String p)
   {
       asmPath = p;
       Scanner scan = null;
       try
       {
           FileWriter pathFile = new FileWriter("c:\\codes\\zname.txt");
           pathFile.write(p);
           pathFile.write("\r\n");
           pathFile.close();
       }
       catch (IOException ioe)
       {
           codesPath = "c:\\z390";
       }
    }    
    public static JFrame getFrame()
    {
        return myFrame;
    }
    public static void setFrame(JFrame f)
    {
        myFrame = f;
    }
   }
   