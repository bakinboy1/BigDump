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
 * Move Immediate - MVI.
 * 
 * @author Woolbright 
 * @version 2007
 */
public class MVI extends SIInstruction
{
	/**
	 * Constructor for objects of class MVI
	 */
	public MVI(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " MVI - Move Immediate - SI\n Object Code:  OPCODE|I2I2|B1D1|D1D1\n Explicit Format: D1(B1),I2";
		setDescription(d);		
		setSourceHighlighting(addr+1);
		Register b1 = getBaseReg1();
		int disp1 = getDisplacement1();
		setTargetHighlighting(b1.getRegValue() + disp1);
		setSourceRegHighlighting(-1);
		setTargetRegHighlighting(-1);
		setIndexRegHighlighting(-1);	
		setBaseReg1Highlighting(getBaseReg1().getRegNumber());	
	}

	/**
	 * execute - emulates execution of an MVI instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getBaseReg1();
		int disp1 = getDisplacement1();
		int target = b1.getRegValue() + disp1;
		int constant = getConstant();
		Memory memory = getMemory();
		memory.setByte(target,getCodeI(1));
	}
}
