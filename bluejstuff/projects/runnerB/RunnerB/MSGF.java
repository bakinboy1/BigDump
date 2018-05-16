// Copyright (c) 2016, David E. Woolbright, Vladimir Zanev
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
public class MSGF extends RXYaInstruction
{
	/**
	 * Constructor for objects of class MSGF
	 */
	public MSGF(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " MSG - Multiply Single Grande Fullword - RXYa\n Object Code:  OPCODE|R1X2|B2DL2|DL2DL2|DH2DH2|OPCODE\n Explicit Format: R1,D2(X2,B2)";
		setDescription(d);		
		setSourceHighlighting(-1);
		int x = getEffectiveAddress();
		setTargetHighlighting(getEffectiveAddress());
		setSourceRegHighlighting(getReg1().getRegNumber());
		setIndexRegHighlighting(getIndexReg2().getRegNumber());		
	    setBaseReg2Highlighting(getBaseReg2().getRegNumber());	
	}

	/**
	 * execute - emulates execution of an MSGF instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getReg1();
		Register b2 = getBaseReg2();
		Register i2 = getIndexReg2();
		PSW psw = getPSW();
		int source = getEffectiveAddress();
		Memory memory = getMemory();
		int x = memory.getSize();
		if (source - 8 > memory.getSize())
		{
		    System.out.println("0C4 - Protection Exception");
		}
        long val = (long) Memory.toIntFromFourBytes(memory.getByte(source),memory.getByte(source+1),memory.getByte(source+2),memory.getByte(source+3));
		long oldRegVal = b1.getLongRegValue();  
		long newRegVal = val * oldRegVal;
		b1.setLongRegValue(newRegVal);


	}
}