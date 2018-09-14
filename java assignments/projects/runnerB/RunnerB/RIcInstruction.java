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
 * RIc Instruction format class.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RIcInstruction extends Instruction
{
    private int mask;
    private int ri2;  //no of halfwords added to the address of instruction
    
	/**
	 * Constructor for objects of class RIcInstruction
	 */
	public RIcInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(4);     //all SS1 instructions are 6 bytes long
		//length = getCodeI(1).intValue();   //length is in the 2nd byte
		mask = Hex.leftDigitAsInt(getCodeI(1));
		ri2 = myMemory.toIntFromTwoBytes(getCodeI(2),getCodeI(3));
        myMemory.setHighlighting(1, 4, -1, getTargetHighlighting(), -1,-1,-1,-1,-1);				
				
    }

	public int getRI2()
	{
	    return ri2;
	}
	public int getMask()
	{
	    return mask;
	}
	public void execute()
	{
	    System.out.println("I'm executing");
	}
}
