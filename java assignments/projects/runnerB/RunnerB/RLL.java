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

public class RLL extends RSYaInstruction
{
	/**
	 * Constructor for objects of class RLL
	 */
	public RLL(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " Rotate Left Single Logical - RSY-a\n Object Code:  OPCODE|R1R3|B2DL2|DL2DL2|DH2DH2|OPCODE\n Explicit Format: R1,R3,D2(B2)";
		setDescription(d);	
		//setTargetHighlighting(getEffectiveAddress()); // no highlighting in memory
		Register baseReg1 = getReg1();
		Register baseReg3 = getReg3();
		setSourceHighlighting(-1);
		setTargetHighlighting(-1);
		setSourceRegHighlighting(baseReg3.getRegNumber());
		setTargetRegHighlighting(baseReg1.getRegNumber());
		setIndexRegHighlighting(-1);	
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());
	}

	/**
	 * execute - emulates execution of a RLL instruction
	 * 
	 */
	public void execute()
	{
 	    Register r1 = getReg1();
 	    Register r3 = getReg3();
 		int displacement = getDisplacement();
 		int shiftSource = getEffectiveAddress();
	    int shiftFactor = (shiftSource % 64);  //recover last 6 digits
	    int val1 = r3.getRegValue();
	    int val2 = Integer.rotateLeft(val1,shiftFactor);
	    r1.setRegValue(val2);
	    

	}
}
