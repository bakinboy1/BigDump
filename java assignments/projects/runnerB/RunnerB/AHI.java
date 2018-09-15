
// Copyright (c) 2016, David E. Woolbright, Vladimir Zanev
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
public class AHI extends RIaInstruction
{
	/**
	 * Constructor for objects of class AHI
	 */
	public AHI(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = "Add Halfword Immediate - RIa\n Object Code:  OPCODE|R1'A'|I21I2|I2I2\n Explicit Format: R1,I2";
		setDescription(d);		
		setSourceHighlighting(addr+2);
		setTargetHighlighting(-1);
 		setTargetRegHighlighting(getR1No()); 
	}

	/**
	 * execute - emulates execution of an AHI instruction
	 * 
	 */
	public void execute()
	{
	    Register b1 = getReg1();
		PSW psw = getPSW();
		Memory memory = getMemory();
		int val = (int)getConstant();
		int oldRegVal = b1.getRegValue();
		b1.add(val);
		int newRegVal = b1.getRegValue();
		if(newRegVal == 0)
		{
		   psw.setConditionCode(0);		    
		}
		else if (newRegVal < 0)
		{
		    psw.setConditionCode(1);
		}
		else
		{
		    psw.setConditionCode(2);
		}	
		if (((val < 0) && (oldRegVal < 0) && (newRegVal >= 0)) || ((val > 0) && (oldRegVal > 0) && (newRegVal <= 0)))  
		{
		    psw.setConditionCode(3);
		}		
	}
}
	    