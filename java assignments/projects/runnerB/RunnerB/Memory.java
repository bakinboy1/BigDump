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

import javax.swing.JOptionPane;
import java.util.Scanner;
import java.io.*;
/**
 * The memory class simulates memory on an IBM System/360.
 * 
 * @author Woolbright 
 * @version 
 */
public class Memory
{
    // instance variables 
    private  Byte[] memory;
    private int size;
    private static int instructionStart;
    private static int instructionEnd;
    private static int source;
    private static int target;
    private static int Reg1;
    private static int Reg2;
    private static int IndexReg;
    private static int baseReg1;
    private static int baseReg2;
    /**
     * Constructor for objects of class Memory
     */
    public Memory(int size)
    {
        // initialise instance variables
        setSize(size);
        memory = new Byte[size];
        for (int i = 0; i < size; i++)
        {
            memory[i] = new Byte("0");
        }
    }
    public void load(String fname)
    {
        String line = "";
        Scanner scanner = null;
        try {
             scanner = new Scanner(new FileInputStream(fname));
             line = scanner.nextLine();
        }
        catch (IOException e)
        {
            System.out.println(e);
        }
        
        if (!line.contains("|") && !line.contains("/"))
        {    //Standard input record reader
            
           try {
               scanner.close();
               scanner = new Scanner(new FileInputStream(fname));
               int i = 0;
               while (scanner.hasNext())
               {
                   String temp = scanner.next().toLowerCase();
                   int x = Hex.toIntFromHexString2(temp);
                   setByte(i, new Byte(Integer.toString(x)));
                   i++;
               }
               scanner.close();
           }
           catch(IOException e)
           {
              System.out.println(e);
           }
        }
        //  Neal's input record reader
        else if (line.contains("/"))
        {
            try 
            {
               scanner.close();
               scanner = new Scanner(new FileInputStream(fname));
               int i = 0;
               int maxAddress = 0;
               while (scanner.hasNextLine()) 
               {
                  line = scanner.nextLine();
                  if (line.length() <= 1)   //check for eof
                  {
                  }
                  else
                  {
                     while(line.contains("BASE") || line.contains(" EQU "))
                     {
                         line = scanner.nextLine();   
                     }
                     line = line.replace("/"," /");
                     int pos = line.indexOf("/");                     
                     if (!line.substring(0,1).equals(" "))
                     {
                        Scanner byteScan = new Scanner(line);
                        //  int pos = line.indexOf("/");
                        if (pos+1 == line.length())    //Does line end with "/"?
                        {
                          line = line.replace("/","/   ");   //adjust for lines that end in "/"
                        }
                        String str = line.substring(pos+1,pos+4);   //assumes 3 digits here
                        if (!str.equals("   "))
                        {
                           i = Integer.parseInt(str,16);
                           if (i <= maxAddress)
                           {
                               i = maxAddress;
                           }
                        }
                        while (byteScan.hasNext())
                        {
                           String b = byteScan.next().toLowerCase();
                           if (!b.contains("/"))
                           {
                              int x = Hex.toIntFromHexString2(b);
                              setByte(i, new Byte(Integer.toString(x)));
                              i++;
                              maxAddress = i;
                              
                           }
                           else
                           {
                              byteScan.skip(".*");  //skip everthing else
                           }
                        }
                        byteScan.close();
                     }
                  }
               }
               scanner.close();
            }
            catch (FileNotFoundException e) 
            {    
               e.printStackTrace();
            }
        }
        //  My input object record reader
        else if (line.contains("|"))         
        {
            try 
            {
                scanner.close();
                scanner = new Scanner(new FileInputStream(fname));
                int i = 0;
                while (scanner.hasNextLine()) 
                {
                    line = scanner.nextLine();
                    if (line.length() > 1 && line.substring(0,1).equals(" ") && line.contains(" DS "))
                    {
                        line = line.replace('|',' ');
                        Scanner temp1 = new Scanner(line);
                        String p = temp1.next();
                        i = Integer.parseInt(p,16);
                        int loc = line.indexOf(" DS ");
                        String temp = line.substring(loc+4);
                        Scanner ts = new Scanner(temp);
                        int q = Integer.parseInt(ts.findInLine("\\d+"));
                        for (int k = 0; k < q; k++)
                        {
                            setByte(i, new Byte(Integer.toString(0)));
                            i++;
                        }
                    }
                    else if (line.length() > 1 && !line.substring(0,1).equals(" "))
                    {
                        Scanner scan = new Scanner(line);
                        boolean NOTFOUND = true;
                        while (NOTFOUND && scan.hasNext())
                        {
                            String token = scan.next().toLowerCase();
                            if (token.contains("|"))
                            {
                                if (!token.substring(0,1).equals("|"))
                                {
                                    int index = token.indexOf('|');
                                    token = token.substring(0,index);
                                    int x = Hex.toIntFromHexString2(token);
                                    setByte(i, new Byte(Integer.toString(x)));
                                    i++;
                                }
                                NOTFOUND = false;
                            }
                            else
                            {
                                int x = Hex.toIntFromHexString2(token);
                                setByte(i, new Byte(Integer.toString(x)));
                                i++;
                            }
                        }
                        scan.close();
                    }
                }
                scanner.close();
            }
            catch (FileNotFoundException e) 
            {    
                e.printStackTrace();
            }
        }
    }
    public void loadAlt(String fname)
    {
        try {
               Scanner scan = new Scanner(new FileInputStream(fname));
               int i = 0;
               while (scan.hasNext())
               {
                   String temp = scan.next().toLowerCase();
                   int x = Hex.toIntFromHexString2(temp);
                   setByte(i, new Byte(Integer.toString(x)));
                   i++;
               }
               scan.close();
            }
        catch(IOException e)
        {
            System.out.println(e);
        }
    }    
    public void loadString(String aString,int address)
    {
            Scanner scan = new Scanner(aString);
            int i = address;
            while (scan.hasNext())
            {
                String temp = scan.next().toLowerCase();
                int x = 0;
                try
                {
                  x = Hex.toIntFromHexString2(temp);
                  setByte(i, new Byte(Integer.toString(x)));
                }
                catch (NumberFormatException e)
                {
                    System.err.println("A badly formed parameter was entered.  Enter a series of hexadecimal digits separated by one or more spaces.");
                    System.err.println("Example:  11 22 33 44 35 ab cf 3a");
                    System.err.println("Also, the number of parameters must be between 0 and 8.");
                }
                i++;
            }
            scan.close();
    }    
    public void loadDeviceDrivers()
    {
        String drivers = "0a 16 07 fe 0a 15 07 fe 1b 11 07 f1 1b 11 1b 11";
        Scanner scan = new Scanner(drivers);
        int i = Runner.FILEREADER;
        while (scan.hasNext())
        {
            String temp = scan.next();
            int x = Hex.toIntFromHexString2(temp);
            setByte(i, new Byte(Integer.toString(x)));
            i++;
        }
        scan.close();
    }
    public void setSize(int size)
    {
        this.size = size;
    }
    public int getSize()
    {
        return size;
    }
    public Byte getByte(int i) 
    {
        if ((i >= 0) && (i < size))
        {
           return memory[i];
        }
        else
        {
            JOptionPane.showMessageDialog(null,"(Protection exeception) Memory reference out of bounds:  " + i);
            return -1;
        }
    }
    public String getByteAsString(int i)
    {
        if ((i >= 0) && (i < size))
        {
           int b = (int) getByte(i);
           String temp = Integer.toHexString(b);
           int n = temp.length();
           if (n < 2) 
           {
               temp = "0" + temp;
               n = temp.length();
           }
           temp = temp.substring(n-2,n);  //needed?
           return temp;
        }
        else
        {
            JOptionPane.showMessageDialog(null,"(Protection exeception) Memory reference out of bounds:  " + i);
            return "";
        }        
    }
    public void setByte(int i, Byte b)
    {
        if ((i >= 0) && (i < size))
        {
           memory[i] = b;
        }
        else
        {
            JOptionPane.showMessageDialog(null,"(Protection exeception) Memory reference out of bounds:  " + i);
        }        
    }
    public String toString()
    {
        String temp = " ";
        for (int i = 0; i < size; i++)
        {
            String addr = Integer.toHexString(i);
            int len = addr.length();
            for (int j = 0; j < 8 - len; j++)
                addr = "0" + addr;
            if ((i % 32) == 0)
               temp += addr + "    ";
            int val = memory[i].intValue();
            String hexString = Integer.toHexString(val);
            if (hexString.length() == 1)
               hexString = "0" + hexString;
            if (hexString.length() > 2)
               hexString = hexString.substring(6);
            temp += hexString;
            if ((i % 4) == 3)
               temp += " ";
            if ((i % 16) == 15)
               temp += " ";
            if ((i % 32) == 31)
               temp += "\n ";
        }
        return temp;
    }
    public String[][] toTableArray()
    {
        int tabRows = (memory.length % 8 == 0)? (memory.length / 8) : (memory.length / 8) + 1;
        final int tabCols = 21;
        String[][] temp = new String[tabRows][tabCols];
        int i = 0;
        int r = 0;
        while ((r < tabRows) && (i < memory.length))
        {
            String addr = Integer.toHexString(i);
            int len = addr.length();
            for (int j = 0; j < 8 - len; j++)
                addr = "0" + addr;
            temp[r][0] = "   " + addr;
            temp[r][1] = "  ";
            int k=2; 
            while ((k < tabCols) && (i < memory.length))
            {
              if ((k % 5) == 1)
              {
                 temp[r][k] = "  ";
                 k = k + 1;
              }
              int val = memory[i].intValue();
              String hexString = Integer.toHexString(val);
              if (hexString.length() == 1)
                 hexString = "0" + hexString;
              if (hexString.length() > 2)
                 hexString = hexString.substring(6);
              temp[r][k] = hexString;
              k++;
              i++;
            }
            r++;
        }  
        return temp;
    }
    
