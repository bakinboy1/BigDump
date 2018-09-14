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
 * Move with Offset - MVO.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */

public class MVO extends SS2Instruction
{
	/**
	 * Constructor for objects of class MVO
	 */
	public MVO(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " MVO - Move with Offset - SS2\n Object Code:  OPCODE|L1L2|B1D1|D1D1|B2D2|D2D2\n Explicit Format: D1(L1,B1),D2(L2,B2)";
		setDescription(d);				
	}

	/**
	 * execute - emulates execution of an MVO instruction
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
		int ptrS = source + len2 - 1;
		int ptrT = target + len1 - 1;

		int rInt = memory.getNumeric(ptrS);
		int lInt = memory.getZone(ptrS);
	    memory.setZone(ptrT,rInt);
	    ptrT = ptrT - 1;
	    ptrS = ptrS - 1;
	    while ((ptrS >= source - 1)&&(ptrT >= target))
	    {
	       memory.setNumeric(ptrT,lInt);
	       rInt = memory.getNumeric(ptrS);
	       lInt = memory.getZone(ptrS);
           memory.setZone(ptrT,rInt);
           ptrT = ptrT - 1;
           ptrS = ptrS - 1;
	   }
	   if (len1 > len2)  
	   {
	      memory.setZone(ptrT + 1,0);  //fix the last zone
	   }
	   while (ptrT >= target)  //... and fill in the rest with 0's
	   {
	      memory.setZone(ptrT,0);
	      memory.setNumeric(ptrT,0);
	      ptrT = ptrT - 1;
	   }
	}
}
