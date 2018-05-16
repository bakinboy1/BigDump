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
 * Load Multiple Registers.
 * 
 * @author Woolbright
 * @version 2011
 */
public class LMY extends RSYaInstruction
{
	/**
	 * Constructor for objects of class LMG
	 */
	public LMY(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " LMY - Load Multiple  - RSY-a\n Object Code:  OPCODE|R1R3|B2DL2|DL2DL2|DH2DH2|OPCODE\n Explicit Format: R1,R3,D2(B2)";
		setDescription(d);	
		setTargetHighlighting(-1); // no highlighting in memory
		Register r1 = getReg1();
		Register r3 = getReg3();
		Register baseReg2 = getBaseReg2();
		setSourceHighlighting(getEffectiveAddress());
		setSourceRegHighlighting(baseReg2.getRegNumber());
		setTargetRegHighlighting(r1.getRegNumber());
		setIndexRegHighlighting(r3.getRegNumber());		
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());		
	}

	/**
	 * execute - emulates execution of a RS instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getReg1();
		Register b3 = getReg3();
		int firstReg = b1.getRegNumber();
		int lastReg = b3.getRegNumber();
		Register baseReg2 = getBaseReg2();
	    int source = getEffectiveAddress();
	    Memory memory = getMemory();    
		if (firstReg <= lastReg)
		{
		   int currentReg = firstReg;
		   while (currentReg <= lastReg)
		   {
		      int val = Memory.toIntFromFourBytes(memory.getByte(source),memory.getByte(source+1),memory.getByte(source+2),memory.getByte(source+3));
		      Register reg = getRegisters().getRegister(currentReg);
		      reg.setRegValue(val);
		      currentReg = currentReg + 1;
		      source = source + 4;    //skip to next word
		   }
		}
		else
		{
		   int currentReg = firstReg;
		   while (currentReg <= 15)
		   {
		       int val = Memory.toIntFromFourBytes(memory.getByte(source),memory.getByte(source+1),memory.getByte(source+2),memory.getByte(source+3));
		      Register reg = getRegisters().getRegister(currentReg);
		      reg.setRegValue(val);
		      currentReg = currentReg + 1;
		      source = source + 4;    //skip to next word
		   }		    
		   currentReg = 0;
		   while (currentReg <= lastReg)
		   {
		      int val = Memory.toIntFromFourBytes(memory.getByte(source),memory.getByte(source+1),memory.getByte(source+2),memory.getByte(source+3));
		      Register reg = getRegisters().getRegister(currentReg);
		      reg.setRegValue(val);
		      currentReg = currentReg + 1;
		      source = source + 4;    //skip to next word
		   }
	    }
	}
}
