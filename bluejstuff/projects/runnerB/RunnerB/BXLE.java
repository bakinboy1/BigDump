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

public class BXLE extends RSInstruction
{
	/**
	 * Constructor for objects of class BXLE
	 */
	public BXLE(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " Branch on Index Less or Equal - RS\n Object Code:  OPCODE|R1R3|B2D2|D2D2\n Explicit Format: R1,R3,D2(B2)";
		setDescription(d);	
		setTargetHighlighting(getEffectiveAddress()); // no highlighting in memory
		Register baseReg1 = getBaseReg1();
		Register baseReg2 = getBaseReg2();
		Register baseReg3 = getBaseReg3();
		int displacement = getDisplacement();
		setSourceHighlighting(-1);
		setSourceRegHighlighting(-1);
		setTargetRegHighlighting(baseReg1.getRegNumber());
		setIndexRegHighlighting(baseReg3.getRegNumber());	
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());		
	}

	/**
	 * execute - emulates execution of a BXLE instruction
	 * 
	 */
	public void execute()
	{
	    Register r1 = getBaseReg1();
		Register incrReg = getBaseReg3();
		int incrRegNo = incrReg.getRegNumber();
		Register limitReg = incrReg;
		Registers regs = getRegisters();
		if ( incrRegNo % 2 == 0)
		{
		    limitReg = regs.getRegister(incrRegNo + 1);
		}
		
		PSW psw = getPSW();

		int sum = r1.getRegValue();
		int incr = incrReg.getRegValue();
		int limit = limitReg.getRegValue();
		int targetAddr = getEffectiveAddress();
		sum = sum + incr;
		r1.setRegValue(sum);
		if (sum <= limit)
	    {
	         psw.setInstructionAddress(targetAddr);
        }                
	}
}