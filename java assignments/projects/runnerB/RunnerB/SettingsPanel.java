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

import javax.swing.*;
import javax.swing.table.*;
import java.awt.*;
import java.awt.event.*;

public class SettingsPanel extends JPanel
{
    private CPU cpu;
    private Memory memory;
    private Registers registers;
    private int noParms;  // the number of parameters
    private JTextField codesPath;
    private JTextField asmPath;  //the path to z390 assembler
    private JButton chooseButton;

    public SettingsPanel()
    {
        super();
        JPanel pan1 = new JPanel();
        pan1.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
        chooseButton = new JButton("Save Paths");
        chooseButton.setFont(new Font("Courier", Font.BOLD, 24));
        chooseButton.addActionListener(new ChooseButtonListener());
        chooseButton.setEnabled(true); 

        JTextArea ta1 = new JTextArea(5,60);
        ta1.setFont(new Font("Courier", Font.BOLD, 18));
        ta1.setText("\n    - The Codes directory distributed with VisibleZ contains hundreds of object-code programs that illustrate");
        ta1.append("\n       how each instruction works.  ");
        ta1.append("\n\n    - Enter the complete path to the Codes directory on your machine. ");
        ta1.append("\n ");
        ta1.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        pan1.add(ta1);
        JPanel pan2 = new JPanel();
        pan2.setBackground(new Color(Integer.parseInt("7DBBCF",16)));  
        JLabel lab = new JLabel("Path to the Codes directory:  ");
        lab.setFont(new Font("Courier", Font.BOLD, 24));
        pan2.add(lab);
        codesPath = new JTextField(60);
        codesPath.setText(Runner.getCodesPath());
        codesPath.setFont(new Font("Courier", Font.BOLD, 24));
        codesPath.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        pan2.add(codesPath);
        JPanel pan3 = new JPanel();
        pan3.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        JTextArea ta3 = new JTextArea(9,60);
        ta3.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        ta3.setFont(new Font("Courier", Font.BOLD, 18));
        ta3.setText("\n    - If you use z390 (www.z390.org) to build assembler programs, VisizbleZ can convert the object code produced by z390 to a VisibleZ format.  ");
        ta3.append("\n\n    - z390 must be installed on your machine, and you must enter the complete path to the z390 directory below. ");
        ta3.append("\n\n    - After setting the path, go to the Generate Object Code tab to perform code conversions. ");
        ta3.append("\n\n    - The code generation feature gives you the ability to create small assembler programs that run in VisibleZ without having to ");;
        ta3.append("\n       write the object code yourself.");
        ta3.append("\n ");
        ta3.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        pan3. add(ta3);
        JPanel pan4 = new JPanel();
        pan4.setBackground(new Color(Integer.parseInt("7DBBCF",16)));
        JLabel lab1 = new JLabel("Path to the z390 directory:    ");
        lab1.setFont(new Font("Courier", Font.BOLD, 24));
        pan4.add(lab1);
        asmPath = new JTextField(60);
        asmPath.setText(Runner.getz390Path());
        asmPath.setFont(new Font("Courier", Font.BOLD, 24));
        asmPath.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        pan4.add(asmPath);
        //add(Box.createRigidArea(new Dimension(350,0)));
        JPanel pan5 = new JPanel();
        pan5.add(chooseButton);
        pan5.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        // add a mouse click listener
        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
        addMouseListener(openHandler); 
        //int fontSize = 18;

        setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        add(pan1);
        add(pan2);
        add(pan3);
        add(pan4);
        add(pan5);
       

    }

        
//     private class MyDefaultTableModel extends DefaultTableModel {  
//      public MyDefaultTableModel(Object[][] data, Object[] columnNames) {  
//        super(data,columnNames);  
//      }  
//      public boolean isCellEditable(int row, int col) {  
//        return (col == 0)? false : true;
//      }  
//     }  
    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }
    private class ChooseButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
          Runner.setCodesPath(codesPath.getText());
          Runner.setz390Path(asmPath.getText());

        }
    }


    private class mHandlerOpenPanel implements MouseListener
    {
        public void mouseClicked(MouseEvent e)
        {
           String sTitle = "Settings";
           String sBody = " Set the path to the Codes directory " + 
                          " which contains all the object code demonstration programs for VisibleZ.    " +
                          "\n\n Set the path to the z390 directory if you use z390 to generate object code programs for VisibleZ.";
          
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
