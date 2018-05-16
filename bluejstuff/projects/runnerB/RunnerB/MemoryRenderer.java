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

import java.awt.*;
import javax.swing.*;
import javax.swing.table.*;

public class MemoryRenderer extends DefaultTableCellRenderer
{
   PSW psw;
   Memory memory;
   CPU cpu;
   
   public void setPSW(PSW psw)
   {
       this.psw = psw;
   }
   public void setMemory(Memory memory)
   {
       this.memory = memory;
   }
   public void setCPU(CPU cpu)
   {
       this.cpu = cpu;
   }
   public Component getTableCellRendererComponent(
          JTable jtab, 
          Object v,
          boolean selected,
          boolean focus,
          int r,
          int c)
   {
       JLabel rendComp = (JLabel) super.getTableCellRendererComponent(jtab, v, selected, focus, r, c);
         //Register r1 = Memory.getReg1();
         //Register r2 = Memory.getReg2();
         
         int iS = Memory.getInstructionStart();
         int iE = Memory.getInstructionEnd();
         int s = Memory.getSource();
         int sRow = -1;  //assume there is no source row
         int sCol = -1;  //assume there is no source column
         if (s != -1)   //s == -1 when there is no source in memory
         {
            sRow = addressToRow(s);
            sCol = addressToColumn(s);
         }
         int t = Memory.getTarget();
         int tRow = -1;  //assume there is no source row
         int tCol = -1;  //assume there is no source column
         if (t != -1)   //s == -1 when there is no source in memory
         {
            tRow = addressToRow(t);
            tCol = addressToColumn(t);
         }
         int instrStartRow = addressToRow(iS);
         int instrStartColumn = addressToColumn(iS);
         int instrEndRow = addressToRow(iE);
         int instrEndColumn = addressToColumn(iE);
         int saveAreaStartRow = addressToRow(Runner.SAVEAREAADDRESS);
         int saveAreaStartCol = addressToColumn(Runner.SAVEAREAADDRESS);
         int saveAreaEndRow = addressToRow(Runner.SAVEAREAADDRESS + 72);
         int saveAreaEndColumn = addressToColumn(Runner.SAVEAREAADDRESS + 72);

         if ((sRow == r) && (sCol == c) )
            rendComp.setBackground(Color.green);
         else
         if ((instrStartRow == instrEndRow) && (r == instrStartRow) && (instrStartColumn <= c) && (c <= instrEndColumn))
            rendComp.setBackground(Color.yellow);
         else
         if ((instrStartRow == instrEndRow - 1) && (r == instrStartRow) && (instrStartColumn <= c) && (c  <= 40))
            rendComp.setBackground(Color.yellow);
         else
         if ((instrStartRow == instrEndRow - 1) && (r == instrEndRow) && (c  <= instrEndColumn))
            rendComp.setBackground(Color.yellow);   
         else

         if ((tRow == r) && (tCol == c))
            rendComp.setBackground(Color.pink);
         else         
         if ((c == 1) || (c == 6) || (c == 11) || (c == 16) ) 
            rendComp.setBackground(new Color(Integer.parseInt("FFF0B2",16)));
         else
        
         if (c == 0)
             rendComp.setBackground(new Color(Integer.parseInt("FFF7CD",16)));
            //rendComp.setBackground(new Color(255,242,115));
         else    
         if (((r == saveAreaStartRow) && (c >= saveAreaStartCol) && (c != 0) && (c != 1)) || 
                             ((r > saveAreaStartRow) && (c != 0) && (c != 1)))
           rendComp.setBackground(Color.lightGray);
         else   
           rendComp.setBackground(Color.white);
       return rendComp;
    }
    /*
     * Converts a memory address to a row number in the memory panel
     */
    public int addressToRow(int addr)
    {
        return addr / 16;      
    }
    /*
     * Converts a memory address to a column number in the memory panel
     */
    public int addressToColumn(int addr)
    {
        if (addr < 0) 
        {
            addr = - addr;
        }
        //array converts a memory address to a column number
        int[] dp = {2,3,4,5,7,8,9,10,12,13,14,15,17,18,19,20};
        return dp[addr % 16];
    }
        
}
