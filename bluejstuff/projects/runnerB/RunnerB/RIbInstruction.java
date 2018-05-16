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
 * RIb Instruction format class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RIbInstruction extends Instruction
{
    private Register r1Reg;
    private int r1No;
    private int ri2;  //no of halfwords added to the address of instruction
    
	/**
	 * Constructor for objects of class RIbInstruction
	 */
	public RIbInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(4);     
		r1No = Hex.leftDigitAsInt(getCodeI(1));
		r1Reg =  registers.getRegister(r1No);
		ri2 = myMemory.toIntFromTwoBytes(getCodeI(2),getCodeI(3));
//         myMemory.setHighlighting(1, //first byte of instruction
//                                  4, //last byte of instruction
//                                  -1, //address of source
//                                  getTargetHighlighting(), //address of target
//                                  r1No,     //operand 1 register
//                                  r1No, //operand 2 register
//                                  -1, //operand 2 index register
//                                  -1,  // No base register highlighted
//                                  -1); //base reg 2	
				
    }

	public int getRI2()
	{
	    return ri2;
	}
	public int getR1No()
	{
	    return r1No;
	}
	public Register getReg1()
	{
	    return r1Reg;
	}
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
