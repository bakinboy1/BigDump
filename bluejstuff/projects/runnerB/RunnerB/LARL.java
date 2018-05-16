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

public class LARL extends RILaInstruction
{
	/**
	 * Constructor for objects of class LARL
	 */
	public LARL(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " LARL - Load Address Relative Long - RIL\n Object Code:  OPCODE|R1'0'|RI2RI2|RI2RI2|RI2RI2|RI2RI2\n Explicit Format: R1,I2";
		setDescription(d);	
		setTargetHighlighting(psw.fetchInstructionAddress() + (2 * getI2())); 
 		setSourceHighlighting(-1);
    	setSourceRegHighlighting(getR1No());	
		
	}

	/**
	 * execute - emulates execution of a LARL instruction
	 * 
	 */
	public void execute()
	{
	   PSW psw = getPSW();
       int address = psw.fetchInstructionAddress() - 6;//get LARL instruction address
       Register b1 = getReg1();
       int la = getI2();
       int bump = (2 * getI2());
       b1.setRegValue(address + bump);

	}
}

