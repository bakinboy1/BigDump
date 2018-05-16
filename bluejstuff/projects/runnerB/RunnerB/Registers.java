// Copyright (c) 2012, David E. Woolbright
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

import java.util.Random;
/**
 * Write a description of class Registers here.
 * 
 * @author Woolbright 
 * @version October, 2007
 */
public class Registers
{
	private static Register[] reg;
	private static final int NOREGS = 16;
	private PSW psw;


	/**
	 * Constructor for objects of class Registers
	 */
	public Registers(PSW psw)
	{
	    this.psw = psw;
		reg = new Register[NOREGS];
		for (int i = 0; i < NOREGS; i++)
		{
		    reg[i] = new Register(i,0,psw);
		}
	}
	public Register getRegister(int i)
	{
	    return reg[i];
	}
	public  void setRegister(int regNumber, int regValue)
	{
	    reg[regNumber] = new Register(regNumber, regValue, psw);
	    //reg[regNumber].setLongRegValue(regValue);
	}
    public  void randomize()
    {
        Random randomGenerator = new Random();
		for (int i = 2; i < NOREGS - 3; i++)  //Leave the linkage regs untouche
		{
            reg[i].setLongRegValue(randomGenerator.nextLong());
		}  
    }
}
