
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
public class TMY extends SIYInstruction
{
	/**
	 * Constructor for objects of class TM
	 */
	public TMY(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " Test Under Mask - SIY\n Object Code:  OPCODE|I2I2|B1DL1|DL1DL1|DH1DH1|OPCODE\n Explicit Format: D1(B1),I2";
		setDescription(d);		
		setSourceHighlighting(addr+1);
		setTargetHighlighting(getEffectiveAddress());
		setSourceRegHighlighting(-1);
		setTargetRegHighlighting(-1);
		setIndexRegHighlighting(-1);		
		setBaseReg1Highlighting(getBaseReg1().getRegNumber());
	}

	/**
	 * execute - emulates execution of an TMY instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getBaseReg1();
		PSW psw = getPSW();
		int constant = getConstant();
		Memory memory = getMemory();
		Byte bt = memory.getByte(getEffectiveAddress());
		int btInt = 0;
		if (bt.intValue() < 0)
        {
           btInt = bt.intValue() + 256;
        }
        else
        {
           btInt = bt.intValue();
        }
		boolean allOnes = true;
		boolean foundAOne = false;
		String bitM = Integer.toBinaryString(constant);
		while(bitM.length() < 8)
		{
		    bitM = "0" + bitM;
		}		
		String bitT = Integer.toBinaryString(btInt);
		while(bitT.length() < 8)
		{
		    bitT = "0" + bitT;
		}
		for (int i=0;i < 8;i++)
		{ 
		    if ((bitM.charAt(i) == '1') && (bitT.charAt(i) == '0'))
		    {
		        allOnes = false;
		    }
		    if ((bitM.charAt(i) == '1') && (bitT.charAt(i) == '1'))
		    {
		        foundAOne = true;
		    }
		}
		if (! foundAOne)
		{
			psw.setConditionCode(PSW.EQUAL); // all 0's
			return;
		} else if (allOnes)
		{
		    psw.setConditionCode(PSW.OVERFLOW);  //all 1's
		    return;
		}
		else
		{
		    psw.setConditionCode(PSW.LOW);   //mixed 0's and 1's
		    return;
		}
	}
}
