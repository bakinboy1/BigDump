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
 * RSLa Instruction format class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RSLaInstruction extends Instruction
{
    private int b1No;
    private Register b1Reg;
    private int displacement;
    private int length;
    private int effectiveAddress;
    
	/**
	 * Constructor for objects of class RSLaInstruction
	 */
	public RSLaInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(6);     //all RXYa instructions are 6 bytes long
		length = Hex.leftDigitAsInt(getCodeI(1));
		b1No = Hex.leftDigitAsInt(getCodeI(2));
		b1Reg = getRegisters().getRegister(b1No);
		displacement = Hex.getDisplacement(getCodeI(2),getCodeI(3));
		if (b1No!= 0)
 		{
    		   effectiveAddress = b1Reg.getRegValue() + displacement;
        }
        else
        {
               effectiveAddress = displacement;
        }
		myMemory.setHighlighting(1, 6, -1, getTargetHighlighting(), -1,-1,-1,b1No,-1);				
    }

	public Register getBaseReg1()
	{
	    return b1Reg;
	}
	public int getBaseReg1No()
	{
	    return b1No;
	}
	public int getDisplacement()
	{
	    return displacement;
	}
	public int getEffectiveAddress()
	{
	    return effectiveAddress;
	}
	public int getLength()
	{
	    return length;
	}
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
