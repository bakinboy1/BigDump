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

public class DSGFR extends RREInstruction
{
	/**
	 * Constructor for objects of class DSGFR
	 */
	public DSGFR(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " DSGFR - Divide Single Grande Fullword Register - RRE\n Object Code:  OPCODE|OPCODE|//|R1R2\n Explicit Format:  R1,R2";
		setDescription(d);	
		setSourceHighlighting(-1);   //no highlighting memory
		setTargetHighlighting(-1);   //no highlighting memory
		setSourceRegHighlighting(getReg2().getRegNumber());
		setTargetRegHighlighting(getReg1().getRegNumber());		
	}

	/**
	 * execute - emulates execution of an DSGFR instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getReg1();
		int regNo = b1.getRegNumber();
		//long val1 = b1.getLongRegValue();
		regNo = regNo + 1;  //multiplicand in the odd register
		PSW psw = getPSW();
		Registers regs = getRegisters();
		Register oddReg = regs.getRegister(regNo);
		long dividend = oddReg.getLongRegValue();		
	
		Register b2 = getReg2();
		long divisor = b2.getRegValue();		
		if (divisor == 0)
		{
		    throw new FixedPointDivideException("Divisor is zero");
		}
		else
		{
		   long quotient = (long) (dividend / divisor);
		   long remainder = (long) (dividend % divisor);
           b1.setLongRegValue(remainder);
		   oddReg.setLongRegValue(quotient);
		
		}
	}
}
