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
 * Storage Immediate class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class SIInstruction extends Instruction
{
    int constant;
    Register baseReg1;
    int displacement1;
    

	/**
	 * Constructor for objects of class SS1Instruction
	 */
	public SIInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(4);     //all SI instructions are 4 bytes long
		//length = getCodeI(1).intValue();   //length is in the 2nd byte
		constant = getPlainBinary(1);
		int r1 = Hex.leftDigitAsInt(getCodeI(2));
		baseReg1 = registers.getRegister(r1);
		displacement1 = Hex.getDisplacement(getCodeI(2),getCodeI(3));
		setTargetHighlighting(baseReg1.getRegValue() + displacement1);
		setSourceHighlighting(addr + 1);
		setTargetRegHighlighting(-1);
		setSourceRegHighlighting(-1);	
        myMemory.setHighlighting(1, 4, getSourceHighlighting(), getTargetHighlighting(),-1,-1,-1,baseReg1.getRegNumber(),-1);		
	}
	public int getConstant()
	{
	    return constant;
	}
	public Register getBaseReg1()
	{
	    return baseReg1;
	}
	
	public int getDisplacement1()
	{
	    return displacement1;
	}	
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
