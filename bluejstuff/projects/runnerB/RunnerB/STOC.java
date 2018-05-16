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
 * Store on Condition.
 * 
 * @author Woolbright
 * @version 2011
 */
public class STOC extends RSYbInstruction
{
	/**
	 * Constructor for objects of class STOC
	 */
	public STOC(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " STOC - Store on Condition  - RSY-b\n Object Code:  EB|R1M3|B2DL2|DL2DL2|DH2DH2|E3\n Explicit Format: R1,D2(B2),M3";
		setDescription(d);	
		setTargetHighlighting(-1); // no highlighting in memory
		Register r1 = getReg1();
		Register baseReg2 = getBaseReg2();
		setTargetHighlighting(getEffectiveAddress());
		setSourceRegHighlighting(r1.getRegNumber());
		setBaseReg2Highlighting(baseReg2.getRegNumber());			
	}

	/**
	 * execute - emulates execution of a STOC instruction
	 * 
	 */
	public void execute()
	{
	    PSW psw = getPSW();
        int condCode = psw.fetchConditionCode();
		Register b1 = getReg1();
		int mask = getMask();
		int sourceReg = b1.getRegNumber();
		Register baseReg2 = getBaseReg2();
	    int target = getEffectiveAddress();
	    Memory memory = getMemory();    
        Register reg2 = getBaseReg2();
        int abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask
        if((abit == 1) && (condCode == 3))
        {
            if (target - 4 > memory.getSize())
		    {
		       System.out.println("0C4 - Protection Exception");
		    }
		    for(int i=0; i < 4; i++)
		    {
               String  bs = b1.getByteAsString(i);
               int ival = Hex.toIntFromHexString2(bs);
               memory.setByte(target,new Byte((byte) ival));
               target = target + 1;
            }
        }
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 2))
        {
            if (target - 4 > memory.getSize())
		    {
		       System.out.println("0C4 - Protection Exception");
		    }
		    for(int i=0; i < 4; i++)
		    {
               String  bs = b1.getByteAsString(i);
               int ival = Hex.toIntFromHexString2(bs);
               memory.setByte(target,new Byte((byte) ival));
               target = target + 1;
            }
        }
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 1))
        {
            if (target - 4 > memory.getSize())
		    {
		       System.out.println("0C4 - Protection Exception");
		    }
		    for(int i=0; i < 4; i++)
		    {
               String  bs = b1.getByteAsString(i);
               int ival = Hex.toIntFromHexString2(bs);
               memory.setByte(target,new Byte((byte) ival));
               target = target + 1;
            }
        }        
        abit = mask % 2;   //grab the overflow bit
        mask = mask / 2;       //remove it from the mask        
        if((abit == 1) && (condCode == 0))
        {
            if (target - 4 > memory.getSize())
		    {
		       System.out.println("0C4 - Protection Exception");
		    }
		    for(int i=0; i < 4; i++)
		    {
               String  bs = b1.getByteAsString(i);
               int ival = Hex.toIntFromHexString2(bs);
               memory.setByte(target,new Byte((byte) ival));
               target = target + 1;
            }
        }                
	}
}