    public static short toShortFromTwoBytes(Byte x0, Byte x1)
    {
        short p = 0;
        int a = x0;
        a = a << 8;
        int b = x1;
        b = b << 24;
        b = b >>> 24;
        p =  (short) (a | b);
        return  p;
    }
    public static int toIntFromTwoBytes(Byte x0, Byte x1)
    {
        int p = 0;
        int a = x0;
        a = a << 8;
        int b = x1;
        b = b << 24;
        b = b >>> 24;
        p =  a | b;
        return  p;
    }
    public static int toIntFromFourBytes(Byte x0, Byte x1, Byte x2, Byte x3)
    {
        int p = 0;
        int a = x0;
        a = a << 24;
        int b = x1;
        b = b << 24;
        b = b >>> 8;
        int c = x2;
         c = c << 24;
         c = c >>> 16;
        int d = x3;
        d = d << 24;
        d = d >>> 24;
        p = a | b | c | d;
        return p;
    }
    public static long toLongFromEightBytes(Byte x0, Byte x1, Byte x2, Byte x3, Byte x4, Byte x5, Byte x6, Byte x7)
    {
        long p = 0;
        long a = x0;
        a = a << 56;
        long b = x1;
        b = b << 56;
        b = b >>> 8;
        long c = x2;
         c = c << 56;
         c = c >>> 16;
        long d = x3;
        d = d << 56;
        d = d >>> 24;
        long e = x4;
        e = e << 56;
        e = e >>> 32;
        long f = x5;
        f = f << 56;
        f = f >>> 40;
        long g = x6;
        g = g << 56;
        g = g >>> 48;
        long h = x7;
        h = h << 56;
        h = h >>> 56;
        p = a | b | c | d | e | f | g | h;
        return p;
    }

