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

public class BC extends RXInstruction
{
	/**
	 * Constructor for objects of class BC
	 */
	public BC(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " BC - Branch on Condition - RX\n Object Code:  OPCODE|M1X2|B2D2|D2D2\n Explicit Format: M1,D2(X2,B2)";
		setDescription(d);	
		setSourceHighlighting(-1);
		setTargetHighlighting(getEffectiveAddress());
		//setSourceRegHighlighting(getBaseReg2().getRegNumber());
		setTargetRegHighlighting(-1);		
		setIndexRegHighlighting(getIndexReg2().getRegNumber());		
	    setBaseReg2Highlighting(getBaseReg2().getRegNumber());	
	}

	/**
	 * execute - emulates execution of a BC instruction
	 * 
	 */
	public void execute()
	{
	    PSW psw = getPSW();
        int condCode = psw.fetchConditionCode();
        int mask = getMask();
        Register reg2 = getBaseReg2();
        int abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask
        if((abit == 1) && (condCode == 3))
        {
            psw.setInstructionAddress(getEffectiveAddress());
        }
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 2))
        {
            psw.setInstructionAddress(getEffectiveAddress());
        }
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 1))
        {
            psw.setInstructionAddress(getEffectiveAddress());
        }        
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 0))
        {
            psw.setInstructionAddress(getEffectiveAddress());
        }                
	}
}
