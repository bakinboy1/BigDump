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
public class SLDL extends RSInstruction
{
	/**
	 * Constructor for objects of class SLDL
	 */
	public SLDL(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " Shift Left Double Logical - RS\n Object Code:  OPCODE|R1R3|B2D2|D2D2\n Explicit Format: R1,R3,D2(B2)";
		setDescription(d);	
		setTargetHighlighting(-1); // no highlighting in memory
		Register baseReg1 = getBaseReg1();
		Register baseReg2 = getBaseReg2();
		Register baseReg3 = getBaseReg3();
		int displacement = getDisplacement();
		setSourceHighlighting(-1);
		setSourceRegHighlighting(-1);
		setTargetRegHighlighting(baseReg1.getRegNumber());
		setIndexRegHighlighting(baseReg3.getRegNumber());	
		setBaseReg2Highlighting(getBaseReg2().getRegNumber());
	}

	/**
	 * execute - emulates execution of a SLDA instruction
	 * 
	 */
	public void execute()
	{
		Register evenReg = getBaseReg1();
		int evenRegNo = evenReg.getRegNumber();
		if ( evenRegNo % 2 != 0)
		{
		    throw new SpecificationException("First Operand must be an even-numbered register");
		}
		int oddRegNo = evenRegNo + 1;  //multiplicand in the odd register
		PSW psw = getPSW();
		Registers regs = getRegisters();
		Register oddReg = regs.getRegister(oddRegNo);
		int val1 = evenReg.getRegValue();
		int val2 = oddReg.getRegValue();
		long bigVal = 1;
		Register baseReg2 = getBaseReg2();
		int displacement = getDisplacement();
	    int source = baseReg2.getRegValue() + displacement;
	    int shiftFactor = source % 64;  //last six bits is the shift factor
	    
	    String bitsVal2 = Integer.toBinaryString(new Integer(val2));
	    String bitsVal1 = Integer.toBinaryString(new Integer(val1));
	    
        while(bitsVal1.length() < 32)
        {
            bitsVal1 =  "0"  + bitsVal1;
        }
        while(bitsVal2.length() < 32)
        {
            bitsVal2 = "0"  + bitsVal2;
        }
	    String ones   = "1111111111111111111111111111111111111111111111111111111111111111";
	    String zeroes = "0000000000000000000000000000000000000000000000000000000000000000";
	    
        String bitsVal = bitsVal1 + bitsVal2;
        bitsVal = bitsVal.substring(shiftFactor) + zeroes.substring(0,shiftFactor);

	    bitsVal1 = bitsVal.substring(0,32);
	    bitsVal2 = bitsVal.substring(32);
	    evenReg.setRegValue((int) Long.parseLong(bitsVal1,2));
	    oddReg.setRegValue((int) Long.parseLong(bitsVal2,2));
	    
	}
}