    public void toFullWordFromInt(int addr, int x)
    {
        int x1 = x;
        x1 = x1 << 24;
        x1 = x1 >>> 24;
        Byte b4 = new Byte((byte) x1);
        x1 = x;
        x1 = x1 << 16;
        x1 = x1 >> 24;
        Byte b3 = new Byte((byte) x1);
        x1 = x;
        x1 = x1 << 8;
        x1 = x1 >> 24;
        Byte b2 = new Byte((byte) x1);
        x1 = x;
        x1 = x1 >> 24;
        Byte b1 = new Byte((byte) x1);
        setByte(addr, b1);
        setByte(addr+1,b2);
        setByte(addr+2,b3);
        setByte(addr+3,b4);
    }    
    public int getNumeric(int i)
    {
      int a = (int) getByte(i);
      a = a << 28;
      a = a >>> 28;
      return a;
    }
    public void setNumeric(int i,int val)
    {
      int a = (int) getByte(i);
      a = a >> 4;
      a = a << 4;
      a = a | val;
      Byte b = new Byte((byte) a);
      setByte(i, b);
    }    
    public int getZone(int i)
    {
      int a = (int) getByte(i);
      a = a << 24;
      a = a >>> 28;
      return a;
    }      
    public void setZone(int i,int val)
    {
      int a = (int) getByte(i);
      a = a << 28;
      a = a >>> 28;
      val = val << 4;
      a = a | val;
      Byte b = new Byte((byte) a);
      setByte(i,b);
    }        
//     public void setHighlighting(int iS, int iE, int s, int t, int R1, int R2, int X2)
//     {
//         
//         instructionStart = iS;
//         instructionEnd = iE;
//         source = s;
//         target = t;
//         Reg1 = R1;
//         Reg2 = R2;
//         IndexReg = X2;
//     }  
    public void setHighlighting(int iS, int iE, int s, int t, int R1, int R2, int X2, int bR1, int bR2)  //
    {
        
        instructionStart = iS;
        instructionEnd = iE;
        source = s;
        target = t;
        Reg1 = R1;
        Reg2 = R2;
        IndexReg = X2;
        baseReg1 = bR1;
        baseReg2 = bR2;
    }  
    public static int getInstructionStart()
    {
        return instructionStart;
    }
    public static int getInstructionEnd()
    {
        return instructionEnd;
    }
    public static int getSource()
    {
        return source;
    }
    public static int getTarget()
    {
        return target;
    }
    public static int getReg1()
    {
        return Reg1;
    }
    public static int getReg2()
    {
        return Reg2;
    }
    public static int getIndexReg()
    {
        return IndexReg;
    }
    public static int getBaseReg1()  //
    {
        return baseReg1;
    }
    public static int getBaseReg2()  //
    {
        return baseReg2;
    }
}
