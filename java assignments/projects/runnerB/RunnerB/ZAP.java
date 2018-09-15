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
 * Zero and Add Packed - ZAP.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */
import java.math.BigInteger;
public class ZAP extends SS2Instruction
{
	/**
	 * Constructor for objects of class ZAP
	 */
	public ZAP(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " ZAP - Zero and Add Decimal - SS2\n Object Code:  OPCODE|L1L2|B1D1|D1D1|B2D2|D2D2\n Explicit Format: D1(L1,B1),D2(L2,B2)";
		setDescription(d);			
	}

	/**
	 * execute - emulates execution of an SS2 ZAP instruction
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
		BigInteger result = PackedDecimal.packedToBigInteger(memory,source,len2);
		long r1 = result.longValue();
		PackedDecimal.BigIntegerToPackedDecimal(memory,target,len1,result);
		PSW psw = getPSW();
		if (result.compareTo(BigInteger.ZERO) == 0)
		{
		    psw.setConditionCode(EQUAL);
		}
		if (result.compareTo(BigInteger.ZERO) < 0)
		{
		    psw.setConditionCode(LOW);
		}
		if (result.compareTo(BigInteger.ZERO) > 0)
		{
		    psw.setConditionCode(HIGH);
		}
		if (PackedDecimal.overFlow(result,len1))
		{
		    psw.setConditionCode(OVERFLOW);
		}
	}
}