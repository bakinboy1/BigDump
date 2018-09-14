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

/**
 * This class simulates the actions of an IBM System/360 CPU.
 * 
 * @author Woolbright
 * @version October, 2007
 */
import java.io.*;
public class CPU
{
	// instance variables - replace the example below with your own
	private PSW psw;
	private Registers registers;
	private FRegisters fregisters;
	private Memory memory;
	private Channel channel;
	private JCL jcl;
	private int memorySize;
	private Instruction nextInstruction;
	private Instruction lookAheadInstruction;
	private String instructionType;
	//OS Service Calls
    public static final int OPEN = 19;
    public static final int CLOSE = 20;
    public static final int PUT = 21;
    public static final int GET = 22; 
	/**
	 * Constructor for objects of class CPU
	 */
	public CPU(int memorySize)
	{
		this.memorySize = memorySize;
		memory = new Memory(memorySize);
        this.psw = new PSW(0);
		registers = new Registers(psw);
		fregisters = new FRegisters(psw);
		channel = new Channel(memory,registers,fregisters,psw);
        try
        {
           FileInputStream fileIn = new FileInputStream("jclstate.ser");
           ObjectInputStream in = new ObjectInputStream(fileIn);
           jcl = (JCL) in.readObject();
           in.close();
           fileIn.close();
        }catch(IOException i)
        {
		  jcl = new JCL();
	    }catch(ClassNotFoundException c)
      {
         System.out.println("JCL class not found");
         c.printStackTrace();
         return;
      }
	}
	public void load(String fname)
	{
	    memory.load(fname);
	    memory.loadDeviceDrivers();
		int next = psw.fetchInstructionAddress();
		Register R13 = registers.getRegister(13);
		Register R14 = registers.getRegister(14);
	    Register R15 = registers.getRegister(15);	
		//registers.randomize();                       //initialize registers with random values
		R13.setRegValue(Runner.SAVEAREAADDRESS);  //R13 should point at the OS save area (See linkage conventions for R13)
		R15.setRegValue(Runner.PROGRAMSTART);
        lookAheadInstruction = new Instruction(next, memory,psw,registers);   //set highlighting
        String opcode = lookAheadInstruction.getOpcode();
        lookAheadInstruction = buildInstruction(opcode, next);
        buildHighlights(lookAheadInstruction);         
	}
	public void reset()
	{
	    channel.reset();
		int next = psw.fetchInstructionAddress();
		Register R13 = registers.getRegister(13);
		R13.setRegValue(Runner.SAVEAREAADDRESS);  //R13 should point at the OS save area
		Register R14 = registers.getRegister(14);
		R14.setRegValue(Runner.OSRETURNADDRESS);
        lookAheadInstruction = new Instruction(next, memory,psw,registers);   //set highlighting
        String opcode = lookAheadInstruction.getOpcode();
        lookAheadInstruction = buildInstruction(opcode, next);
        buildHighlights(lookAheadInstruction);

	}	
	public void cycle()
	{
	   int next = psw.fetchInstructionAddress();
       nextInstruction = new Instruction(next,memory,psw,registers);   //build a generic 6 byte instruction
       String opcode = nextInstruction.getOpcode();           //grab the opcode of the instruction
       nextInstruction = buildInstruction(opcode, next);      //build a specific instruction based on the opcode
       int len = nextInstruction.getInstructionLength();      //grab the instruction length
       psw.updatePSWAddress(len);                             //add the length of the instruction to the PSW address
       if (opcode.equals("44"))                               //is the next instruction execute?
       {

		   RXInstruction rx = (RXInstruction) nextInstruction;
           Register b1 = rx.getReg1();
		   int b1Val = b1.getRegValue();	
		   int s = rx.getEffectiveAddress();
           Byte b = Byte.decode(memory.getByte(s).toString()); 
           opcode = Hex.toHex(b);
		   Byte val = memory.getByte(s+1);  // save second byte
           Byte result = new Byte((byte)( val ^ b1Val));		
	       memory.setByte(s+1,result);
   		   nextInstruction = buildInstruction(opcode, s);
   		   memory.setByte(s+1,val);  //reset second byte
		   
       }
       nextInstruction.execute();                             //execute the current instruction
       //Set highlighting for the next instruction
       next = psw.fetchInstructionAddress();                 //now look ahead
       lookAheadInstruction = new Instruction(next, memory,psw,registers);   //build the next generic instruction
       opcode = lookAheadInstruction.getOpcode();                                   //grab the opcode
       lookAheadInstruction = buildInstruction(opcode, next);                  //build the next specific instruction
       buildHighlights(lookAheadInstruction);

	}
    public void svc(int serviceNo)
    {

        switch (serviceNo){  
            case(OPEN):  
                         int next = psw.fetchInstructionAddress();
                         int dcbAddress = next - 5;
                         Byte b1 = new Byte((byte)0);
                         Byte b2 = memory.getByte(dcbAddress);
                         Byte b3 = memory.getByte(dcbAddress+1);
                         Byte b4 = memory.getByte(dcbAddress+2);
                         int val = memory.toIntFromFourBytes(b1,b2,b3,b4);  //val is the adress of the file's DCB
                         int ddNameAddress = val + 40;  //DDname is 40 bytes into the DCB
                         String ddName = "";
                         
                         for(int i=0;i<8;i++)
                         {
                            Byte b = memory.getByte(ddNameAddress);
                            ddName = ddName + Converter.EBCDICtoASCII(b);
                            ddNameAddress = ddNameAddress + 1;
                         }    
                         int eodadAddress = val + 32; // EODAD is 32 bytes into the DCB
                         b1 = new Byte((byte)0);
                         b2 = memory.getByte(eodadAddress+1);
                         b3 = memory.getByte(eodadAddress+2);
                         b4 = memory.getByte(eodadAddress+3);
                         int eodadValue = memory.toIntFromFourBytes(b1,b2,b3,b4);    
                         int lreclAddress = val + 82; // LRECL is 82 bytes into the DCB
                         b1 = new Byte((byte)0);
                         b2 = new Byte((byte)0);
                         b3 = memory.getByte(lreclAddress);  //LRECL is halfword field
                         b4 = memory.getByte(lreclAddress+1);
                         int lrecl = memory.toIntFromFourBytes(b1,b2,b3,b4);                           
                         String mode = "";
                         String smallName = ddName.substring(0,5).toLowerCase();
                         if (smallName.equals("filei"))
                         {
                            mode = "Input";

                         }
                         else if (smallName.equals("fileo"))
                         {
                            mode = "Output";
                         }
                         String pname = jcl.getPhysicalName(ddName);
                         DCB dcb = new DCB(ddName,pname,mode,val,eodadValue,lrecl);   //create the dcb ...
                         //OpenDCBs.add(val,dcb);  //add to the open dcb list
                         channel.open(dcb);  //try to open it
                         break;
            case(CLOSE): 
                         next = psw.fetchInstructionAddress();
                         dcbAddress = next - 5;
                         b1 = new Byte((byte)0);
                         b2 = memory.getByte(dcbAddress);
                         b3 = memory.getByte(dcbAddress+1);
                         b4 = memory.getByte(dcbAddress+2);
                         val = memory.toIntFromFourBytes(b1,b2,b3,b4);  //val is the adress of the file's DCB
                         ddNameAddress = val + 40;  //DDname is 40 bytes into the DCB
                         ddName = "";
                         for(int i=0;i<8;i++)
                         {
                            Byte b = memory.getByte(ddNameAddress);
                            ddName = ddName + Converter.EBCDICtoASCII(b);
                            ddNameAddress = ddNameAddress + 1;
                         }  
                    
                         channel.close(val);  //pass the dcb address
                         break;
            case(PUT):   
                         Register R1 = registers.getRegister(1);
                         val = R1.getRegValue();

                         channel.put(val);
                         break;
            case(GET):   
                         R1 = registers.getRegister(1);
                         val = R1.getRegValue();
                         channel.get(val);
                         break;
            default:     System.out.println("Unsupported SVC issued.");
        }
    }
	    
