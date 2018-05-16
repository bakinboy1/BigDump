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

/**
 * The PSW class contains information about the current state of the machine.
 * 
 * @author Woolbright
 * @version  October, 2007
 */
public class PSW
{
    // instance variables - replace the example below with your own
    private int address;
    private int conditionCode;
    private int addressingMode;
    private int mask;
    public static final int EQUAL = 0;
    public static final int LOW = 1;
    public static final int HIGH = 2;
    public static final int OVERFLOW = 3;

    /**
     * Constructor for objects of class PSW
     */
    public PSW(int IPLaddr)
    {
        // initialise instance variables
        address = IPLaddr;
        conditionCode = 0;
        addressingMode = 1;   // 31 bit addressing by default
    }

    public  int fetchInstructionAddress()
    {
        return address;
    }
    public  void setInstructionAddress(int address)
    {
        this.address = address;
    }
    public void updatePSWAddress(int len)
    {
        address += len;
    }
    public int fetchConditionCode()
    {
        return conditionCode;
    }
    public void setConditionCode(int conditionCode)
    {
        this.conditionCode = conditionCode;
    }
    public int getAddressingMode()
    {
        return addressingMode;
    }
    public void setAddressingMode(int m)
    {
        if((m >=0) && (m <= 3))
        {
           addressingMode = m;
        }
        else
        {
            System.err.println("Bad addressing mode value:  " + m);
        }
    }
    public int getMask()
    {
        return mask;
    }
    public void setMask(int m)
    {
        mask = m;
    }
    public String toCodeWord(int n)
    {
        switch(n){
            case 0:  return " - Equal/Zero";
            case 1:  return " - Low/Minus";
            case 2:  return " - High/Plus";
            case 3:  return " - Overflow";
            default: return " - Bad code";
        }
    }
    public String toString()
    {
        String temp;
        String hexaddress = Integer.toHexString(address);
        while(hexaddress.length() < 8)
           hexaddress = "0" + hexaddress;

        temp =  "  PSW Address: " + hexaddress +  '\n';
        temp += "  Condition Code:  " + conditionCode + toCodeWord(conditionCode) + '\n';
        switch (addressingMode)
        {
            case 0  : temp += "  Addressing Mode: "  + "  24 bits";
                      break;
            case 1  : temp += "  Addressing Mode: "  + "  31 bits";
                      break;         
            default : temp += "  Addressing Mode: "  + "  64 bits";    
        }
        return temp;
    }
}
