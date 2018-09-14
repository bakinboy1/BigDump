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

import java.util.Scanner;
import java.io.PrintWriter;
import java.io.File;

/**
 * The Channel provides IO Services.
 * 
 * @author David Woolbright
 * @version 2012
 */
public class Channel
{
 
    private static Scanner SYSIN;
    private static File SYSOUT;
    private static Scanner filein1 = null;
    private static Scanner filein2 = null;
    private static Scanner filein3 = null;
    private static PrintWriter fileout1 = null;
    private static PrintWriter fileout2 = null;
    private static PrintWriter fileout3 = null;
    private Memory memory;
    private Registers registers;
    private FRegisters fregisters;
    private PSW psw;
    private OpenDCBs opendcbs;
    
    /**
     * Constructor for objects of class Channel
     */
    public Channel(Memory m, Registers r, FRegisters fr,PSW psw)
    {
        //fileSystem = HashMap<String,File>;  //(DDNAME,File)
        SYSIN = new Scanner(System.in);
        memory = m;
        registers = r;
        fregisters = fr;
        this.psw = psw;
        opendcbs = new OpenDCBs();

        
    }
    /**
     * svc - Ask the OS for service.
     *  
     */
    public static final int OPEN = 19;
    public static final int CLOSE = 20;
    public static final int PUT = 21;
    public static final int GET = 22;
    public static final int DEVICEDISP = 49;   //displacement to the address of the device driver in the DCB

