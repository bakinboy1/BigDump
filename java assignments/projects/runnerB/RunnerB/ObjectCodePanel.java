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
 * The ObjectCodePanel provides a way to convert z390 files to object code files in Visiblez.
 * 
 * @author Woolbright
 * @version 2012
 */


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Scanner;
import java.io.*;

public class ObjectCodePanel extends JPanel
{
    private CPU cpu;
    private JTextField programName;
    private MemoryPanel mp;
    private PSWPanel pswp;
    private RegisterPanel rp;
    private JCL jcl;
    private JTextField filein1Field;

    private JTextArea jclArea;
    public ObjectCodePanel(CPU cpu, MemoryPanel mp, PSWPanel pswp, RegisterPanel rp)
    {
        this.cpu = cpu;
        this.mp = mp;
        this.pswp = pswp;
        this.rp = rp;
        jcl = cpu.getJCL();
        setLayout (new FlowLayout());
        JPanel filePanel = new JPanel();
        filePanel.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        JTextArea ta = new JTextArea(12,60);
        ta.setFont(new Font("Courier", Font.BOLD, 18));
        ta.setText("\n    - If you have installed the z390 Assembler software (http://www.z390.org/) on your machine, you can ");
        ta.append("\n      convert the object code produced by z390 into a format (.OBJ) that is compatible with VisibleZ.");
        ta.append("\n\n    - First go the the Settings panel and enter the path to the Z390 directory.");
        ta.append("\n\n    - Before converting the source, change the PRINT directive in your source to PRINT ON,DATA,GEN ");
        ta.append("\n\n    - VisibleZ scrapes the z390 source listing (.PRN) for the object code and reformats it.");       
        ta.append("\n\n    - Enter the complete path name and file name of the z390 source (.MLC) program below.");
        ta.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        filePanel.add(ta);
        filePanel.setBackground(new Color(Integer.parseInt("84A5D3",16)));
        filePanel.setLayout(new BoxLayout (filePanel, BoxLayout.Y_AXIS));
        JLabel filein1Label = new JLabel("z390 FILE Name =");
        filein1Label.setFont(new Font("Courier", Font.BOLD, 24));
        filein1Field = new JTextField(40);
        filein1Field.setEditable(true);
        filein1Field.setFont(new Font("Courier", Font.BOLD, 20));
        filein1Field.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        JPanel filein1Panel = new JPanel();
        filein1Panel.setBackground(new Color(Integer.parseInt("7DBBCF",16)));
        filein1Panel.add(filein1Label);
        filein1Panel.add(filein1Field);
        JPanel buttonPanel = new JPanel();
        JButton genObjButton = new JButton("Generate Object Code");
        genObjButton.setFont(new Font("Courier", Font.BOLD, 24));
        genObjButton.addActionListener(new genObjButtonListener());
        buttonPanel.add(genObjButton);
        buttonPanel.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        buttonPanel.setLayout (new FlowLayout());
        filePanel.add(filein1Panel);        
        filePanel.add(buttonPanel);
        add(filePanel);
        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
        addMouseListener(openHandler); 
        setPreferredSize (new Dimension(1540,1000));
        filein1Field.setText("");
    }

    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }
    private class genObjButtonListener implements ActionListener 
    {
        public void actionPerformed(ActionEvent e) 
        {
           String fi1 = filein1Field.getText();
           File f = new File(fi1);
           if(! f.exists()) { 
                     JOptionPane.showMessageDialog(Runner.getFrame(), "Can't find " + fi1 );
           }
           else
           if (! fi1.equals("unassigned"))
           {
               fi1 = fi1.substring(0,fi1.length()-4);
               ProcessProgramCode.assemble(fi1);
               if (GoodAssembly.check(fi1))
               {
                  CodeConverter.generate(fi1);
               }
           }
        }  
    }

    private class mHandlerOpenPanel implements MouseListener
    {
        public void mouseClicked(MouseEvent e)
        {
           String sTitle = "Object Code Panel";
           String sBody = " VisibleZ can convert z390 .PRN program listing to the object code format" +
                          " supported by Visiblez.";   
          
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
