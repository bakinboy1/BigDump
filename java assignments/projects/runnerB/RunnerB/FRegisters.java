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
 * Write a description of class FFRegisters here.
 * 
 * @author Woolbright 
 * @version October, 2007
 */
public class FRegisters
{
	private static FRegister[] reg;
	private static final int NOFREGS = 16; // 8 slots, 4 used
	private PSW psw;


	/**
	 * Constructor for objects of class FFRegisters
	 */
	public FRegisters(PSW psw)
	{
	    this.psw = psw;
		reg = new FRegister[NOFREGS];
		for (int i=0; i < NOFREGS; i=i+1)
		{
		    reg[i] = new FRegister(i,0,psw);
		}
	}
	public FRegister getFRegister(int i)
	{
	    return reg[i];
	}
	public  void setFRegister(int regNumber, long regValue)
	{
	    reg[regNumber] = new FRegister(regNumber, regValue, psw);
	}
    public  void randomize()
    {
        Random randomGenerator = new Random();
		for (int i=0; i < NOFREGS; i=i+1)
		{
            reg[i].setLongRegValue(randomGenerator.nextLong());
		}  
    }


}
