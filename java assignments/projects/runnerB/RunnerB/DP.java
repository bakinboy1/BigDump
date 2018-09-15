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
 * Divide Packed - DP.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */
import java.math.BigInteger;
public class DP extends SS2Instruction
{
	/**
	 * Constructor for objects of class DP
	 */
	public DP(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " DP - Divide Decimal - SS2\n Object Code:  OPCODE|L1L2|B1D1|D1D1|B2D2|D2D2\n Explicit Format: D1(L1,B1),D2(L2,B2)";
		setDescription(d);				
	}

	/**
	 * execute - emulates execution of a DP instruction
	 * 
	 */
	public void execute() throws DecimalDivideException
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
		if (len2 >= len1)
		   throw new SpecificationException("Divisor length >= dividend length");
		if (len2 > 8)
		   throw new SpecificationException("Divisor length > 8");
		int remTarget = target + (len1 - len2);
		for (int i = target; i < target+len2; i++)
		{
		    String t = memory.getByteAsString(i);
		    if ( ! memory.getByteAsString(i).equals("00"))
		         throw new DecimalDivideException("Not enough leading 0's in dividend");
		} 
		BigInteger temp1 = PackedDecimal.packedToBigInteger(memory,target,len1);
		BigInteger temp2 = PackedDecimal.packedToBigInteger(memory,source,len2);
		if (temp2.compareTo(BigInteger.ZERO) == 0)
		   throw new DecimalDivideException("Can't divide by 0");
		BigInteger[] res = temp1.divideAndRemainder(temp2);   
		BigInteger quotResult = res[0];
		BigInteger remResult = res[1];
		PackedDecimal.BigIntegerToPackedDecimal(memory,remTarget,len2,remResult);
		PackedDecimal.BigIntegerToPackedDecimal(memory,target,len1-len2,quotResult);
	}
}