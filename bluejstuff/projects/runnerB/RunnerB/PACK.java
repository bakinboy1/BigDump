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
 * Pack - PACK.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */

public class PACK extends SS2Instruction
{
	/**
	 * Constructor for objects of class PACK
	 */
	public PACK(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " PACK - PACK - SS2\n Object Code:  OPCODE|L1L2|B1D1|D1D1|B2D2|D2D2\n Explicit Format: D1(L1,B1),D2(L2,B2)";
		setDescription(d);				
	}

	/**
	 * execute - emulates execution of a PACK instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getBaseReg1();
		Register b2 = getBaseReg2();
		Memory memory = getMemory();
		int disp1 = getDisplacement1();
		int disp2 = getDisplacement2();
		int target = b1.getRegValue() + disp1;
		int source = b2.getRegValue() + disp2;
		int len1 = getLength1() + 1;
		int len2 = getLength2() + 1;
		int ptrT = target + len1 - 1;   //point to last byte of target
		int ptrS = source + len2 - 1;   //point to last byte of source
		Byte aByte = memory.getByte(ptrS);
		Byte bByte = null;
		int lInt = Hex.leftDigitAsInt(aByte);
		int rInt = Hex.rightDigitAsInt(aByte);
		//swap the hex digits
		Byte newByte = new Byte((byte)((rInt * 16) + lInt));
		memory.setByte(ptrT,newByte);
		ptrT = ptrT - 1;
		ptrS = ptrS - 2;
		while((ptrT >= target) && (ptrS >= source))
		{
		    aByte = memory.getByte(ptrS);
		    lInt = Hex.rightDigitAsInt(aByte);
		    bByte = memory.getByte(ptrS+1);
		    rInt = Hex.rightDigitAsInt(bByte);
			newByte = new Byte((byte)((lInt * 16) + rInt));	  
			memory.setByte(ptrT,newByte);
		    ptrS = ptrS - 2;
		    ptrT = ptrT - 1;			
        }
        if ((ptrS + 1 == source) && (ptrT >= target))            //one last byte to convert
        {
 		    bByte = memory.getByte(ptrS+1);
		    rInt = Hex.rightDigitAsInt(bByte);
			newByte = new Byte((byte) rInt);	  
			memory.setByte(ptrT,newByte); 
		    ptrS = ptrS - 2;
		    ptrT = ptrT - 1;		
		}
		while(ptrT >= target)             //fill with zeroes
		{
		    newByte = new Byte((byte)0);	  
			memory.setByte(ptrT,newByte); 
		    ptrT = ptrT - 1;	
		}
		    
	}
}
