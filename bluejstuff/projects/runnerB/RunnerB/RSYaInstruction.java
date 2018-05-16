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
 * RSYa Instruction format class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RSYaInstruction extends Instruction
{
    private int r1;
    private int r2;
    private int r3;
    private Register b2;
    private Register reg1;
    private Register reg3;
    private int displacement;
    private int effectiveAddress;
    
	/**
	 * Constructor for objects of class SS1Instruction
	 */
	public RSYaInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(6);     //all SS1 instructions are 6 bytes long
		//length = getCodeI(1).intValue();   //length is in the 2nd byte
		r1 = Hex.leftDigitAsInt(getCodeI(1));
		r3 = Hex.rightDigitAsInt(getCodeI(1));
		r2 = Hex.leftDigitAsInt(getCodeI(2));
		reg1 = getRegisters().getRegister(r1);
		b2 = getRegisters().getRegister(r2);
		int b2No = b2.getRegNumber();
		reg3 = getRegisters().getRegister(r3);
		displacement = Hex.getDisplacement20(getCodeI(2),getCodeI(3),getCodeI(4));
		if (b2No != 0)
 		{
    		effectiveAddress = b2.getRegValue() + displacement;
        }
        else
        {
            effectiveAddress = displacement;
        }
		myMemory.setHighlighting(1, 6, -1, -1, r1,r3,-1,-1,r2);				
    }

	public Register getReg1()
	{
	    return reg1;
	}
	public Register getReg3()
	{
	    return reg3;
	}	
	public Register getBaseReg2()
	{
	    return b2;
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