	public void buildHighlights(Instruction lookAheadInstruction)
	{
	   int next = psw.fetchInstructionAddress();
	   int len = lookAheadInstruction.getInstructionLength();      //grab the instruction length
       int iS = next;                                                          //where the instruction starts
       int iE = next + len - 1;                                                //where the instruction ends
       int s = lookAheadInstruction.getSourceHighlighting();
       int t = lookAheadInstruction.getTargetHighlighting();
       int R1 = lookAheadInstruction.getSourceRegHighlighting();
       int R2 = lookAheadInstruction.getTargetRegHighlighting();
       int X2 = lookAheadInstruction.getIndexRegHighlighting();
       int B1 = lookAheadInstruction.getBaseReg1Highlighting();
       int B2 = lookAheadInstruction.getBaseReg2Highlighting();
	   memory.setHighlighting(iS,iE,s,t,R1,R2,X2,B1,B2); //set highlighting for memory panel    
	}
	public Instruction buildInstruction(String opcode, int next)
	{
	    if (opcode.equals("5e")) return new AL(next, memory, psw,registers);
	    if (opcode.equals("1a")) return new AR(next, memory, psw,registers);
	    if (opcode.equals("1b")) return new SR(next, memory, psw,registers);
	    if (opcode.equals("14")) return new NR(next, memory, psw,registers);	
	    if (opcode.equals("1e")) return new ALR(next, memory, psw,registers);	
	    if (opcode.equals("05")) return new BALR(next, memory, psw,registers);	  
	    if (opcode.equals("0d")) return new BASR(next, memory, psw,registers);
	    if (opcode.equals("07")) return new BCR(next, memory, psw,registers);	
	    if (opcode.equals("06")) return new BCTR(next, memory, psw,registers);	 
	    if (opcode.equals("19")) return new CR(next, memory, psw,registers);	
	    if (opcode.equals("15")) return new CLR(next, memory, psw,registers);	
	    if (opcode.equals("0f")) return new CLCL(next, memory, psw,registers);	
	    if (opcode.equals("1d")) return new DR(next, memory, psw,registers);
	    if (opcode.equals("17")) return new XR(next, memory, psw,registers);
	    if (opcode.equals("18")) return new LR(next, memory, psw,registers);
	    if (opcode.equals("1f")) return new SLR(next, memory, psw,registers);	
	    if (opcode.equals("0a")) return new SVC(next, memory, psw,registers);	    
	    if (opcode.equals("12")) return new LTR(next, memory, psw,registers);	
	    if (opcode.equals("13")) return new LCR(next, memory, psw,registers);	
	    if (opcode.equals("11")) return new LNR(next, memory, psw,registers);	
	    if (opcode.equals("10")) return new LPR(next, memory, psw,registers);
	    if (opcode.equals("0e")) return new MVCL(next, memory, psw,registers);
	    if (opcode.equals("1c")) return new MR(next, memory, psw,registers);	    
	    if (opcode.equals("04")) return new SPM(next, memory, psw,registers);
	    if (opcode.equals("16")) return new OR(next, memory, psw,registers);	  
	    if (opcode.equals("d2")) return new MVC(next, memory, psw,registers);
	    if (opcode.equals("d4")) return new NC(next, memory, psw,registers);
	    if (opcode.equals("d5")) return new CLC(next, memory, psw,registers);	    
	    if (opcode.equals("de")) return new ED(next, memory, psw,registers);
	    if (opcode.equals("df")) return new EDMK(next, memory, psw,registers);
	    if (opcode.equals("d7")) return new XC(next, memory, psw,registers);
	    if (opcode.equals("e8")) return new MVCIN(next, memory, psw,registers);
	    if (opcode.equals("d1")) return new MVN(next, memory, psw,registers);	    
	    if (opcode.equals("f1")) return new MVO(next, memory, psw,registers);
	    if (opcode.equals("d3")) return new MVZ(next, memory, psw,registers);
	    if (opcode.equals("d6")) return new OC(next, memory, psw,registers);
	    if (opcode.equals("f0")) return new SRP(next, memory, psw,registers);
	    if (opcode.equals("dc")) return new TR(next, memory, psw,registers);	    
	    if (opcode.equals("dd")) return new TRT(next, memory, psw,registers);        
	    if (opcode.equals("94")) return new NI(next, memory, psw,registers);
	    if (opcode.equals("95")) return new CLI(next, memory, psw,registers);
	    if (opcode.equals("97")) return new XI(next, memory, psw,registers);
	    if (opcode.equals("96")) return new OI(next, memory, psw,registers);	    
	    if (opcode.equals("91")) return new TM(next, memory, psw,registers);	    
	    if (opcode.equals("fa")) return new AP(next, memory, psw,registers);
	    if (opcode.equals("f9")) return new CP(next, memory, psw,registers);
	    if (opcode.equals("fd")) return new DP(next, memory, psw,registers);
	    if (opcode.equals("f1")) return new MVO(next, memory, psw,registers);
	    if (opcode.equals("fc")) return new MP(next, memory, psw,registers);	    
	    if (opcode.equals("f2")) return new PACK(next, memory, psw,registers);		    
	    if (opcode.equals("f0")) return new SRP(next, memory, psw,registers);	
	    if (opcode.equals("fb")) return new SP(next, memory, psw,registers);		    
	    if (opcode.equals("f3")) return new UNPK(next, memory, psw,registers);	
	    if (opcode.equals("f8")) return new ZAP(next, memory, psw,registers);		    
	    if (opcode.equals("58")) return new L(next, memory, psw,registers);
        if (opcode.equals("92")) return new MVI(next,memory, psw,registers);
        if (opcode.equals("98")) return new LM(next,memory, psw,registers);
        if (opcode.equals("fa")) return new AP(next,memory, psw,registers);      
	    if (opcode.equals("5a")) return new A(next, memory, psw,registers);
	    if (opcode.equals("4a")) return new AH(next, memory, psw,registers);   
	    if (opcode.equals("54")) return new N(next, memory, psw,registers);
	    if (opcode.equals("45")) return new BAL(next, memory, psw,registers);
	    if (opcode.equals("4d")) return new BAS(next, memory, psw,registers);
	    if (opcode.equals("47")) return new BC(next, memory, psw,registers);
	    if (opcode.equals("46")) return new BCT(next, memory, psw,registers);	    
	    if (opcode.equals("59")) return new C(next, memory, psw,registers);
	    if (opcode.equals("49")) return new CH(next, memory, psw,registers);
	    if (opcode.equals("55")) return new CL(next, memory, psw,registers);
	    if (opcode.equals("4f")) return new CVB(next, memory, psw,registers);
	    if (opcode.equals("4e")) return new CVD(next, memory, psw,registers);	    
	    if (opcode.equals("5d")) return new D(next, memory, psw,registers);     
	    if (opcode.equals("57")) return new X(next, memory, psw,registers);
	    if (opcode.equals("44")) return new EX(next, memory, psw,registers);
	    if (opcode.equals("43")) return new IC(next, memory, psw,registers);	    
	    if (opcode.equals("41")) return new LA(next, memory, psw,registers);
	    if (opcode.equals("48")) return new LH(next, memory, psw,registers);
	    if (opcode.equals("5c")) return new M(next, memory, psw,registers);
	    if (opcode.equals("4c")) return new MH(next, memory, psw,registers);
	    if (opcode.equals("56")) return new O(next, memory, psw,registers);	    
	    if (opcode.equals("50")) return new ST(next, memory, psw,registers);
	    if (opcode.equals("42")) return new STC(next, memory, psw,registers);
	    if (opcode.equals("40")) return new STH(next, memory, psw,registers);
	    if (opcode.equals("5b")) return new S(next, memory, psw,registers);
	    if (opcode.equals("4b")) return new SH(next, memory, psw,registers);	    
	    if (opcode.equals("5f")) return new SL(next, memory, psw,registers);	
	    if (opcode.equals("71")) return new MS(next, memory, psw,registers);	    
	    if (opcode.equals("90")) return new STM(next, memory, psw,registers);	
	    if (opcode.equals("bf")) return new ICM(next, memory, psw,registers);	
	    if (opcode.equals("bd")) return new CLM(next, memory, psw,registers);	
	    if (opcode.equals("8c")) return new SRDL(next, memory, psw,registers);		    
	    if (opcode.equals("8e")) return new SRDA(next, memory, psw,registers);		    
		if (opcode.equals("8d")) return new SLDL(next, memory, psw,registers);		    
	    if (opcode.equals("8f")) return new SLDA(next, memory, psw,registers);		
	    if (opcode.equals("87")) return new BXLE(next, memory, psw,registers);	
	    if (opcode.equals("86")) return new BXH(next, memory, psw,registers);	
	    if (opcode.equals("c00")) return new LARL(next, memory, psw,registers);		    
        if (opcode.equals("5e")) return new AL(next, memory, psw, registers);	
        if (opcode.equals("a74")) return new BRC(next, memory, psw, registers);
        if (opcode.equals("a75")) return new BRAS(next, memory, psw, registers);    
        if (opcode.equals("c4d")) return new LRL(next, memory, psw, registers);      
        if (opcode.equals("c4b")) return new STGRL(next, memory, psw, registers);          
        if (opcode.equals("e304")) return new LG(next, memory, psw, registers);   
        if (opcode.equals("c48")) return new LGRL(next, memory, psw, registers); 
        if (opcode.equals("c4f")) return new STRL(next, memory, psw, registers);         
        if (opcode.equals("e308")) return new AG(next, memory, psw, registers); 
        if (opcode.equals("e309")) return new SG(next, memory, psw, registers);   
        if (opcode.equals("e30c")) return new MSG(next, memory, psw, registers);   
        if (opcode.equals("e316")) return new LLGF(next, memory, psw, registers);        
        if (opcode.equals("e318")) return new AGF(next, memory, psw, registers);
        if (opcode.equals("e319")) return new SGF(next, memory, psw, registers); 
        if (opcode.equals("e31c")) return new MSGF(next, memory, psw, registers);     
        if (opcode.equals("e351")) return new MSY(next, memory, psw, registers);
        if (opcode.equals("e371")) return new LAY(next, memory, psw, registers);
        if (opcode.equals("e372")) return new STCY(next, memory, psw, registers);        
        if (opcode.equals("e373")) return new ICY(next, memory, psw, registers);        
        if (opcode.equals("e379")) return new CHY(next, memory, psw, registers);        
        if (opcode.equals("e37a")) return new AHY(next, memory, psw, registers); 
        if (opcode.equals("eb1d")) return new RLL(next, memory, psw, registers);
        if (opcode.equals("eb1c")) return new RLLG(next, memory, psw, registers);
        if (opcode.equals("ebc0")) return new TP(next, memory, psw, registers);        
        if (opcode.equals("ebdc")) return new SRAK(next, memory, psw, registers);
        if (opcode.equals("eb04")) return new LMG(next, memory, psw, registers);
        if (opcode.equals("eb0a")) return new SRAG(next, memory, psw, registers);
        if (opcode.equals("ebc7")) return new STFH(next, memory, psw, registers);
        if (opcode.equals("eb90")) return new STMY(next, memory, psw, registers);
        if (opcode.equals("eb24")) return new STMG(next, memory, psw, registers);
        if (opcode.equals("eb98")) return new LMY(next, memory, psw, registers);
        if (opcode.equals("eb51")) return new TMY(next, memory, psw, registers);        
        if (opcode.equals("eb52")) return new MVIY(next, memory, psw, registers);
        if (opcode.equals("eb55")) return new CLIY(next, memory, psw, registers);        
        if (opcode.equals("eb96")) return new LMH(next, memory, psw, registers);
        if (opcode.equals("eb26")) return new STMH(next, memory, psw, registers);    
        if (opcode.equals("ec76")) return new CRJ(next, memory, psw, registers);         
        if (opcode.equals("ebf3")) return new STOC(next, memory, psw, registers); 
        if (opcode.equals("ec64")) return new CGRJ(next, memory, psw, registers);            
        if (opcode.equals("ece4")) return new CGRB(next, memory, psw, registers);          
        if (opcode.equals("ecf6")) return new CRB(next, memory, psw, registers);         
        if (opcode.equals("c04")) return new BRCL(next, memory, psw, registers);    
        if (opcode.equals("c05")) return new BRASL(next, memory, psw, registers);
        if (opcode.equals("a76")) return new BRCT(next, memory, psw, registers);
        if (opcode.equals("a77")) return new BRCTG(next, memory, psw, registers);
        if (opcode.equals("cc"))  return new BRCTH(next, memory, psw, registers);
        if (opcode.equals("e346")) return new BCTG(next, memory, psw, registers);
        if (opcode.equals("b252")) return new MSR(next, memory, psw, registers);    
        if (opcode.equals("b900")) return new LPGR(next, memory, psw, registers);              
        if (opcode.equals("b901")) return new LNGR(next, memory, psw, registers);         
        if (opcode.equals("b903")) return new LCGR(next, memory, psw, registers);        
        if (opcode.equals("b904")) return new LGR(next, memory, psw, registers); 
        if (opcode.equals("b908")) return new AGR(next, memory, psw, registers);        
        if (opcode.equals("b909")) return new SGR(next, memory, psw, registers);
        if (opcode.equals("b911")) return new LNGFR(next, memory, psw, registers);    
        if (opcode.equals("b90c")) return new MSGR(next, memory, psw, registers);    
        if (opcode.equals("b90d")) return new DSGR(next, memory, psw, registers); 
        if (opcode.equals("b916")) return new LLGFR(next, memory, psw, registers);         
        if (opcode.equals("b902")) return new LTGR(next, memory, psw, registers);  
        if (opcode.equals("b912")) return new LTGFR(next, memory, psw, registers);
        if (opcode.equals("b913")) return new LCGFR(next, memory, psw, registers);        
        if (opcode.equals("b914")) return new LGFR(next, memory, psw, registers);          
        if (opcode.equals("b918")) return new AGFR(next, memory, psw, registers);             
        if (opcode.equals("b919")) return new SGFR(next, memory, psw, registers);        
        if (opcode.equals("b91c")) return new MSGFR(next, memory, psw, registers);               
        if (opcode.equals("b91d")) return new DSGFR(next, memory, psw, registers);   
        if (opcode.equals("e314")) return new LGF(next, memory, psw, registers);          
        if (opcode.equals("e324")) return new STG(next, memory, psw, registers);  
        if (opcode.equals("e358")) return new LY(next, memory, psw, registers);          
        if (opcode.equals("e35a")) return new AY(next, memory, psw, registers);     
        if (opcode.equals("e376")) return new LB(next, memory, psw, registers);  
        if (opcode.equals("e377")) return new LGB(next, memory, psw, registers);          
        if (opcode.equals("e37b")) return new SHY(next, memory, psw, registers);          
        if (opcode.equals("e38f")) return new LPQ(next, memory, psw, registers);        
        if (opcode.equals("e38e")) return new STPQ(next, memory, psw, registers);        
        if (opcode.equals("b91f")) return new LRVR(next, memory, psw, registers);        
        if (opcode.equals("b90f")) return new LRVGR(next, memory, psw, registers); 
        if (opcode.equals("e30d")) return new DSG(next, memory, psw, registers);   
        if (opcode.equals("e31d")) return new DSGF(next, memory, psw, registers);         
        if (opcode.equals("e3ca")) return new LFH(next, memory, psw, registers);   
        if (opcode.equals("e33f")) return new STRVH(next, memory, psw, registers);        
        if (opcode.equals("e33e")) return new STRV(next, memory, psw, registers);        
        if (opcode.equals("e32f")) return new STRVG(next, memory, psw, registers);        
        if (opcode.equals("e35b")) return new SY(next, memory, psw, registers); 
        if (opcode.equals("e390")) return new LLGC(next, memory, psw, registers);  
        if (opcode.equals("e391")) return new LLGH(next, memory, psw, registers);          
        if (opcode.equals("b920")) return new CGR(next, memory, psw, registers);        
        if (opcode.equals("b930")) return new CGFR(next, memory, psw, registers);        
        if (opcode.equals("b921")) return new CLGR(next, memory, psw, registers);        
        if (opcode.equals("b931")) return new CLGFR(next, memory, psw, registers);              
        if (opcode.equals("e359")) return new CY(next, memory, psw,registers);    
        if (opcode.equals("e320")) return new CG(next, memory, psw,registers);    
        if (opcode.equals("e330")) return new CGF(next, memory, psw,registers);  
        if (opcode.equals("e378")) return new LHY(next, memory, psw,registers);  
        if (opcode.equals("b917")) return new LLGTR(next, memory, psw,registers);    
        if (opcode.equals("e317")) return new LLGT(next, memory, psw,registers);    
        if (opcode.equals("a72")) return new TMHH(next, memory, psw,registers);    
        if (opcode.equals("a73")) return new TMHL(next, memory, psw,registers);    
        if (opcode.equals("a70")) return new TMLH(next, memory, psw,registers);    
        if (opcode.equals("a71")) return new TMLL(next, memory, psw,registers);    
        if (opcode.equals("a7a")) return new AHI(next, memory, psw, registers);   
        if (opcode.equals("c29")) return new AFI(next, memory, psw, registers);    
        if (opcode.equals("c28")) return new AGFI(next, memory, psw, registers);    
        if (opcode.equals("c01")) return new LGFI(next, memory, psw, registers);     
        if (opcode.equals("a78")) return new LHI(next, memory, psw, registers);
        if (opcode.equals("a7b")) return new AGHI(next, memory, psw, registers);
        if (opcode.equals("a7e")) return new CHI(next, memory, psw, registers);
        if (opcode.equals("a7f")) return new CGHI(next, memory, psw, registers);

        
	    return new UNKN(next,memory,psw,registers);   // unknown instruction
	}
	public Memory getMemory()
	{
	    return memory;
	}
	public Registers getRegisters()
	{
	    return registers;
	}
	public FRegisters getFRegisters()
	{
	    return fregisters;
	}
	public PSW getPSW()
	{
	    return psw;
	}
	public JCL getJCL()
	{
	    return jcl;
	}
	public Instruction getNextInstruction()
	{
	    return nextInstruction;
	}
	public Instruction getLookAheadInstruction()
	{
	    return lookAheadInstruction;
	}
}
