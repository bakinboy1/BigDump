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
 * Multiply Packed - MP.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */
import java.math.BigInteger;
public class MP extends SS2Instruction
{
	/**
	 * Constructor for objects of class MP
	 */
	public MP(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " MP - Multiply Decimal - SS2\n Object Code:  OPCODE|L1L2|B1D1|D1D1|B2D2|D2D2\n Explicit Format: D1(L1,B1),D2(L2,B2)";
		setDescription(d);				
	}

	/**
	 * execute - emulates execution of an SS2 instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getBaseReg1();
		Register b2 = getBaseReg2();
		Memory memory = getMemory();
		int disp1 = getDisplacement1();
		int disp2 = getDisplacement2();
		int target = b1.getRegValue() + disp1;
		int source = b2.getRegValue() + disp2;
		int len1 = getLength1() + 1;
		int len2 = getLength2() + 1;
		int leadingZeroBytes = 0;
		int t = target;
		while ((leadingZeroBytes < len1) && (memory.getByte(t) == 0))
		{
		   leadingZeroBytes++;
		   t = t + 1;
		}
		if (len2 > leadingZeroBytes)
		   throw new SpecificationException("Specification Exception:  Multiplier length > Number of bytes of leading zeroes in operand one");
		if (len2 > 8)
		   throw new SpecificationException("Multiplier length > 8");
		BigInteger temp1 = PackedDecimal.packedToBigInteger(memory,target,len1);
		BigInteger temp2 = PackedDecimal.packedToBigInteger(memory,source,len2);
		BigInteger result = temp1.multiply(temp2);
		PackedDecimal.BigIntegerToPackedDecimal(memory,target,len1,result);
	}
}


