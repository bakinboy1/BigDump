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

public class FRegisterPanel extends JPanel 
{
    private CPU cpu;
    private FRegisters fregisters;
    private JTextField r0;
    private JTextField r1;
    private JTextField r2;
    private JTextField r3;
    private JTextField r4;
    private JTextField r5;
    private JTextField r6;
    private JTextField r7;
    private JTextField r8;
    private JTextField r9;
    private JTextField r10;
    private JTextField r11;
    private JTextField r12;
    private JTextField r13;    
    private JTextField r14;
    private JTextField r15;    

    public FRegisterPanel(CPU cpu)
    {
        super();
        this.cpu = cpu;
        fregisters = cpu.getFRegisters();
        fregisters.randomize();
        // add a mouse click listener to r0


//        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
//        addMouseListener(openHandler);

        r0 = new JTextField(18); 
        r0.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r0.setText("   " +fregisters.getFRegister(0).longRegToHexString().toUpperCase());
        r0.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r1 = new JTextField(18); 
        r1.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r1.setText("   " + fregisters.getFRegister(1).longRegToHexString().toUpperCase()); 
        r1.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r2 = new JTextField(18);
        r2.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r2.setText("   " + fregisters.getFRegister(2).longRegToHexString().toUpperCase()); 
        r2.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r3 = new JTextField(18); 
        r3.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r3.setText("   " + fregisters.getFRegister(3).longRegToHexString().toUpperCase()); 
        r3.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r4 = new JTextField(18);
        r4.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r4.setText("   " + fregisters.getFRegister(4).longRegToHexString().toUpperCase());
        r4.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r5 = new JTextField(18); 
        r5.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r5.setText("   " + fregisters.getFRegister(5).longRegToHexString().toUpperCase());  
        r5.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r6 = new JTextField(18); 
        r6.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r6.setText("   " + fregisters.getFRegister(6).longRegToHexString().toUpperCase());
        r6.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r7 = new JTextField(18); 
        r7.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r7.setText("   " + fregisters.getFRegister(7).longRegToHexString().toUpperCase());
        r7.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r8 = new JTextField(18); 
        r8.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r8.setText("   " + fregisters.getFRegister(8).longRegToHexString().toUpperCase());
        r8.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r9 = new JTextField(18); 
        r9.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r9.setText("   " + fregisters.getFRegister(9).longRegToHexString().toUpperCase());
        r9.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r10 = new JTextField(18); 
        r10.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r10.setText("   " + fregisters.getFRegister(10).longRegToHexString().toUpperCase());
        r10.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r11 = new JTextField(18); 
        r11.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r11.setText("   " + fregisters.getFRegister(11).longRegToHexString().toUpperCase()); 
        r11.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r12 = new JTextField(18); 
        r12.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r12.setText("   " + fregisters.getFRegister(12).longRegToHexString().toUpperCase());
        r12.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r13 = new JTextField(18); 
        r13.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r13.setText("   " + fregisters.getFRegister(13).longRegToHexString().toUpperCase());
        r13.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r14 = new JTextField(18); 
        r14.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r14.setText("   " + fregisters.getFRegister(14).longRegToHexString().toUpperCase());
        r14.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r15 = new JTextField(18); 
        r15.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r15.setText("   " + fregisters.getFRegister(15).longRegToHexString().toUpperCase()); 
        r15.setFont(new Font("Courier New",Font.BOLD, Runner.FONT3));
        r0.setEditable(false);
        r1.setEditable(false);
        r2.setEditable(false);
        r3.setEditable(false);
        r4.setEditable(false);
        r5.setEditable(false);
        r6.setEditable(false);
        r7.setEditable(false);
        r8.setEditable(false);
        r9.setEditable(false);
        r10.setEditable(false);
        r11.setEditable(false);
        r12.setEditable(false);
        r13.setEditable(false);
        r14.setEditable(false);
        r15.setEditable(false);    
    
        setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        Toolkit tk = Toolkit.getDefaultToolkit();
        Dimension d = tk.getScreenSize();  
        int swidth = (int) d.getWidth();
        int sheight = (int) d.getHeight();
        int dimWidth = 270;
        int dimHeight = (int)(sheight * Runner.HEIGHTFACTOR);
        JPanel panel1 = new JPanel();
        
        panel1.setLayout(new GridLayout(33,1));
        panel1.setOpaque(true);
        
        panel1.setPreferredSize(new Dimension(dimWidth,dimHeight));
        setBackground (new Color(Integer.parseInt("ACE9A3",16)));
        JLabel lab0 = new JLabel("  R0 ", SwingConstants.CENTER);
        lab0.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));       
        panel1.setBackground (new Color(Integer.parseInt("FFF7CD",16)));
        panel1.add(lab0);
        panel1.add(r0);
        JLabel lab1 = new JLabel("  R1 ", SwingConstants.CENTER);
        lab1.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab1);
        panel1.add(r1);        
        JLabel lab2 = new JLabel("  R2 ", SwingConstants.CENTER);
        lab2.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));        
        panel1.add(lab2);
        panel1.add(r2);
        JLabel lab3 = new JLabel("  R3 ", SwingConstants.CENTER);
        lab3.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab3);
        panel1.add(r3);        
        JLabel lab4 = new JLabel("  R4 ", SwingConstants.CENTER);
        lab4.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab4);
        panel1.add(r4);
        JLabel lab5 = new JLabel("  R5 ", SwingConstants.CENTER);
        lab5.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab5);
        panel1.add(r5);        
        JLabel lab6 = new JLabel("  R6 ", SwingConstants.CENTER);
        lab6.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab6);  
        panel1.add(r6);
        JLabel lab7 = new JLabel("  R7 ", SwingConstants.CENTER);
        lab7.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab7);  
        panel1.add(r7);
        JLabel lab8 = new JLabel("  R8 ", SwingConstants.CENTER);
        lab8.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab8);  
        panel1.add(r8);
        JLabel lab9 = new JLabel("  R9 ", SwingConstants.CENTER);
        lab9.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab9);  
        panel1.add(r9); 
        JLabel lab10 = new JLabel("  R10", SwingConstants.CENTER);
        lab10.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab10);  
        panel1.add(r10); 
        JLabel lab11 = new JLabel("  R11", SwingConstants.CENTER);
        lab11.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab11);  
        panel1.add(r11);
        JLabel lab12 = new JLabel("  R12", SwingConstants.CENTER);
        lab12.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab12);  
        panel1.add(r12);   
        JLabel lab13 = new JLabel("  R13", SwingConstants.CENTER);
        lab13.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab13);  
        panel1.add(r13);
        JLabel lab14 = new JLabel("  R14", SwingConstants.CENTER);
        lab14.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab14);  
        panel1.add(r14);
        JLabel lab15 = new JLabel("  R15", SwingConstants.CENTER);
        lab15.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(lab15);  
        panel1.add(r15);       
        JLabel rlab16 = new JLabel("     ");
        rlab16.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab16);
        JScrollPane js = new JScrollPane(panel1);
        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
        js.addMouseListener(openHandler);
        add(js);
    }
    public void setRegBackground(int regno, Color c)
    {
        getRegField(regno).setBackground(c);
    }
        
    public void repaintFRegisters()
    {
        r0.setBackground(Color.white);
        r1.setBackground(Color.white);
        r2.setBackground(Color.white);
        r3.setBackground(Color.white);
        r4.setBackground(Color.white);
        r5.setBackground(Color.white);
        r6.setBackground(Color.white);
        r7.setBackground(Color.white);
        r8.setBackground(Color.white);
        r9.setBackground(Color.white);
        r10.setBackground(Color.white);
        r11.setBackground(Color.white);
        r12.setBackground(Color.white);
        r13.setBackground(Color.white);      
        r14.setBackground(Color.white);
        r15.setBackground(Color.white);
  //This needs to be reworked.          
         if (Memory.getReg1() != -1)
         {
            getRegField(Memory.getReg1()).setBackground(Color.green);
         }
         if (Memory.getReg2() != -1)
         {
            getRegField(Memory.getReg2()).setBackground(Color.red);
         }
        int iReg = Memory.getIndexReg();
        if ((iReg != -1) && (iReg !=0))
        {
           getRegField(Memory.getIndexReg()).setBackground(Color.lightGray);
        }        
        r0.setText(fregisters.getFRegister(0).toHexString().toUpperCase());
        r1.setText(fregisters.getFRegister(1).toHexString().toUpperCase());
        r2.setText(fregisters.getFRegister(2).toHexString().toUpperCase());
        r3.setText(fregisters.getFRegister(3).toHexString().toUpperCase());
        r4.setText(fregisters.getFRegister(4).toHexString().toUpperCase());
        r5.setText(fregisters.getFRegister(5).toHexString().toUpperCase());
        r6.setText(fregisters.getFRegister(6).toHexString().toUpperCase());
        r7.setText(fregisters.getFRegister(7).toHexString().toUpperCase());
        r8.setText(fregisters.getFRegister(8).toHexString().toUpperCase());
        r9.setText(fregisters.getFRegister(9).toHexString().toUpperCase());
        r10.setText(fregisters.getFRegister(10).toHexString().toUpperCase());
        r11.setText(fregisters.getFRegister(11).toHexString().toUpperCase());
        r12.setText(fregisters.getFRegister(12).toHexString().toUpperCase());
        r13.setText(fregisters.getFRegister(13).toHexString().toUpperCase());
        r14.setText(fregisters.getFRegister(14).toHexString().toUpperCase());
        r15.setText(fregisters.getFRegister(15).toHexString().toUpperCase());        
        repaint();
    }
    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }
    public JTextField getRegField(int i)
    {
        switch(i){
            case 0: return r0;
            case 1: return r1;
            case 2: return r2;
            case 3: return r3;
            case 4: return r4;
            case 5: return r5;
            case 6: return r6;
            case 7: return r7;
            case 8: return r8;
            case 9: return r9;
            case 10: return r10;
            case 11: return r11;
            case 12: return r12;
            case 13: return r13;
            case 14: return r14;
            case 15: return r15;            
        }
        return null;
    }
    private class mHandlerOpenPanel implements MouseListener
    {
        public void mouseClicked(MouseEvent e)
        {
           String sTitle = "Floating-point Registers";
           String sBody = "All floating-point instructions use the same 16 floating-point registers. " + 
                          "The floating-point registers are identified by the numbers 0-15 and are " + 
                          "designated by a four-bit R field in floating-point instructions. " + 
                          " Each floating-point register is 64 bits long and can contain either " + 
                          " a short (32-bit) or a long (64-bit) floating-point operand. " +
                          " A short floating-point datum requires only the leftmost 32 bit positions of " + 
                          " a floating-point register. The rightmost 32 bit positions of the register are " +
                          "ignored when the register is the source of an operand in the short format, and " + 
                          "they remain unchanged when a short result is placed in the register. " +
                          "A datum in the extended (128-bit) format occupies a register pair. Register pairs " +
                          "are formed by coupling the 16 registers as follows: 0 and 2, 4 and 6, 8 and 10, 12 and 14, " +
                          "1 and 3, 5 and 7, 9 and 11, and 13 and 15. Each of the eight pairs is referred to by " + 
                          "the number of the lower-numbered register of the pair."; 
          
                          InfoPanel GPR = new InfoPanel(sTitle, sBody, 250, 450, 1000, 300);     
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
