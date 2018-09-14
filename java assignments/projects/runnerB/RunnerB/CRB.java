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

public class CRB extends RRSInstruction
{
	/**
	 * Constructor for objects of class CRB
	 */
	public CRB(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " CRB - Compare Registers and Branch - RRS\n Object Code:  OPCODE|R1R2|B4D4|D4D4|M3///|OPCODE\n Explicit Format: R1,R2,M3,D4(B4)";
		setDescription(d);	
		setSourceHighlighting(-1);
		setTargetHighlighting(getEffectiveAddress());
		//setSourceRegHighlighting(getBaseReg2().getRegNumber());
		setTargetRegHighlighting(getReg1().getRegNumber());		
		setIndexRegHighlighting(-1);		
	    setSourceRegHighlighting(getReg2().getRegNumber());	
	    setBaseReg2Highlighting(getBaseReg().getRegNumber());		    
	}

	/**
	 * execute - emulates execution of a CRB instruction
	 * 
	 */
	public void execute()
	{
	    PSW psw = getPSW();
		Register b1 = getReg1();
		Register b2 = getReg2();
		int condCode = b1.compare(b2); //get the condition code
		psw.setConditionCode(condCode);
        int mask = getMask();
        int obit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask
        int hbit = mask % 2;   //grab the high bit
        mask = mask / 2;       //remove it from the mask        
        if((hbit == 1) && (condCode == 2))
        {
            psw.setInstructionAddress(getEffectiveAddress());
        }
        int lbit = mask % 2;   //grab the low bit
        mask = mask / 2;       //remove it from the mask        
        if((lbit == 1) && (condCode == 1))
        {
            psw.setInstructionAddress(getEffectiveAddress());
        }        
        int ebit = mask % 2;   //grab the equal bit
        mask = mask / 2;       //remove it from the mask        
        if((ebit == 1) && (condCode == 0))
        {
            psw.setInstructionAddress(getEffectiveAddress());
        }                
	}
}
