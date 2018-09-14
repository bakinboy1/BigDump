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
 * Storage to Storage type 2 class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class SS2Instruction extends Instruction
{
    int length1;
    int length2;
    Register baseReg1;
    Register baseReg2;
    int baseReg1No;
    int baseReg2No;
    int displacement1;
    int displacement2;

	/**
	 * Constructor for objects of class SS1Instruction
	 */
	public SS2Instruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(6);     //all SS1 instructions are 6 bytes long
		//length = getCodeI(1).intValue();   //length is in the 2nd byte
		length1 = getLength1();
		length2 = getLength2();
		int r1 = Hex.leftDigitAsInt(getCodeI(2));
		int r2 = Hex.leftDigitAsInt(getCodeI(4));
		baseReg1 = getRegisters().getRegister(r1);
		baseReg2 = getRegisters().getRegister(r2);
		displacement1 = Hex.getDisplacement(getCodeI(2),getCodeI(3));
		displacement2 = Hex.getDisplacement(getCodeI(4),getCodeI(5));
		setTargetHighlighting(baseReg1.getRegValue() + displacement1);
		setSourceHighlighting(baseReg2.getRegValue() + displacement2);	
// 		setBaseReg1No(r1);
// 		setBaseReg2No(r2);
		setBaseReg1Highlighting(r1);
		setBaseReg2Highlighting(r2);
// 	    setTargetRegHighlighting(-1);
// 		setSourceRegHighlighting(-1);	
        myMemory.setHighlighting(1, 6, getSourceHighlighting(), getTargetHighlighting(),-1,-1,-1,r1,r2);				
	}

	public Register getBaseReg1()
	{
	    return baseReg1;
	}
	public Register getBaseReg2()
	{
	    return baseReg2;
	}	
	public int getDisplacement1()
	{
	    return displacement1;
	}
	public int getDisplacement2()
	{
	    return displacement2;
	}	
	public void setBaseReg1(Register b)
	{
	    baseReg1 = b;
	}
	public void setBaseReg2(Register b)
	{
	    baseReg2 = b;
	}		
	public void setBaseReg1No(int b)
	{
	    baseReg1No = b;
	}
	public void setBaseReg2No(int b)
	{
	    baseReg2No = b;
	}
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
