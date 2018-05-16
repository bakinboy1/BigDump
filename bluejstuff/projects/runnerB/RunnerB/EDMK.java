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
 * Edit and Mark - EDMK.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */

public class EDMK extends SS1Instruction
{
	/**
	 * Constructor for objects of class EDMK
	 */
	public EDMK(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " EDMK - Edit and Mark - SS1\n Object Code:  OPCODE|LL1|B1D1|D1D1|B2D2|D2D2\n Explicit Format: D1(L,B1),D2(B2)";
		setDescription(d);		
	}

	/**
	 * execute - emulates execution of an EDMK instruction
	 * 
// 	 */
// 	 ______________________________________________________ __________________________ 
//    |                                                      |        Results           |
//    |                      Conditions                      |_____________ ____________|
//    |____________________ ____________ ______ _____________|             |State of    |
//    |                    |Previous    |      |             |             |Significance|
//    |                    |State of    |      |Right Four   |             |Indicator at|
//    |                    |Significance|Source|Source Bits  |             |End of Digit|
//    |   Pattern Byte     |Indicator   |Digit |Are Plus Code| Result Byte |Examination |
//    |____________________|____________|______|_____________|_____________|____________|
//    |Digit selector      |     Off    | 0    |      *      |Fill byte    |    Off     |
//    |                    |            | 1-9  |      No     |Source digit#|    On      |
//    |                    |            | 1-9  |      Yes    |Source digit#|    Off     |
//    |                    |     On     | 0-9  |      No     |Source digit |    On      |
//    |                    |            | 0-9  |      Yes    |Source digit |    Off     |
//    |                    |            |      |             |             |            |
//    |Significance starter|     Off    | 0    |      No     |Fill byte    |    On      |
//    |                    |            | 0    |      Yes    |Fill byte    |    Off     |
//    |                    |            | 1-9  |      No     |Source digit#|    On      |
//    |                    |            | 1-9  |      Yes    |Source digit#|    Off     |
//    |                    |     On     | 0-9  |      No     |Source digit |    On      |
//    |                    |            | 0-9  |      Yes    |Source digit |    Off     |
//    |                    |            |      |             |             |            |
//    |Field separator     |     *      | **   |      **     |Fill byte    |    Off     |
//    |                    |            |      |             |             |            |
//    |Message byte        |     Off    | **   |      **     |Fill byte    |    Off     |
//    |                    |     On     | **   |      **     |Message byte |    On      |
//    |____________________|____________|______|_____________|_____________|____________|
//    |Explanation:                                                                     |
//    |                                                                                 |
//    |   *  No effect on result byte or on new state of significance indicator.        |
//    |   ** Not applicable because source is not examined.                             |
//    |   #  For EDIT AND MARK only, the address of the rightmost such result byte is   |
//    |      placed in general register 1.                                              |
//    |_________________________________________________________________________________|


