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
import javax.swing.border.*;


import java.awt.*; 
import java.awt.event.*; 


public class InfoPanel extends JFrame 
{
  private final static Color LIGHTYELLOW = new Color(255,255,200);
  
  //private JFrame frame;
  private JPanel content;
  
 public InfoPanel(String strTitle, String strBody, int Xsize, int Ysize, int Xlocation, int Ylocation)
 {
   // create a JFrame
    super("Removing the Title Bar of a Frame");
   
   // Setup the frame accordingly
   //Toolkit tk = Toolkit.getDefaultToolkit();
   //Dimension screenSize = tk.getScreenSize();
   //final int WIDTH = screenSize.width;
   //final int HEIGHT = screenSize.height;
   //setLocation(WIDTH/4, WIDTH/4);
   
   setLocation(Xlocation, Ylocation);

    // remove the title bar      
    setUndecorated(true);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    
        
    // get the content pane of the frame
    Container cont = getContentPane();
            
    //setBackground(Color.yellow), size, visibility
    cont.setBackground(LIGHTYELLOW); 
    setContentPane(cont);
    setSize(Xsize,Ysize);
    setVisible(true);
  
    //Get JFrame background color  
    Color jframeColor=getBackground();  
  
    //Create a text area with initial text ( Put your text here )  
    JTextArea textArea=new JTextArea(strBody, 10, 20);  
    
    // set background color
    textArea.setBackground(LIGHTYELLOW);
    textArea.setFont(new Font("Courier", Font.PLAIN, 12));
    
    // set textarea properties
    textArea.setLineWrap(true);
    textArea.setWrapStyleWord(true);
    textArea.setEditable(false);
   
    
   // create a JPanel with custom borders and a title
    Border loweredetched;
    TitledBorder title;
    loweredetched = BorderFactory.createEtchedBorder(EtchedBorder.LOWERED); 
    title = BorderFactory.createTitledBorder(loweredetched, strTitle);
    
    content = new JPanel();
    
    content.setBorder(title);
    //content.setPreferredSize(new Dimension(Xsize, Ysize));
    content.setPreferredSize(new Dimension(300, 350));

    content.setBackground(LIGHTYELLOW);
    content.setOpaque(true);
 
    
    // add the panel to the frame and the textarea to the panel
    add(content);
    content.add(textArea);
    
     
    
    // create and register MouseListener
    MouseHandler handler = new MouseHandler();
    
    // add it to the JFrame
    addMouseListener(handler);
    
    // add it to the textarea
    textArea.addMouseListener(handler);
    
    setVisible(true);
    
 }  
  
  
  /*
  
  public static void main(String[] args) {
    /*
      String sTitle = "z/Architecture PSW";
    String sBody = "The current program-status word (PSW) in the CPU contains " +  
       "information required for the execution of the currently active program. " +  
       "The PSW is 128 bits in length and includes the instruction address, condition code, " + 
       "and other control fields. In general, the PSW is used to control instruction " +  
       "sequencing and to hold and indicate much of the status of the CPU in relation "  +
       "to the program currently being executed. ";
   
    InfoPanel PSWhint = new InfoPanel(sTitle, sBody, 250, 260);
    
   String sTitle = "General Registers";
           String sBody = "General registers (GRs) are used to keep temporary data (operands) loaded " + 
                          "from memory to be processed or already processed. Instructions may designate " + 
                          "information in one or more of 16 general registers. The general registers may" + 
                          " be used as base-address registers and index registers in address arithmetic, " + 
                          " and as accumulators in general arithmetic and logical operations. Each register" + 
                          " contains 64 bit positions. The general registers are identified by the numbers 0-15," + 
                          " and are designated by a four-bit R field in an instruction.";   
          
                          InfoPanel GPR = new InfoPanel(sTitle, sBody, 250, 300);    
  
  
  
  } // end of main
  */
private class MouseHandler implements MouseListener
{
public void mouseClicked(MouseEvent e) {
          setVisible(false);
          dispose();
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
  
  
  
  
   
} // end of class 


