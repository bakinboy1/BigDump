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

public class ParmPanel extends JPanel
{
    private CPU cpu;
    private Memory memory;
    private Registers registers;
    private int noParms;  // the number of parameters
    private JTextField parm1;
    private JTextField parm2;
    private JTextField parm3;
    private JTextField parm4;
    private JTextField parm5;
    private JTextField parm6;
    private JTextField parm7;
    private JTextField parm8;
    private JTable parmTable;
    private JButton loadButton;
    private JButton clearButton;    
    private MemoryPanel mp;
    private RegisterPanel rp;
    private JTextArea message;
    private final String ZEROES36 = "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 " + 
                                    "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ";
    private final String ZEROES32 = "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 " + 
                                    "00 00 00 00 00 00 00 00 00 00 00 00 00 00 ";    
    public ParmPanel(CPU cpu, MemoryPanel mp, RegisterPanel rp)
    {
        super();
        this.cpu = cpu;
        this.mp = mp;
        this.rp = rp;
        memory = cpu.getMemory();
        registers = cpu.getRegisters();
        JPanel pan1 = new JPanel();
        //setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
        pan1.setLayout(new BoxLayout(pan1,BoxLayout.Y_AXIS));
        loadButton = new JButton("Load Parameters");
        loadButton.setFont(new Font("Courier", Font.BOLD, 24));
        loadButton.addActionListener(new LoadButtonListener());
        loadButton.setEnabled(true);
        clearButton = new JButton("Clear Parameter Table");
        clearButton.setFont(new Font("Courier", Font.BOLD, 24));
        clearButton.addActionListener(new ClearButtonListener());
        clearButton.setEnabled(true);        
        // add a mouse click listener
        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
        addMouseListener(openHandler); 
        //int fontSize = 18;

        setBackground(new Color(Integer.parseInt("ACE9A3",16)));
        Toolkit tk = Toolkit.getDefaultToolkit();
        Dimension d = tk.getScreenSize();
        int swidth = (int) d.getWidth();
        int sheight = (int) d.getHeight();
        int dimWidth1 = (int) (swidth * .5);
        int dimHeight1 = (int)(sheight * .8);
        int dimWidth2 = (int) (swidth * .3);
        int fontSize = 24;
        String[] columnNames = {"Parameter #",
                                "Parameter Value",
                               };
        Object[][] data = {
	    {"1", "40 40 20 3a b7"},
	    {"2", "11 22 33 44 55 66 77 88 99 aa bb"},
	    {"3", "ff ff ff ff"},
	    {"4", "40 40 20 3a b7"},
	    {"5", "11 22 33 44 55 66 77 88 99 aa bb"},
	    {"6", "ff ff ff ff"},
	    {"7", " "},
	    {"8", " "}	    
        };

        parmTable = new JTable();
        parmTable.getTableHeader().setFont(new Font("Courier", Font.BOLD, 30));
        parmTable.setModel(new MyDefaultTableModel(data, columnNames));
        parmTable.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
        parmTable.setRowHeight(50);
        parmTable.setFont(new Font("Courier", Font.BOLD, fontSize));
        parmTable.setPreferredScrollableViewportSize(new Dimension(1000, 400));
        parmTable.setFillsViewportHeight(true);
        JScrollPane pTS =new JScrollPane(parmTable);
        pan1.add(pTS);
        JPanel pan2 = new JPanel();
        pan2.setPreferredSize(new Dimension(500,60));
        pan2.setLayout(new GridLayout(1,2));
        pan2.add(loadButton);
        pan2.add(clearButton);
        pan1.add(pan2);
        add(pan1);
       

    }

        
    private class MyDefaultTableModel extends DefaultTableModel {  
     public MyDefaultTableModel(Object[][] data, Object[] columnNames) {  
       super(data,columnNames);  
     }  
     public boolean isCellEditable(int row, int col) {  
       return (col == 0)? false : true;
     }  
    }  
    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }
    private class LoadButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
            int numRows = 8;
            int numCols = parmTable.getColumnCount();
            javax.swing.table.TableModel model = parmTable.getModel();
            String parmData1 = model.getValueAt(0, 1) + " ";
            memory.loadString(parmData1, Runner.PARM1ADDR);
            String parmData2 = model.getValueAt(1, 1) + " ";
            memory.loadString(parmData2, Runner.PARM2ADDR);             
            String parmData3 = model.getValueAt(2, 1) + " ";
            memory.loadString(parmData3, Runner.PARM3ADDR);             
            String parmData4 = model.getValueAt(3, 1) + " ";
            memory.loadString(parmData4, Runner.PARM4ADDR);             
            String parmData5 = model.getValueAt(4, 1) + " ";
            memory.loadString(parmData5, Runner.PARM5ADDR);             
            String parmData6 = model.getValueAt(5, 1) + " ";
            memory.loadString(parmData6, Runner.PARM6ADDR);             
            String parmData7 = model.getValueAt(6, 1) + " ";
            memory.loadString(parmData7, Runner.PARM7ADDR); 
            String parmData8 = model.getValueAt(7, 1) + " ";
            memory.loadString(parmData8, Runner.PARM8ADDR); 
            int n = 0;
            if ( ! parmData1.trim().equals(""))
            {
               memory.toFullWordFromInt(Runner.PARMTABLE,   Runner.PARM1ADDR);
               n++;
            }
            if ( ! parmData2.trim().equals(""))
            {
               memory.toFullWordFromInt(Runner.PARMTABLE+4, Runner.PARM2ADDR);
               n++;
            }
            if ( ! parmData3.trim().equals(""))
            {
               memory.toFullWordFromInt(Runner.PARMTABLE+8, Runner.PARM3ADDR);
               n++;
            }
            if ( ! parmData4.trim().equals(""))
            {
              memory.toFullWordFromInt(Runner.PARMTABLE+12,Runner.PARM4ADDR);
              n++;
            }
            if ( ! parmData5.trim().equals(""))
            {
              memory.toFullWordFromInt(Runner.PARMTABLE+16,Runner.PARM5ADDR);
              n++;
            }
            if ( ! parmData6.trim().equals(""))
            {
              memory.toFullWordFromInt(Runner.PARMTABLE+20,Runner.PARM6ADDR);
              n++;
            }
            if ( ! parmData7.trim().equals(""))
            {
              memory.toFullWordFromInt(Runner.PARMTABLE+24,Runner.PARM7ADDR);
              n++;
            }
            if ( ! parmData8.trim().equals(""))
            {
              memory.toFullWordFromInt(Runner.PARMTABLE+28,Runner.PARM8ADDR);
              n++;
            }
            if (n > 0)
            {
                Registers regs = cpu.getRegisters();
                Register r1 = regs.getRegister(1);
                r1.setRegValue(Runner.PARMTABLE);
                Register r13 = regs.getRegister(13);
                r13.setRegValue(Runner.SAVEAREAADDRESS);
            }
            noParms = n;
            mp.repaintMemory();
            rp.repaintRegisters();           

        }
    }
        private class ClearButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
            int numRows = 8;
            int numCols = parmTable.getColumnCount();
            javax.swing.table.TableModel model = parmTable.getModel();
            model.setValueAt("",0, 1);
            memory.loadString(ZEROES36,Runner.PARM1ADDR);
            model.setValueAt("",1, 1);
            memory.loadString(ZEROES36,Runner.PARM2ADDR);  
            model.setValueAt("",2, 1);
            memory.loadString(ZEROES36,Runner.PARM3ADDR);
            model.setValueAt("",3, 1);
            memory.loadString(ZEROES36,Runner.PARM4ADDR);            
            model.setValueAt("",4, 1);
            memory.loadString(ZEROES36,Runner.PARM5ADDR);
            model.setValueAt("",5, 1);
            memory.loadString(ZEROES36,Runner.PARM6ADDR);  
            model.setValueAt("",6, 1);
            memory.loadString(ZEROES36,Runner.PARM7ADDR);
            model.setValueAt("",7, 1);
            memory.loadString(ZEROES32,Runner.PARMTABLE);  //clear the parm table with hex 0's  
            Registers regs = cpu.getRegisters();
            Register r1 = regs.getRegister(1);
            r1.setRegValue(0); //no parms
            mp.repaintMemory();
            rp.repaintRegisters();           

        }
    }

    public int getNoParms()
    {
        return noParms;
    }

    private class mHandlerOpenPanel implements MouseListener
    {
        public void mouseClicked(MouseEvent e)
        {
           String sTitle = "Parameters";
           String sBody = " VisibleZ supports parameter passing using standard linkage conventions. You " + 
                          " can create up to eight parameters, each with a maximum size of 36 bytes.    " + 
                          " After entering each parameter into the table as a sequence hexadecimal " + 
                          " pairs, press the Load button to enter the parameters into the OS memory area." +
                          " Register 1 will be initialized with the address of a table of parameter " +
                          " addresses as indicated below: \n" +   
                          " R1 ====>                      \n" +
                          "                    |A(Parm 1)|\n" + 
                          "                    |A(Parm 2)|\n" +
                          "                        ...    \n"     +
                          "                    |A(Parm n)|.";   
          
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
