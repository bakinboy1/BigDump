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
 * Register to Register class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RRInstruction extends Instruction
{
    Register reg1;
    Register reg2;
    int mask;

	/**
	 * Constructor for objects of class RRInstruction
	 */
	public RRInstruction(int addr, Memory myMemory, PSW psw, Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(2);           // 2 bytes for RR
		Byte b = getCodeI(1);
		int r1 = Hex.leftDigitAsInt(b);
		int r2 = Hex.rightDigitAsInt(b);
		mask = r1;   //these bits sometimes represent a mask
		reg1 = registers.getRegister(r1);
		reg2 = registers.getRegister(r2);
		setSourceHighlighting(-1);  // no source in memory
		setTargetHighlighting(-1);  // no target in memory
		myMemory.setHighlighting(1, 2, getSourceHighlighting(), getTargetHighlighting(), reg1.getRegNumber(),reg2.getRegNumber(),-1,-1,-1);		
	}
	public Register getReg1()
	{
	    return reg1;
	}
	public Register getReg2()
	{
	    return reg2;
	}
	public int getMask()
	{
	    return mask;
	}
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
