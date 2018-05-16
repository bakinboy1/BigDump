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
 * RIEb Instruction format class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RIEbInstruction extends Instruction
{
    private int r1No;
    private int r2No;
    private Register r1Reg;
    private Register r2Reg;
    private int ri4;  //no of halfwords added to the address of instruction
    private int mask;
    private int effectiveAddress;
    
	/**
	 * Constructor for objects of class RRSInstruction
	 */
	public RIEbInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(6);     //all RIE instructions are 6 bytes long
		r1No = Hex.leftDigitAsInt(getCodeI(1));
		r2No = Hex.rightDigitAsInt(getCodeI(1));
		ri4 = Memory.toIntFromTwoBytes(getCodeI(2),getCodeI(3));
		r1Reg = getRegisters().getRegister(r1No);
		r2Reg = getRegisters().getRegister(r2No);
		mask =  Hex.leftDigitAsInt(getCodeI(4));
		int source = psw.fetchInstructionAddress();  
        int bump = (2 * getRI4());
        effectiveAddress = source + bump;
        setTargetHighlighting(effectiveAddress);
		myMemory.setHighlighting(1, 6, -1, getTargetHighlighting(), -1,-1,-1,-1,-1);				
    }

	public Register getReg1()
	{
	    return r1Reg;
	}
	public int getReg1No()
	{
	    return r1No;
	}
	public Register getReg2()
	{
	    return r2Reg;
	}	
	public int getReg2No()
	{
	    return r2No;
	}
	public int getRI4()
	{
	    return ri4;
	}
	public int getEffectiveAddress()
	{
	    return effectiveAddress;
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