    /**
     * Open -An example of a method - replace this comment with your own
     * 
     */
    public void open(DCB dcb)
    {
        int val = dcb.getPhysicalAddress();
        opendcbs.add(val,dcb);
        if (dcb.getMode().equals("Input"))
        {
            int addr = psw.fetchInstructionAddress();
            addr = addr - 6;  //Backup to find the DCB address
            Byte b0 = new Byte("0"); //ignore first byte
            Byte b1 = memory.getByte(addr+1);
            Byte b2 = memory.getByte(addr+2);
            Byte b3 = memory.getByte(addr+3);
            addr = memory.toIntFromFourBytes(b0,b1,b2,b3);
            
            
            String deviceHandler = Integer.toHexString(Runner.FILEREADER);  //File reader address
            while (deviceHandler.length() < 8)
            {
                deviceHandler = "0" + deviceHandler;
            }
            //change the dcb to point to the device handler
            addr = addr + DEVICEDISP;
            for(int i=0; i < 4; i++)
		    {
		       String hxst2 = deviceHandler.substring(2 * i, 2 * i + 2);
               int ival = Hex.toIntFromHexString2(hxst2);
               memory.setByte(addr,new Byte((byte) ival));
               addr = addr + 1;
            }
            String fileName = dcb.getDDName();
            String fileno = fileName.substring(6,7);
            String physicalFname = dcb.getPhysicalName();
            try {              
                   if (fileno.equals("1")) filein1 = new Scanner(new File(physicalFname));
                   if (fileno.equals("2")) filein2 = new Scanner(new File(physicalFname));
                   if (fileno.equals("3")) filein3 = new Scanner(new File(physicalFname));
            }
            catch(Exception e) 
            {
                System.out.println(e);
                System.out.println("File " + fileName + " could not be opened.");
            }
        }
        if (dcb.getMode().equals("Output"))
        {
            int addr = psw.fetchInstructionAddress();
            addr = addr - 6;  //Backup to find the DCB address
            Byte b0 = new Byte("0"); //ignore first byte
            Byte b1 = memory.getByte(addr+1);
            Byte b2 = memory.getByte(addr+2);
            Byte b3 = memory.getByte(addr+3);
            addr = memory.toIntFromFourBytes(b0,b1,b2,b3);
            String deviceHandler = Integer.toHexString(Runner.FILEPRINTER);  //File reader address
            while (deviceHandler.length() < 8)
            {
                deviceHandler = "0" + deviceHandler;
            }
            // change dcb to point at device handler
            addr = addr + DEVICEDISP;
            for(int i=0; i < 4; i++)
		    {
		       String hxst2 = deviceHandler.substring(2 * i, 2 * i + 2);
               int ival = Hex.toIntFromHexString2(hxst2);
               memory.setByte(addr,new Byte((byte) ival));
               addr = addr + 1;
            } 
            String fileName = dcb.getDDName();
            String fileno = fileName.substring(7,8);
            String physicalFname = dcb.getPhysicalName();
            try {              
                   if (fileno.equals("1")) fileout1 = new PrintWriter(physicalFname);
                   if (fileno.equals("2")) fileout2 = new PrintWriter(physicalFname);
                   if (fileno.equals("3")) fileout3 = new PrintWriter(physicalFname);
            }
            catch(Exception e) 
            {
                System.out.println(e);
                System.out.println("File " + fileName + " could not be opened.");
            }
        }
    }
    public static void setFilein1(Scanner s)
    {
        filein1 = s;
    }
    public void close(int val)
    {
        DCB dcb = opendcbs.getDCB(val);
        if (dcb == null)
        {
            System.out.println("File is not open");
            return; // temp fix for trying to close a file that isn't open
        }
        String fileName = dcb.getDDName();

        if (dcb.getMode().equals("Input"))
        {       
           String fileno = fileName.substring(6,7); 
           try {              
                if (fileno.equals("1")) filein1.close();
                if (fileno.equals("2")) filein2.close();
                if (fileno.equals("3")) filein3.close();
           }
           catch(Exception e) 
           {
              System.out.println(e);
              System.out.println("File " + fileName + " could not be closed.");
           } 
        }        
       
        if (dcb.getMode().equals("Output"))
        {        
           String fileno = fileName.substring(7,8); 
           try {              
                if (fileno.equals("1")) fileout1.close();
                if (fileno.equals("2")) fileout2.close();
                if (fileno.equals("3")) fileout3.close();
           }
           catch(Exception e) 
           {
              System.out.println(e);
              System.out.println("File " + fileName + " could not be closed.");
           } 
        }
        opendcbs.removeDCB(dcb);
    }
    public  void get(int val)
    {
        DCB dcb = opendcbs.getDCB(val);
        if (dcb == null)
        {
            System.out.println("File is not open");
            return;
        }
        String fileName = dcb.getDDName();
        String fileno = fileName.substring(6,7);
        Register R0 = registers.getRegister(0);
        int bufferAddr = R0.getRegValue(); 
        if (dcb.getMode().equals("Input"))
        {
            try {              
                   if (fileno.equals("1")) 
                   {
                       boolean bb = filein1.hasNextLine();
                       if (filein1.hasNextLine())
                       {
                          String recordA = filein1.nextLine().toUpperCase();   //input in ASCII
                          byte[] recordE = recordA.getBytes("Cp1047");  //change to EBCDIC
                          for(int i=0;i < recordE.length;i++,bufferAddr++)
                          {
                              memory.setByte(bufferAddr, recordE[i]);
                          }
                       }
                       else   // EODAD occurred
                       {
                           psw.setInstructionAddress(dcb.getEODAD());
                       }
                   }
                   if (fileno.equals("2"))
                   {  
                       String record = filein2.nextLine();
                   }
                   if (fileno.equals("3"))
                   {
                       String record = filein3.nextLine();
                   }
                   
            }
            catch(Exception e) 
            {
                System.out.println(e);
                System.out.println("File " + fileName + " could not be opened.");
            }
        }

    }
    public void put(int val)
    {
        DCB dcb = opendcbs.getDCB(val);
        if (dcb == null)
        {
            System.out.println("File is not open");
            return;
        }
        String fileName = dcb.getDDName();

        if (dcb.getMode().equals("Output"))
        {
            String fileno = fileName.substring(7,8);
            try {              
                   Register R0 = registers.getRegister(0);  // R0 points at the output buffer
                   int bufferAddr = R0.getRegValue(); 
                   int lrecl = dcb.getLRECL();
                   byte[] outputRec = new byte[lrecl];
                   for(int i=0;i < lrecl;i++,bufferAddr++)
                   {
                       outputRec[i] = memory.getByte(bufferAddr);
                   }
                   String asciiRec = new String(outputRec,"Cp1047");
                   if (fileno.equals("1"))
                   {
                      fileout1.println(asciiRec);
                   }
                   if (fileno.equals("2"))
                   {
                      fileout2.println(asciiRec);
                   }
                   if (fileno.equals("3")) 
                   {
                      fileout3.println(asciiRec);
                   }
            }
            catch(Exception e) 
            {
                System.out.println(e);
                System.out.println("File " + fileName + " could not be opened.");
            }
        }
    }
    public void reset()   //reset the Channel by clearing the open dcbs
    {
        opendcbs = new OpenDCBs();
    }
}
