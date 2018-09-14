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
 * RXYa Instruction format class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RXYaInstruction extends Instruction
{
    private int r1No;
    private int x2No;
    private int b2No;
    private Register b2Reg;
    private Register r1Reg;
    private Register x2Reg;
    private int displacement;
    private int effectiveAddress;
    
	/**
	 * Constructor for objects of class RXYaInstruction
	 */
	public RXYaInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(6);     //all RXYa instructions are 6 bytes long
		r1No = Hex.leftDigitAsInt(getCodeI(1));
		x2No = Hex.rightDigitAsInt(getCodeI(1));
		b2No = Hex.leftDigitAsInt(getCodeI(2));
		r1Reg = getRegisters().getRegister(r1No);
		b2Reg = getRegisters().getRegister(b2No);
		x2Reg = getRegisters().getRegister(x2No);
		displacement = Hex.getDisplacement20(getCodeI(2),getCodeI(3),getCodeI(4));
		if (b2No!= 0)
 		{
 		    if (x2No != 0)
    		   effectiveAddress = b2Reg.getRegValue()
    		                      + x2Reg.getRegValue()
    		                      + displacement;
    		else
    		   effectiveAddress = b2Reg.getRegValue() + displacement;

        }
        else
        {
            if (x2No != 0)
               effectiveAddress = x2Reg.getRegValue() + displacement;
            else
               effectiveAddress = displacement;
        }
		myMemory.setHighlighting(1, 6, -1, getTargetHighlighting(), -1,-1,x2No,-1,b2No);				
    }

	public Register getReg1()
	{
	    return r1Reg;
	}
	public int getReg1No()
	{
	    return r1No;
	}
	public Register getIndexReg2()
	{
	    return x2Reg;
	}
	public int getIndexReg2No()
	{
	    return x2No;
	 }
	public Register getBaseReg2()
	{
	    return b2Reg;
	}
	public int getBaseReg2No()
	{
	    return b2No;
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
