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

public class STGRL extends RILbInstruction
{
	/**
	 * Constructor for objects of class STRL
	 */
	public STGRL(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " STGRL - STORE GRANDE Relative Long - RIL\n Object Code:  OPCODE|R1'f'|RI2RI2|RI2RI2|RI2RI2|RI2RI2\n Explicit Format: R1,RI2";
		setDescription(d);	
		setSourceHighlighting(-1); 
 		setTargetHighlighting(psw.fetchInstructionAddress() + (2 * getRI2()));
    	setSourceRegHighlighting(getR1No());	
		
	}

	/**
	 * execute - emulates execution of a STGRL instruction
	 * 
	 */
	public void execute()
	{
	    Register b1 = getReg1();
		int target = getEffectiveAddress();
		Memory memory = getMemory();
		if (target - 8 > memory.getSize())
		{
		    System.out.println("0C4 - Protection Exception");
		}
		if ( target != (target / 8) * 8)
		{
		    throw new SpecificationException("Specification Exception:  Source must be aligned on a doubleword");
		}
		for(int i=0; i < 8; i++)
		{
           String  bs = b1.getGRegByteAsString(i);
           int ival = Hex.toIntFromHexString2(bs);
           memory.setByte(target,new Byte((byte) ival));
           target = target + 1;
        }
	}
}

