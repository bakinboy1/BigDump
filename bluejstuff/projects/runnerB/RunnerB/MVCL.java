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

public class MVCL extends RRInstruction
{
	/**
	 * Constructor for objects of class MVCL
	 */
	public MVCL(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " MVCL - Move Characters Long - RR\n Object Code:  OPCODE|R1R2\n Explicit Format:  R1,R2";
		setDescription(d);	
		setSourceHighlighting(getReg2().getRegValue());   //no highlighting memory
		setTargetHighlighting(getReg1().getRegValue());   //no highlighting memory
        int r2 = getReg2().getRegNumber();
		setSourceRegHighlighting(r2);
		setTargetRegHighlighting(getReg1().getRegNumber());			
	}

	/**
	 * execute - emulates execution of an MCVL instruction
	 * 
	 */
	public void execute()
	{
	    Registers regs = getRegisters();
		Register b1 = getReg1();
		int target = b1.getRegValue();
		int b1No = b1.getRegNumber();
		int b1XNo = b1No + 1;
		Register b1x = regs.getRegister(b1XNo);
		int lengthTarget = b1x.getRegValue();	
		Register b2 = getReg2();
		int source = b2.getRegValue();
		int b2No = b2.getRegNumber();
		int b2XNo = b2No + 1;
		Register b2x = regs.getRegister(b2XNo);
		String pad = b2x.getByteAsString(0);
		int padVal = Integer.parseInt(pad,16);
		Byte padByte = new Byte((byte) padVal);
		Byte byte1 = new Byte("0");
		String digits = b2x.getByteAsString(1);
		int val = Integer.parseInt(digits,16);
		Byte byte2 = new Byte((byte) val);
		digits = b2x.getByteAsString(2);
		val = Integer.parseInt(digits,16);
		Byte byte3 = new Byte((byte) val);
		digits = b2x.getByteAsString(3);
		val = Integer.parseInt(digits,16);
		Byte byte4 = new Byte((byte) val);
		int lengthSource = Memory.toIntFromFourBytes(byte1,byte2,byte3,byte4);
        Memory memory = getMemory();
		while ((lengthTarget > 0) && (lengthSource > 0))
		{
		    Byte b = memory.getByte(source++);
		    memory.setByte(target++,b);
		    lengthTarget--;
		    lengthSource--;
		    b1.setRegValue(target);
		    b1x.setRegValue(lengthTarget);
		    b2.setRegValue(source);
		    b2x.setRegValue(lengthSource);		    
		}
		if (lengthSource == 0)
		{
		    while (lengthTarget > 0)
		    {
		       memory.setByte(target++,padByte);
		       lengthTarget--;
		    }
		}
	}
}
