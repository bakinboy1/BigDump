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

/**
 * The JCLPanel provides a connection between DDNames and external files.
 * 
 * @author Woolbright
 * @version 2012
 */


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Scanner;
import java.io.*;

public class JCLPanel extends JPanel
{
    private CPU cpu;
    private JTextField programName;
    private MemoryPanel mp;
    private PSWPanel pswp;
    private RegisterPanel rp;
    private JCL jcl;
    private JTextField filein1Field;
    private JTextField filein2Field;  
    private JTextField filein3Field;
    private JTextField fileout1Field;
    private JTextField fileout2Field;
    private JTextField fileout3Field;
    
    private JTextArea jclArea;
    public JCLPanel(CPU cpu, MemoryPanel mp, PSWPanel pswp, RegisterPanel rp)
    {
        this.cpu = cpu;
        this.mp = mp;
        this.pswp = pswp;
        this.rp = rp;
        jcl = cpu.getJCL();
        //setBackground(new Color(Integer.parseInt("84A5D3",16)));
        //setBackground(new Color(Integer.parseInt("FFF7CD",16)))
        //setBackground(new Color(Integer.parseInt("7DBBCF",16))); 
        setLayout (new FlowLayout());
 
        JPanel filePanel = new JPanel();
        filePanel.setBackground(new Color(Integer.parseInt("84A5D3",16)));
        filePanel.setLayout(new BoxLayout (filePanel, BoxLayout.Y_AXIS));
        JTextArea ta = new JTextArea(4,60);
        ta.setFont(new Font("Courier", Font.BOLD, 18));
        ta.setText("\n    - VisibleZ supports up to 3 input and 3 output files. ");
        ta.append("\n    - The logical record length (LRECL) of all files is fixed at 80."); 
        ta.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        filePanel.add(ta);
        JLabel filein1Label = new JLabel("FILEIN1   DD DSN=");
        filein1Label.setFont(new Font("Courier", Font.BOLD, 24));
        filein1Field = new JTextField(40);
        filein1Field.setEditable(true);
        filein1Field.setFont(new Font("Courier", Font.BOLD, 20));
        filein1Field.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        JPanel filein1Panel = new JPanel();
        filein1Panel.setBackground(new Color(Integer.parseInt("7DBBCF",16)));
        filein1Panel.add(filein1Label);
        filein1Panel.add(filein1Field);
        JLabel fileout1Label = new JLabel("FILEOUT1 DD DSN=");
        fileout1Label.setFont(new Font("Courier", Font.BOLD, 24));
        fileout1Field = new JTextField(40);
        fileout1Field.setEditable(true);
        fileout1Field.setFont(new Font("Courier", Font.BOLD, 20));
        fileout1Field.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        JPanel fileout1Panel = new JPanel();
        fileout1Panel.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        fileout1Panel.add(fileout1Label);
        fileout1Panel.add(fileout1Field);
        
        JLabel filein2Label = new JLabel("FILEIN2   DD DSN=");
        filein2Label.setFont(new Font("Courier", Font.BOLD, 24));
        filein2Field = new JTextField(40);
        filein2Field.setEditable(true);
        filein2Field.setFont(new Font("Courier", Font.BOLD, 20));
        filein2Field.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        JPanel filein2Panel = new JPanel();
        filein2Panel.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        filein2Panel.add(filein2Label);
        filein2Panel.add(filein2Field);

        JLabel fileout2Label = new JLabel("FILEOUT2 DD DSN=");
        fileout2Label.setFont(new Font("Courier", Font.BOLD, 24));
        fileout2Field = new JTextField(40);
        fileout2Field.setEditable(true);
        fileout2Field.setFont(new Font("Courier", Font.BOLD, 20));
        fileout2Field.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        JPanel fileout2Panel = new JPanel();
        fileout2Panel.setBackground(new Color(Integer.parseInt("7DBBCF",16)));
        fileout2Panel.add(fileout2Label);
        fileout2Panel.add(fileout2Field);
        
        JLabel filein3Label = new JLabel("FILEIN3   DD DSN=");
        filein3Label.setFont(new Font("Courier", Font.BOLD, 24));
        filein3Field = new JTextField(40);
        filein3Field.setEditable(true);
        filein3Field.setFont(new Font("Courier", Font.BOLD, 20));
        filein3Field.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        JPanel filein3Panel = new JPanel();
        filein3Panel.setBackground(new Color(Integer.parseInt("7DBBCF",16)));
        filein3Panel.add(filein3Label);
        filein3Panel.add(filein3Field);
 
        JLabel fileout3Label = new JLabel("FILEOUT3 DD DSN=");
        fileout3Label.setFont(new Font("Courier", Font.BOLD, 24));
        fileout3Field = new JTextField(40);
        fileout3Field.setEditable(true);
        fileout3Field.setFont(new Font("Courier", Font.BOLD, 20));
        fileout3Field.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        JPanel fileout3Panel = new JPanel();
        fileout3Panel.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        fileout3Panel.add(fileout3Label);
        fileout3Panel.add(fileout3Field);


        
        JPanel buttonPanel = new JPanel();
        JButton addDDButton = new JButton("Add DDs");
        addDDButton.setFont(new Font("Courier", Font.BOLD, 24));
        addDDButton.addActionListener(new addDDButtonListener());
        JButton removeDDButton = new JButton("Remove DDs");
        removeDDButton.addActionListener(new removeDDButtonListener()); 
        removeDDButton.setFont(new Font("Courier", Font.BOLD, 24));
        buttonPanel.add(addDDButton);
        buttonPanel.add(removeDDButton);
        buttonPanel.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        buttonPanel.setLayout (new FlowLayout());
        filePanel.add(filein1Panel);        
        filePanel.add(filein2Panel);
        filePanel.add(filein3Panel);
        filePanel.add(fileout1Panel);
        filePanel.add(fileout2Panel);
        filePanel.add(fileout3Panel);
        filePanel.add(buttonPanel);
        add(filePanel);
        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
        addMouseListener(openHandler); 
        setPreferredSize (new Dimension(1540,1000));
        
        String jclString = cpu.getJCL().getJCLAsString();
        Scanner scan = new Scanner (jclString);
        String info = "";
        while (scan.hasNext())
        {
             String fname = scan.next();
             if (fname.toLowerCase().trim().equals("filein1"))
             {
                 scan.next();   // skip DD
                 String pname = scan.next();
                 filein1Field.setText(pname);
             }
             if (fname.toLowerCase().trim().equals("filein2"))
             {
                 scan.next();   // skip DD
                 String pname = scan.next();
                 filein2Field.setText(pname);
             } 
             if (fname.toLowerCase().trim().equals("filein3"))
             {
                 scan.next();   // skip DD
                 String pname = scan.next();
                 filein3Field.setText(pname);
             }   
             if (fname.toLowerCase().trim().equals("fileout1"))
             {
                 scan.next();   // skip DD
                 String pname = scan.next();
                 fileout1Field.setText(pname);
             }     
             if (fname.toLowerCase().trim().equals("fileout2"))
             {
                 scan.next();   // skip DD
                 String pname = scan.next();
                 fileout2Field.setText(pname);
             }   
             if (fname.toLowerCase().trim().equals("fileout3"))
             {
                 scan.next();   // skip DD
                 String pname = scan.next();
                 fileout3Field.setText(pname);
             }                                  
        }
        
        
    }

    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }
    private class addDDButtonListener implements ActionListener 
    {
        public void actionPerformed(ActionEvent e) 
        {
           String fi1 = filein1Field.getText();
           if (! fi1.equals("unassigned"))
           {
               jcl.setPhysicalName("filein1",fi1);
           }
           String fi2 = filein2Field.getText();
           if (! fi2.equals("unassigned"))
           {
               jcl.setPhysicalName("filein2",fi2);
           }
           String fi3 = filein3Field.getText();
           if (! fi3.equals("unassigned"))
           {
               jcl.setPhysicalName("filein3",fi3);
           }
           String fo1 = fileout1Field.getText();
           if (! fo1.equals("unassigned"))
           {
               jcl.setPhysicalName("fileout1",fo1);
           }
           String fo2 = fileout2Field.getText();
           if (! fo2.equals("unassigned"))
           {
               jcl.setPhysicalName("fileout2",fo2);
           } 
           String fo3 = fileout3Field.getText();
           if (! fo3.equals("unassigned"))
           {
               jcl.setPhysicalName("fileout3",fo3);
           }  
           try
           {
              FileOutputStream fileOut =
              new FileOutputStream("jclstate.ser");
              ObjectOutputStream out = new ObjectOutputStream(fileOut);
              JCL x = jcl;
              String y = x.getJCLAsString();
              out.writeObject(jcl);
              out.close();
              fileOut.close();
           }catch(IOException i)
           {
              i.printStackTrace();
           }
        }  
    }
    private class removeDDButtonListener implements ActionListener 
    {
        public void actionPerformed(ActionEvent e) 
        {
           jcl.setPhysicalName("filein1","unassigned");
           jcl.setPhysicalName("filein2","unassigned");
           jcl.setPhysicalName("filein3","unassigned");           
           jcl.setPhysicalName("fileout1","unassigned");
           jcl.setPhysicalName("fileout2","unassigned");
           jcl.setPhysicalName("fileout3","unassigned");
           filein1Field.setText("unassigned");
           filein2Field.setText("unassigned");
           filein3Field.setText("unassigned");
           fileout1Field.setText("unassigned");
           fileout2Field.setText("unassigned");
           fileout3Field.setText("unassigned");
           try
           {
              FileOutputStream fileOut =
              new FileOutputStream("jclstate.ser");
              ObjectOutputStream out = new ObjectOutputStream(fileOut);
              JCL x = jcl;
              String y = x.getJCLAsString();
              out.writeObject(jcl);
              out.close();
              fileOut.close();
           }catch(IOException i)
           {
              i.printStackTrace();
           }
           
        }  
    } 
    private class mHandlerOpenPanel implements MouseListener
    {
        public void mouseClicked(MouseEvent e)
        {
           String sTitle = "JCL Panel";
           String sBody = " VisibleZ supports up to 3 input and 3 output files.  Use this panel to" +
                          " connect the assembler program's DD name with physical file names.  Each" +
                          " file must contain 80 byte records.";   
          
                          InfoPanel GPR = new InfoPanel(sTitle, sBody, 250, 300, 1000, 300);     
          //System.out.println("The frame was clicked.");
  
        }

   public void mouseEntered(MouseEvent e) {
          //System.out.println("The mouse entered the frame.");
  
   }

   public void mouseExited(MouseEvent e) {
         //System.out.println("The mouse exited the frame.");
  
   }

   public void mousePressed(MouseEvent e) {
         //System.out.println("The left mouse button was pressed.");
  
   }

   public void mouseReleased(MouseEvent e) {
         //System.out.println("The left mouse button was released.");

  
   } 
 } // end of class MouseHandler 
}
