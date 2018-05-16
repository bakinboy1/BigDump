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

public class BCR extends RRInstruction
{
	/**
	 * Constructor for objects of class BCR
	 */
	public BCR(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " BCR - Branch on Condition Register - RR\n Object Code:  OPCODE|M1R2\n Explicit Format:  M1,R2";
		setDescription(d);	
		setSourceHighlighting(-1);   //no highlighting memory
		setTargetHighlighting(getReg2().getRegValue());   //no highlighting memory	
		setSourceRegHighlighting(getReg2().getRegNumber()); // no register highlighting
		setTargetRegHighlighting(-1);
	}

	/**
	 * execute - emulates execution of an BCR instruction
	 * 
	 */
	public void execute()
	{
	    PSW psw = getPSW();
        int condCode = psw.fetchConditionCode();
        int mask = getMask();
        Register reg2 = getReg2();
        int abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask
        if((abit == 1) && (condCode == 3))
        {
            psw.setInstructionAddress(reg2.getRegValue());
        }
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 2))
        {
            psw.setInstructionAddress(reg2.getRegValue());
        }
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 1))
        {
            psw.setInstructionAddress(reg2.getRegValue());
        }        
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 0))
        {
            psw.setInstructionAddress(reg2.getRegValue());
        }                
	}
}