	public void execute()
	{
       //Caveat Emptor - This code is preliminary - I'm sure it needs revision
       // EDMK is difficult to emulate!  It's working for basic single field edits,
       // but needs work for multiple field edits.
       // Condition codes are not currently being set.
		Register b1 = getBaseReg1();
		Register b2 = getBaseReg2();
		int disp1 = getDisplacement1();
		int disp2 = getDisplacement2();
		int target = b1.getRegValue() + disp1;
		int source = b2.getRegValue() + disp2;
		int len = getLength();
		len++;  //object code length is one less than actual
		Memory memory = getMemory();
		Registers regs = getRegisters();
		Register r1 = regs.getRegister(1);
		boolean SIGSTARTED = false;
		boolean VALIDSIGN = false;
		boolean ONETONINE = false;
		boolean ZEROTONINE = false;
		boolean ZERO = false;
		boolean USEFIRSTDIGIT = true;
		boolean POSITIVESIGN = false;
		boolean NEGATIVESIGN = false;
		boolean SIGNFOUND = false;
		boolean ADVANCE = true;
		Byte fillByte = memory.getByte(target);
        target++;
        len--;
		final Byte TWENTY = new Byte("32"); //Hex 20
		final Byte TWENTYONE = new Byte("33"); //Hex 21
		final Byte TWENTYTWO = new Byte("34"); //Hex 22
		int lDigit = 0;
		int rDigit = 0;
		while (len > 0)
		{
		    Byte patternByte = memory.getByte(target);
		    Byte bs = memory.getByte(source);
		    lDigit = memory.getZone(source);
		    rDigit = memory.getNumeric(source);
		    if (rDigit > 9)
		    {
		       switch (rDigit) {
		           case 10:
		           case 12:
		           case 14:
		           case 15:  POSITIVESIGN = true;
		                     SIGNFOUND = true;
		                     break;
		           case 11:
		           case 13:  NEGATIVESIGN = true;
		                     SIGNFOUND = true;
		                     break;
                   default:  
                       System.err.println("A data exception occurred");
		        }
		   }
		   if ((rDigit < 0))
		   {
		         //throw a data exception  
		         System.err.println("A data exception occurred");
		   }
		   
		   if ((lDigit < 0) || (lDigit > 9))
		   {
		         //throw a data exception  
		         System.err.println("A data exception occurred");
		   }

		   while(! (patternByte.equals(TWENTY) || patternByte.equals(TWENTYONE)))
		   {
		           if (SIGSTARTED)
		           {
		               target++;
		               len--;
		               patternByte = memory.getByte(target);
		           }
		           else
		           {
		              memory.setByte(target,fillByte);
		              target++;
		              len--;
		              patternByte = memory.getByte(target);
		           }
		   }		
		   if (patternByte.equals(TWENTY) && !SIGSTARTED && (lDigit == 0))
		   {
		       memory.setByte(target,fillByte);
		   }
		   else if (patternByte.equals(TWENTY) && !SIGSTARTED && (lDigit != 0))
		   {
		       memory.setByte(target,new Byte((byte) (240 + lDigit)));
		       SIGSTARTED = true;
		       r1.setRegValue(target);
		       
		   }
		   else if (patternByte.equals(TWENTY) && SIGSTARTED)
		   {
		       memory.setByte(target,new Byte((byte) (240 + lDigit)));
		   }
		   else if (patternByte.equals(TWENTYONE) && !SIGSTARTED && (lDigit == 0))
		   {
		       memory.setByte(target,fillByte);
		       SIGSTARTED = true;
		       r1.setRegValue(target + 1);
		   }
		   else if (patternByte.equals(TWENTYONE) && !SIGSTARTED && (lDigit != 0))
		   {
		       memory.setByte(target,new Byte((byte) (240 + lDigit)));
		       SIGSTARTED = true;
		       r1.setRegValue(target);		       
		   }
		   else if (patternByte.equals(TWENTYONE) && SIGSTARTED)
		   {
		       memory.setByte(target,new Byte((byte) (240 + lDigit)));
		   }		    

		    
		    target++;     //moving to next digit in source - target, too!
		    len--;
		    patternByte = memory.getByte(target);
		    
		    if (! SIGNFOUND)
		    {
		       while(! (patternByte.equals(TWENTY) || patternByte.equals(TWENTYONE)))
		       {
		           if (SIGSTARTED)
		           {
		               target++;
		               len--;
		               patternByte = memory.getByte(target);
		           }
		           else
		           {
		              memory.setByte(target,fillByte);
		              target++;
		              len--;
		              patternByte = memory.getByte(target);
		           }
		       }		
		       if (patternByte.equals(TWENTY) && !SIGSTARTED && (rDigit == 0))
		       {
		           memory.setByte(target,fillByte);
		       }
		       else if (patternByte.equals(TWENTY) && !SIGSTARTED && (rDigit != 0))
		       {
		           memory.setByte(target,new Byte((byte) (240 + rDigit)));
		           SIGSTARTED = true;
		           r1.setRegValue(target);		           
		       }
		       else if (patternByte.equals(TWENTY) && SIGSTARTED)
		       {
		           memory.setByte(target,new Byte((byte) (240 + rDigit)));
		       }
		       else if (patternByte.equals(TWENTYONE) && !SIGSTARTED && (rDigit == 0))
		       {
		           memory.setByte(target,fillByte);
		           SIGSTARTED = true;
		           r1.setRegValue(target + 1);
		       }
		      else if (patternByte.equals(TWENTYONE) && !SIGSTARTED && (rDigit != 0))
		       {
		           memory.setByte(target,new Byte((byte) (240 + rDigit)));
		           SIGSTARTED = true;
		           r1.setRegValue(target);  
		       }
		       else if (patternByte.equals(TWENTYONE) && SIGSTARTED)
		       {
		           memory.setByte(target,new Byte((byte) (240 + rDigit)));
		       }		    
	
		    }
		    else //digit was the sign
		    {
		        while (len > 0)
		        {
		            if (POSITIVESIGN)
		            {
		               memory.setByte(target,fillByte);
		            }
		            target++;
		            len = len - 1;
		        }
		    }
		    

		    target++;
		    source++;
		    
		    len--;
		}
	}

}
