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
 * Translate and Test - TRT.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */

public class TRT extends SS1Instruction
{
    private static final int NOREGBITS = 32;
	/**
	 * Constructor for objects of class MVC
	 */
	public TRT(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " TRT - Translate and Test - SS1\n Object Code:  OPCODE|LL1|B1D1|D1D1|B2D2|D2D2\n Explicit Format: D1(L,B1),D2(B2)";
		setDescription(d);			
	}

	/**
	 * execute - emulates execution of an SS1 instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getBaseReg1();
		Register b2 = getBaseReg2();
		PSW psw = getPSW();
		int disp1 = getDisplacement1();
		int disp2 = getDisplacement2();
		int target = b1.getRegValue() + disp1;
		int source = b2.getRegValue() + disp2;
		int len = getLength();
		len++;  //object code length is one less than actual
		Memory memory = getMemory();
		int ptrT = target;		
		boolean ALLZEROES = true;
		while ((len > 0) && ALLZEROES)
		{
		    Byte byte1 = memory.getByte(ptrT);
		    int ptrS = source + byte1;
		    Byte byte2 = memory.getByte(ptrS);
		    if (byte2 == 0)
		    {
		       ptrT++;
		       len--;
		    }
		    else
		    {
		       Registers regs = getRegisters();
		       Register r1 = regs.getRegister(1);
		       Register r2 = regs.getRegister(2);
		       r1.setRegValue(ptrS);
		       int temp = r2.getRegValue();
		       temp = temp >>> 8;
		       temp = temp << 8;
		       int temp2 = (int) byte2;
		       temp2 = temp2 <<  (NOREGBITS - 8);
		       temp2 = temp2 >>> (NOREGBITS - 8);
		       temp = temp | temp2;
		       r2.setRegValue(temp);
		       ALLZEROES = false;
		    }
		}
		if (ALLZEROES)
		{
		    psw.setConditionCode(EQUAL);
		}
		else if (len > 0)
		{
		    psw.setConditionCode(LOW);
		}
		else
		{
		    psw.setConditionCode(HIGH);
		}
	}
}
