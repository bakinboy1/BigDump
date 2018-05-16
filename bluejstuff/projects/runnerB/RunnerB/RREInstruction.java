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
 * RRE  Instruction format class.
 * 
 * @author Woolbright
 * @version 2014
 */
public class RREInstruction extends Instruction
{
    private int r1No;  
    private int r2No;
    private Register r1Reg;
    private Register r2Reg;
    
	/**
	 * Constructor for objects of class RREInstruction
	 */
	public RREInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(4);     
		r1No = Hex.leftDigitAsInt(getCodeI(3));
		r1Reg =  registers.getRegister(r1No);
		r2No = Hex.rightDigitAsInt(getCodeI(3));
		r2Reg =  registers.getRegister(r2No);		
				
    }

	public int getR1No()
	{
	    return r1No;
	}
	public int getR2No()
	{
	    return r1No;
	}	
	public Register getReg1()
	{
	    return r1Reg;
	}
	public Register getReg2()
	{
	    return r2Reg;
	}	
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
