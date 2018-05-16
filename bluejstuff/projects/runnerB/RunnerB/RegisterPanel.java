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

public class RegisterPanel extends JPanel
{
    private CPU cpu;
    private Registers registers;
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
    
    
    public RegisterPanel(CPU cpu)
    {
        super();
        this.cpu = cpu;
        registers = cpu.getRegisters();
        registers.randomize();
        // add a mouse click listener
//        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
//        addMouseListener(openHandler); 
        r0 = new JTextField(18); 
        r0.setText("   " + registers.getRegister(0).longRegToHexString().toUpperCase());
        r0.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r1 = new JTextField(18);
        r1.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r1.setText("   " + registers.getRegister(1).longRegToHexString().toUpperCase());
        r1.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r2 = new JTextField(18);
        r2.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r2.setText("   " + registers.getRegister(2).longRegToHexString().toUpperCase());  
        r2.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r3 = new JTextField(18); 
        r3.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r3.setText("   " + registers.getRegister(3).longRegToHexString().toUpperCase());
        r4 = new JTextField(18);
        r4.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r4.setText("   " + registers.getRegister(4).longRegToHexString().toUpperCase());
        r5 = new JTextField(18);
        r5.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r5.setText("   " + registers.getRegister(5).longRegToHexString().toUpperCase()); 
        r6 = new JTextField(18); 
        r6.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r6.setText("   " + registers.getRegister(6).longRegToHexString().toUpperCase());
        r7 = new JTextField(18);
        r7.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r7.setText("   " + registers.getRegister(7).longRegToHexString().toUpperCase());
        r8 = new JTextField(18);
        r8.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r8.setText("   " + registers.getRegister(8).longRegToHexString().toUpperCase()); 
        r9 = new JTextField(18); 
        r9.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r9.setText("   " + registers.getRegister(9).longRegToHexString().toUpperCase());
        r10 = new JTextField(18);
        r10.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r10.setText("   " + registers.getRegister(10).longRegToHexString().toUpperCase());
        r11 = new JTextField(18);
        r11.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r11.setText("   " + registers.getRegister(11).longRegToHexString().toUpperCase()); 
        r12 = new JTextField(18); 
        r12.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r12.setText("   " + registers.getRegister(12).longRegToHexString().toUpperCase());
        r13 = new JTextField(18);
        r13.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r13.setText("   " + registers.getRegister(13).longRegToHexString().toUpperCase());
        r14 = new JTextField(18);
        r14.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r14.setText("   " + registers.getRegister(14).longRegToHexString().toUpperCase());         
        r15 = new JTextField(18);
        r15.setFont(new Font("Courier New", Font.BOLD, Runner.FONT3));
        r15.setText("   " + registers.getRegister(15).longRegToHexString().toUpperCase());
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
        //setBackground (new Color(255,219,118));
        Toolkit tk = Toolkit.getDefaultToolkit();
        Dimension d = tk.getScreenSize();
        int swidth = (int) d.getWidth();
        int sheight = (int) d.getHeight();
        int dimWidth = 270;
        int dimHeight = (int)(sheight * Runner.HEIGHTFACTOR);
        JPanel panel1 = new JPanel();
        panel1.setPreferredSize (new Dimension(dimWidth,dimHeight));
       // panel1.setLayout (new BoxLayout (panel1, BoxLayout.Y_AXIS));
        panel1.setLayout(new GridLayout(33,1));
        panel1.setOpaque(true);
               
        JLabel rlab0 = new JLabel("  R0 ",SwingConstants.CENTER);
        rlab0.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.setBackground (new Color(Integer.parseInt("FFF7CD",16)));
        panel1.add(rlab0);
        panel1.add(r0);
        JLabel rlab1 = new JLabel("  R1 ",SwingConstants.CENTER);
        rlab1.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab1);
        panel1.add(r1);
        JLabel rlab2 = new JLabel("  R2 ",SwingConstants.CENTER);
        rlab2.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab2);
        panel1.add(r2);
        JLabel rlab3 = new JLabel("  R3 ",SwingConstants.CENTER);
        rlab3.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab3);
        panel1.add(r3);
        JLabel rlab4 = new JLabel("  R4 ",SwingConstants.CENTER);
        rlab4.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab4);
        panel1.add(r4);
        JLabel rlab5 = new JLabel("  R5 ",SwingConstants.CENTER);
        rlab5.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab5); 
        panel1.add(r5);
        JLabel rlab6 = new JLabel("  R6 ",SwingConstants.CENTER);
        rlab6.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab6); 
        panel1.add(r6);
        JLabel rlab7 = new JLabel("  R7 ",SwingConstants.CENTER);
        rlab7.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab7); 
        panel1.add(r7);
        JLabel rlab8 = new JLabel("  R8 ",SwingConstants.CENTER);
        rlab8.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab8); 
        panel1.add(r8);
        JLabel rlab9 = new JLabel("  R9 ",SwingConstants.CENTER);
        rlab9.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab9); 
        panel1.add(r9);
        JLabel rlab10 = new JLabel("  R10",SwingConstants.CENTER);
        rlab10.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab10); 
        panel1.add(r10);
        JLabel rlab11 = new JLabel("  R11",SwingConstants.CENTER);
        rlab11.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab11); 
        panel1.add(r11);
        JLabel rlab12 = new JLabel("  R12",SwingConstants.CENTER);
        rlab12.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab12); 
        panel1.add(r12);
        JLabel rlab13 = new JLabel("  R13",SwingConstants.CENTER);
        rlab13.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab13); 
        panel1.add(r13);
        JLabel rlab14 = new JLabel("  R14",SwingConstants.CENTER);
        rlab14.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab14); 
        panel1.add(r14);
        JLabel rlab15 = new JLabel("  R15",SwingConstants.CENTER);
        rlab15.setFont(new Font("Courier", Font.BOLD, Runner.FONT1));
        panel1.add(rlab15); 
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
        
    public void repaintRegisters()
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

        int mreg1 = Memory.getReg1();
        if (mreg1 > 0)
        {
           getRegField(mreg1).setBackground(Color.green);
        }
        int mreg2 = Memory.getReg2();
        if (mreg2 > 0)
        {
           getRegField(mreg2).setBackground(Color.pink);
        }
        int iReg = Memory.getIndexReg();
        if (iReg > 0)
        {
           getRegField(iReg).setBackground(Color.lightGray);
        }
        int bReg1 = Memory.getBaseReg1();
        if (bReg1 > 0)
        {
            //Color lightBlue= new Color(0,171,255);
            Color lightBlue = new Color(Integer.parseInt("7DBBCF",16));
            getRegField(bReg1).setBackground(lightBlue);
        }
        int bReg2 = Memory.getBaseReg2();
        if (bReg2 > 0)
        {
           // Color lightBlue= new Color(0,171,255);
            Color lightBlue = new Color(Integer.parseInt("7DBBCF",16));            
            getRegField(bReg2).setBackground(lightBlue);
        }   
        
        r0.setText("   " + registers.getRegister(0).longRegToHexString().toUpperCase());
        r1.setText("   " + registers.getRegister(1).longRegToHexString().toUpperCase());
        r2.setText("   " + registers.getRegister(2).longRegToHexString().toUpperCase());
        r3.setText("   " + registers.getRegister(3).longRegToHexString().toUpperCase());
        r4.setText("   " + registers.getRegister(4).longRegToHexString().toUpperCase());
        r5.setText("   " + registers.getRegister(5).longRegToHexString().toUpperCase());
        r6.setText("   " + registers.getRegister(6).longRegToHexString().toUpperCase());
        r7.setText("   " + registers.getRegister(7).longRegToHexString().toUpperCase());
        r8.setText("   " + registers.getRegister(8).longRegToHexString().toUpperCase());
        r9.setText("   " + registers.getRegister(9).longRegToHexString().toUpperCase());
        r10.setText("   " + registers.getRegister(10).longRegToHexString().toUpperCase());
        r11.setText("   " + registers.getRegister(11).longRegToHexString().toUpperCase());
        r12.setText("   " + registers.getRegister(12).longRegToHexString().toUpperCase());
        r13.setText("   " + registers.getRegister(13).longRegToHexString().toUpperCase());
        r14.setText("   " + registers.getRegister(14).longRegToHexString().toUpperCase());
        r15.setText("   " + registers.getRegister(15).longRegToHexString().toUpperCase());
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
           String sTitle = "General Registers";
           String sBody = "General registers (GRs) are used to keep temporary data (operands) loaded " + 
                          "from memory to be processed or already processed. Instructions may designate " + 
                          "information in one or more of 16 general registers. The general registers may" + 
                          " be used as base-address registers and index registers in address arithmetic, " + 
                          " and as accumulators in general arithmetic and logical operations. Each register" + 
                          " contains 64 bit positions. The general registers are identified by the numbers 0-15," + 
                          " and are designated by a four-bit R field in an instruction.";   
          
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
