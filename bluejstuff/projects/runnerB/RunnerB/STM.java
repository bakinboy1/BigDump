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
 * Store Multiple Registers.
 * 
 * @author Woolbright
 * @version 2011
 */
public class STM extends RSInstruction
{
	/**
	 * Constructor for objects of class STM
	 */
	public STM(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " STM - Store Multiple - RS\n Object Code:  OPCODE|R1R3|B2D2|D2D2\n Explicit Format: R1,R3,D2(B2)";
		setDescription(d);		
		setSourceHighlighting(-1); // no source highlighting in memory
		Register baseReg1 = getBaseReg1();
		Register baseReg2 = getBaseReg2();
		Register baseReg3 = getBaseReg3();
		int displacement = getDisplacement();
	    setTargetHighlighting(baseReg2.getRegValue() + displacement);	
	    setSourceRegHighlighting(baseReg1.getRegNumber());
	    setTargetRegHighlighting(baseReg2.getRegNumber());
	    setIndexRegHighlighting(baseReg3.getRegNumber());
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());	    
	}

	/**
	 * execute - emulates execution of a STM instruction
	 * 
	 */
	public void execute() 
	{
		Register b1 = getBaseReg1();
		Register b3 = getBaseReg3();
		int firstReg = b1.getRegNumber();
		int lastReg = b3.getRegNumber();
		Register baseReg2 = getBaseReg2();
		int displacement = getDisplacement();
	    int target = baseReg2.getRegValue() + displacement;
	    Memory memory = getMemory();    
		if (firstReg <= lastReg)
		{
		   int currentReg = firstReg;
		   while (currentReg <= lastReg)
		   {
		      Register reg = getRegisters().getRegister(currentReg);
		      String regContents = reg.toHexString();
		      String s1 = regContents.substring(0,2);
		      String s2 = regContents.substring(2,4);
		      String s3 = regContents.substring(4,6);
		      String s4 = regContents.substring(6,8);
		      int v1 = Hex.toIntFromHexString2(s1);
		      int v2 = Hex.toIntFromHexString2(s2);
		      int v3 = Hex.toIntFromHexString2(s3);
		      int v4 = Hex.toIntFromHexString2(s4);
		      memory.setByte(target,new Byte((byte)v1));
			  memory.setByte(target+1,new Byte((byte)v2));
			  memory.setByte(target+2,new Byte((byte)v3));
			  memory.setByte(target+3,new Byte((byte)v4));
			  target = target + 4;
			  currentReg = currentReg + 1;
		   }
		}
		else
		{
		   int currentReg = firstReg;
		   while (currentReg <= 15)
		   { 
		      Register reg = getRegisters().getRegister(currentReg);
		      String regContents = reg.toHexString();
		      String s1 = regContents.substring(0,2);
		      String s2 = regContents.substring(2,4);
		      String s3 = regContents.substring(4,6);
		      String s4 = regContents.substring(6,8);
		      int v1 = Hex.toIntFromHexString2(s1);
		      int v2 = Hex.toIntFromHexString2(s2);
		      int v3 = Hex.toIntFromHexString2(s3);
		      int v4 = Hex.toIntFromHexString2(s4);
		      memory.setByte(target,new Byte((byte)v1));
			  memory.setByte(target+1,new Byte((byte)v2));
			  memory.setByte(target+2,new Byte((byte)v3));
			  memory.setByte(target+3,new Byte((byte)v4));
			  target = target + 4;
			  currentReg = currentReg + 1; 
		   }		    
		   currentReg = 0;
		   while (currentReg <= lastReg)
		   {
		      Register reg = getRegisters().getRegister(currentReg);
		      String regContents = reg.toHexString();
		      String s1 = regContents.substring(0,2);
		      String s2 = regContents.substring(2,4);
		      String s3 = regContents.substring(4,6);
		      String s4 = regContents.substring(6,8);
		      int v1 = Hex.toIntFromHexString2(s1);
		      int v2 = Hex.toIntFromHexString2(s2);
		      int v3 = Hex.toIntFromHexString2(s3);
		      int v4 = Hex.toIntFromHexString2(s4);
		      memory.setByte(target,new Byte((byte)v1));
			  memory.setByte(target+1,new Byte((byte)v2));
			  memory.setByte(target+2,new Byte((byte)v3));
			  memory.setByte(target+3,new Byte((byte)v4));
			  target = target + 4;
			  currentReg = currentReg + 1; 
		   }
	    }
	}
}
