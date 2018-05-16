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
import javax.swing.table.*;
import java.awt.*;
import java.awt.event.*;

public class MemoryPanel extends JPanel
{
    private CPU cpu;
    private JTable table;

    private JScrollPane areaScrollPane;
    private JTextArea textarea;

        private String[] columnNames = {"Address ","  ","00","  ","  ","  "," ","04","  ","  ","  "," ",
                                              "08","  ","  ","  "," ","0c","  ","  ","  "
	                                   };
        private Object[][] data = {{"00000000","00","01","02","03"," ","00","01","02","03"," ",
                                          "00","01","02","03"," ","00","01","02","03"},
                                   {"00000000","00","01","02","03"," ","00","01","02","03"," ",
                                          "00","01","02","03"," ","00","01","02","03"},
                                   {"00000000","00","01","02","03"," ","00","01","02","03"," ",
                                          "00","01","02","03"," ","00","01","02","03"}                                       
                                        };    
    public MemoryPanel(CPU cpu)
    {
        this.cpu = cpu;
        setBackground (new Color(7,26,113));
        //setPreferredSize (new Dimension(1300,800));
        //textarea = new JTextArea(cpu.getMemory().toString());
        //textarea.setFont(new Font("Courier", Font.PLAIN, 24));
        //textarea.setEditable(false);
        //areaScrollPane = new JScrollPane(textarea);
        Memory mem = cpu.getMemory();
        data = mem.toTableArray();
        //table = new JTable(data,columnNames);
        table = new JTable(new MemoryTableModel(data.length));   //default column and selection models used
        table.getTableHeader().setFont(new Font("Monospaced", Font.BOLD, Runner.FONT5));
        //table.setCellSelectionEnabled(true);                     //allow cell selection in the table -outdated
        //ListSelectionModel selModel = table.getSelectionModel()
        
        //TableCellRenderer tr = table.getCellRenderer(1,1);
        //Component jl = tr.getTableCellRendererComponent(table,"xy",false,false,1,1);
        //jl.setBackground(Color.RED);
        MemoryRenderer mr = new MemoryRenderer();
        mr.setHorizontalAlignment( SwingConstants.CENTER );
        mr.setPSW(cpu.getPSW());
        mr.setMemory(mem);
        mr.setCPU(cpu);
        table.setDefaultRenderer(Object.class, mr);
        
        //table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
       

        TableColumn col = table.getColumnModel().getColumn(0);
        
         Toolkit tk = Toolkit.getDefaultToolkit();
         Dimension d = tk.getScreenSize();
         int swidth = (int) d.getWidth();
         int sheight = (int) d.getHeight();
         int fontSize = swidth / 60;  //was 100
         table.setFont(new Font("Monospaced", Font.BOLD,fontSize));
         //int width = 80;
         int width = (int)((swidth - 250) * .2); //was .092
         
        col.setPreferredWidth(width);
        col = table.getColumnModel().getColumn(1);
        
        
        //width = (int) (d.getWidth() * .028);
        //width = (int) (d.getWidth() * (50 * 1440)/1920D);
        //width = 20;
         width = (int)((swidth - 250) * .04);
         col.setPreferredWidth(width);
        for(int i=2; i < 21; i++)
        {
            col = table.getColumnModel().getColumn(i);
            //width = (int) (d.getWidth() * .018);
            //width = (int) (d.getWidth() * (30 * 1440)/1920D);
            //width = 25;

            width = (int)((swidth - 250) * .05);//was swidth - 330
            col.setPreferredWidth(width);
        }
        
        table.setRowHeight(sheight / 30);
        //table.setPreferredScrollableViewportSize(new Dimension(500, 70));
        //table.setFillsViewportHeight(true);
        areaScrollPane = new JScrollPane(table);
        areaScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        areaScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        
//         width = (int) (d.getWidth() * .698);
//         int height = (int) (d.getHeight() * .708);
//         areaScrollPane.setPreferredSize(new Dimension(width, height));
        int dimWidth = swidth - 260;
        int dimHeight = (int)(sheight * .77);
        areaScrollPane.setPreferredSize(new Dimension(dimWidth, dimHeight));
        //areaScrollPane.setPreferredSize(new Dimension(1250, 850));        
        //add(textarea);
        add(areaScrollPane);
    }
    public void repaintMemory()
    {   
        //TableModel tm = table.getModel();
        TableModel tm = new MemoryTableModel(data.length);
        data = cpu.getMemory().toTableArray();
        for (int i= 0; i < data.length; i++)
        {
            for(int j = 0; j < data[0].length; j++)
            {
                tm.setValueAt(data[i][j], i,j);
            }
        }
        PSW psw = cpu.getPSW();
        int adr = psw.fetchInstructionAddress();

        // add a mouse listener to the Memory panel to open info panel
        mHandlerOpenPanel openHandler = new mHandlerOpenPanel();
        areaScrollPane.addMouseListener(openHandler);        
        areaScrollPane.repaint();
    }
    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }

    private class MemoryTableModel extends AbstractTableModel
    {
       private int rows = 0;
       
       public MemoryTableModel(int rows)
       {
          super();
          this.rows = rows;
       }
       public int getColumnCount() { return 21;}
       public int getRowCount()
       {
           return rows;
       }
       public String getColumnName(int c)
       {
          return columnNames[c];
       }
       public Class getColumnClass(int c)
       {
           return String.class;
       }
       public Object getValueAt(int r, int c)
       {
          return data[r][c];
       }
    
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
   
          InfoPanel PSWhint = new InfoPanel(sTitle, sBody, 250, 260, 150, 90);     
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
