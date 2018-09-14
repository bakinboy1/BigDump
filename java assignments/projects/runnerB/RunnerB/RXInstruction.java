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
 * Edit - ED.
 * 
 * @author Woolbright 
 * @version 2007,2012
 */

/**
 * RXInstruction Format.
 * 
 * @author Woolbright
 * @version 2007
 */
public class RXInstruction extends Instruction
{
    private Register reg1;
    private Register baseReg2;
    private Register indexReg2;
    private int displacement;
    private int effectiveAddress;
    private int mask;

    /**
     * Constructor for objects of class SS1Instruction
     */
    public RXInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
    {
        super(addr,myMemory,psw,registers);
        setInstructionLength(4);     //all RX instructions are 4 bytes long

        int r1   = Hex.leftDigitAsInt(getCodeI(1));
        mask = r1;   //these bits sometimes represent a mask
        reg1 = getRegisters().getRegister(r1);
        
        int i2   = Hex.rightDigitAsInt(getCodeI(1));
        indexReg2 = getRegisters().getRegister(i2);
        
        int r2 = Hex.leftDigitAsInt(getCodeI(2));
        baseReg2 = getRegisters().getRegister(r2);
    
        displacement = Hex.getDisplacement(getCodeI(2),getCodeI(3));
        effectiveAddress = displacement;  //start with displacement
        if (i2 != 0)
        {
            effectiveAddress += indexReg2.getRegValue();
        }
        if (r2 != 0)
        {
            effectiveAddress += baseReg2.getRegValue();
        }
        setSourceHighlighting(-1);  // can't determine source or target here  
        setTargetHighlighting(-1);  
        myMemory.setHighlighting(1, //first byte of instruction
                                 4, //last byte of instruction
                                 getSourceHighlighting(), //address of source
                                 getTargetHighlighting(), //address of target
                                 reg1.getRegNumber(),     //operand 1 register
                                 baseReg2.getRegNumber(), //operand 2 register
                                 indexReg2.getRegNumber(), //operand 2 index register
                                 -1,  // No base register highlighted
                                 baseReg2.getRegNumber()); //base reg 2
    }
    public Register getReg1()
    {
        return reg1;
    }
    public Register getBaseReg2()
    {
        return baseReg2;
    }   
    public Register getIndexReg2()
    {
        return indexReg2;
    }
    public int getDisplacement()
    {
        return displacement;
    }   
    public int getMask()
    {
        return mask;
    }
    public void execute()
    {
        System.out.println("I'm executing");
    }
    public int getEffectiveAddress()
    {
        return effectiveAddress;
    }
}
