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

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class PSWPanel extends JPanel
{
    private CPU cpu;
    private JTextArea textArea1;
    private JTextArea textArea2;
    public PSWPanel(CPU cpu)
    {
        this.cpu = cpu;
        //setBackground (new Color(115,117,216));
        setBackground(new Color(Integer.parseInt("84A5D3",16)));
        setLayout(new BoxLayout(this, BoxLayout.LINE_AXIS));
        Toolkit tk = Toolkit.getDefaultToolkit();
        Dimension d = tk.getScreenSize();
        int width = (int) d.getWidth();
        int height = (int) (d.getHeight() * .1); 
        setPreferredSize(new Dimension(width,height));
        //setPreferredSize (new Dimension(1500,100));
        textArea1 = new JTextArea(3,30);
        textArea1.setText(cpu.getPSW().toString());
        textArea1.setFont(new Font("Courier", Font.BOLD, Runner.FONT4));  
        textArea1.setBorder(BorderFactory.createLineBorder(Color.BLACK));
        textArea1.setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        add(textArea1);
        textArea2 = new JTextArea(3, 50);
        textArea2.setBorder(BorderFactory.createLineBorder(Color.BLACK));
        textArea2.setEditable(false);
        textArea2.setFont(new Font("Courier", Font.BOLD, Runner.FONT4));
        textArea2.setBackground(new Color(Integer.parseInt("FFF7CD",16)));
        String description = " No instructions present";
        textArea2.setText(description);
        add(textArea2);
        
        // add a mouse listener to the PSW panel to open info panel
        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
        mHandlerOpenPanel1 openHandler1 = new mHandlerOpenPanel1();
        textArea1.addMouseListener(openHandler);  
        textArea2.addMouseListener(openHandler1);
    }
    public void repaintPSW()
    {
        textArea1.setText(cpu.getPSW().toString());
        Instruction lookAheadInstruction = cpu.getLookAheadInstruction();
        String description = lookAheadInstruction.getDescription();
        textArea2.setText(description);        
        repaint();
    }
    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }
    public void setTAColor(Color c)
    {
        textArea1.setBackground(c);
        textArea2.setBackground(c);
    }
    private class mHandlerOpenPanel implements MouseListener
    {
        public void mouseClicked(MouseEvent e)
        {
           String sTitle = "z/Architecture PSW";
           String sBody = "The current program-status word (PSW) in the CPU contains " +  
                            "information required for the execution of the currently active program. " +  
                            "The PSW is 128 bits in length and includes the instruction address, condition code, " + 
                            "and other control fields. In general, the PSW is used to control instruction " +  
                            "sequencing and to hold and indicate much of the status of the CPU in relation "  +
                            "to the program currently being executed. ";
   
          InfoPanel PSWhint = new InfoPanel(sTitle, sBody, 250, 260, 450, 90);     
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
    private class mHandlerOpenPanel1 implements MouseListener
    {
        public void mouseClicked(MouseEvent e)
        {
           String sTitle = "Current Instruction";
           String sBody = "The mnemonic and name of the currently highlighted instruction is listed, followed by the object code " +  
                            "format of the instruction.  The explicit notation describes how the instruction would be " +  
                            "coded in a program without using symbolic names.";
   
          InfoPanel PSWhint = new InfoPanel(sTitle, sBody, 250, 260, 950, 90);     
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
