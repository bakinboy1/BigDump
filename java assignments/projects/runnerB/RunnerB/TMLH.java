
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
public class TMLH extends RIaInstruction
{
	/**
	 * Constructor for objects of class TMLH
	 */
	public TMLH(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " Test Under Mask LH- RIa\n Object Code:  OPCODE|R1'0'|I21I2|I2I2\n Explicit Format: R1,I2";
		setDescription(d);		
		setTargetHighlighting(-1);
		setIndexRegHighlighting(-1);	
		setSourceHighlighting(addr+2);
 		setSourceRegHighlighting(getR1No());
 		setTargetRegHighlighting(-1); 
 		setBaseReg1Highlighting(-1);
 		setBaseReg2Highlighting(-1);
	}

	/**
	 * execute - emulates execution of an TMLH instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getReg1();
		PSW psw = getPSW();
		short mask = getMask();
		String bitM = Integer.toBinaryString(Short.toUnsignedInt(mask));
		while (bitM.length() < 16)
		{
		    bitM = "0" + bitM;
		}
		Memory memory = getMemory();
		String bitT = b1.grandeRegToBinaryString().substring(32,48);
		boolean allOnes = true;
		boolean foundAOne = false;
		boolean firstTestedBitOne = false;
		int k = bitM.indexOf('1',0);
		if (k == -1)
		{
		    psw.setConditionCode(PSW.EQUAL);
		    return;
		}
		else if (bitT.charAt(k) == '1')
		{
		    firstTestedBitOne = true;
		}

		for (int i=0;i < 16;i++)
		{ 
		    if ((bitM.charAt(i) == '1') && (bitT.charAt(i) == '0'))
		    {
		        allOnes = false;
		    }
		}
		if (allOnes)
		{
			psw.setConditionCode(PSW.OVERFLOW); // all 1's
			return;
		} 
		if (! allOnes && !firstTestedBitOne)
		{
		    psw.setConditionCode(PSW.LOW);   //mixed 0's and 1's
		    return;
		}
		if (! allOnes && firstTestedBitOne)
		{
		    psw.setConditionCode(PSW.HIGH);
		    return;
		}
	}
}
