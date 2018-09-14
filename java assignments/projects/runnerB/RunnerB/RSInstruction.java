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
 * RSInstruction Format.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RSInstruction extends Instruction
{
    private Register reg1;
    private Register reg3;
    private Register baseReg2;
    private int displacement;
    private int effectiveAddress;

	/**
	 * Constructor for objects of class SS1Instruction
	 */
	public RSInstruction(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(4);     //all RX instructions are 4 bytes long
		
		int r1   = Hex.leftDigitAsInt(getCodeI(1));
		reg1 = registers.getRegister(r1);
	
		int i2   = Hex.rightDigitAsInt(getCodeI(1));
		reg3 = registers.getRegister(i2);
		
		int r2 = Hex.leftDigitAsInt(getCodeI(2));
		baseReg2 = registers.getRegister(r2);
	   
		displacement = Hex.getDisplacement(getCodeI(2),getCodeI(3));
		effectiveAddress = baseReg2.getRegValue() + displacement;
		setTargetHighlighting(effectiveAddress);  //can't be sure which is
		setSourceHighlighting(effectiveAddress);  // source... and which is target
        myMemory.setHighlighting(1, 4, getSourceHighlighting(), getTargetHighlighting(), 0,0,-1,-1,r2);		
		//myMemory.setHighlighting(1,4,0,0);
	}
	public Register getBaseReg1()
	{
	    return reg1;
	}
	public Register getBaseReg3()
	{
	    return reg3;
	}	
	public Register getBaseReg2()
	{
	    return baseReg2;
	}
	public int getDisplacement()
	{
	    return displacement;
	}	
	public int getEffectiveAddress()
	{
	    return effectiveAddress;
	}
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
