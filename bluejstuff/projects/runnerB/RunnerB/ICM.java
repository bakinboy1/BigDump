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

public class ICM extends RSInstruction
{
	/**
	 * Constructor for objects of class ICM
	 */
	public ICM(int addr, Memory memory,PSW psw,Registers registers)
	{
		super(addr,memory,psw,registers);
		String d = " ICM - Insert Characters Under Mask - RS\n Object Code:  OPCODE|R1M3|B2D2|D2D2\n Explicit Format: R1,M3,D2(B2)";
		setDescription(d);	
		setTargetHighlighting(getEffectiveAddress());
		Register baseReg1 = getBaseReg1();
		Register baseReg2 = getBaseReg2();
		int displacement = getDisplacement();
		setSourceHighlighting(baseReg2.getRegValue() + displacement);
		setSourceRegHighlighting(-1);
		setTargetRegHighlighting(baseReg1.getRegNumber());		
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());		
	}

	/**
	 * execute - emulates execution of a ICM instruction
	 * 
	 */
	public void execute()
	{
		int mask   = Hex.rightDigitAsInt(getCodeI(1));
		Register b1 = getBaseReg1();
		Register b3 = getBaseReg3();
		Register b2 = getBaseReg2();
		int displacement = getDisplacement();
	    int source = b2.getRegValue() + displacement;
	    Memory memory = getMemory(); 
	    String regb0 = b1.getByteAsString(0);
		String regb1 = b1.getByteAsString(1);
	    String regb2 = b1.getByteAsString(2);
		String regb3 = b1.getByteAsString(3);
		String memb0 = memory.getByteAsString(source);
		String memb1 = memory.getByteAsString(source+1);	
		String memb2 = memory.getByteAsString(source+2);
		String memb3 = memory.getByteAsString(source+3);	
		String val = "";
		int maskBit3 = mask % 2;
		mask = mask / 2;
		int maskBit2 = mask % 2;
		mask = mask / 2;
		int maskBit1 = mask % 2;
		int maskBit0 = mask / 2;
	    val = (maskBit0 == 1)? val + memb0 : val + regb3;
	    val = (maskBit1 == 1)? val + memb1 : val + regb2;	
	    val = (maskBit2 == 1)? val + memb2 : val + regb1;	
        val = (maskBit3 == 1)? val + memb3 : val + regb1;	    
	    int ival = Integer.parseInt(val,16);
	    b1.setRegValue(ival);
	    //set the condition code
	    PSW psw = getPSW();
	    mask = Hex.rightDigitAsInt(getCodeI(1));  // reestablish mask
	    if (mask == 0) 
	    {
	        psw.setConditionCode(0);
	    }
	    if (mask != 0)
	    {
	        if (maskBit3 == 1)
	        {
	            int byteVal = memory.getByte(source);
	            if (byteVal > 127)
	                psw.setConditionCode(1);
	            if (byteVal == 0)
	                psw.setConditionCode(0);
	            else
	                psw.setConditionCode(2);
	        }
	        else if (maskBit2 == 1)
	        {
	            int byteVal = memory.getByte(source+1);
	            if (byteVal > 127)
	                psw.setConditionCode(1);
	            if (byteVal == 0)
	                psw.setConditionCode(0);
	            else
	                psw.setConditionCode(2);
	        }
	        else if (maskBit1 == 1)
	        {
	            int byteVal = memory.getByte(source + 2);
	            if (byteVal > 127)
	                psw.setConditionCode(1);
	            if (byteVal == 0)
	                psw.setConditionCode(0);
	            else
	                psw.setConditionCode(2);
	        }
	        else if (maskBit0 == 1)
	        {
	            int byteVal = memory.getByte(source+3);
	            if (byteVal > 127)
	                psw.setConditionCode(1);
	            if (byteVal == 0)
	                psw.setConditionCode(0);
	            else
	                psw.setConditionCode(2);
	        }
	    }
	            
	           
	        
	}
}
