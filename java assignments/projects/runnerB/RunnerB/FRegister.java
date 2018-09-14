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
 * The Register class simulates the actions of an IBM 360 register.
 * 
 * @author Woolbright
 * @version October, 2007
 */
public class FRegister
{
    // instance variables - replace the example below with your own
    private int regValue;        //bits 32-63 //the low-order register contents
    private int hRegValue;       //bits 0-31//the high-order register contents    //the long register contents
    private int regNumber;        //the number of the register (0-15)
    private PSW psw;

    /**
     * Constructor for objects of class FRegister
     */

    public FRegister(int regNumber, int regValue, PSW psw)
    {
        this.regNumber = regNumber;
        this.regValue = regValue;
        this.hRegValue = 0;
        this.psw = psw;
    }
    public FRegister(int regNumber, long longRegValue, PSW psw)
    {
        this.regNumber = regNumber;
        long temp = longRegValue;
        this.regValue =  (int) ((temp << 32) >> 32);
        temp = longRegValue;
        this.hRegValue = (int)(temp >> 32);
        this.psw = psw;
    }
    public int getRegNumber()
    {
        return regNumber;
    }
    public void setRegNumber(int regNumber)
    {
        this.regNumber = regNumber;
    }    
    public int getRegValue()
    {
        return regValue;
    }
    public int getHRegValue()
    {
        return hRegValue;
    }
    public long getLongRegValue()
    {
        long temp1 = hRegValue;
        temp1 = temp1 << 32;
        long temp2 = (long) regValue;
        temp2 = (temp2 << 32) >>> 32;
        return  temp1 | temp2;
    }   
    public void setRegValue(int regValue)
    {
        this.regValue = regValue;
    }
    public void setHRegValue(int hRegValue)
    {
        this.hRegValue = hRegValue;
    }
    public void setLongRegValue(int intRegValue)
    {
        hRegValue = 0;
        regValue = intRegValue;
    }
    public void setLongRegValue(long longRegValue)
    {
        hRegValue = (int) (longRegValue >> 32);
        regValue = (int) ((longRegValue << 32) >> 32);
    }
    public String toString()                 //reg to string
    {
        return  "" + new Integer(regValue).toString();
    }
    public String hRegtoString()                 //low reg to string
    {
        return  "" + new Integer(hRegValue).toString();
    }
    
    public String toHexString()             //low reg to hex string
    {
        String temp = Integer.toHexString(regValue);
        while(temp.length() < 8)
        {
            temp = "0" + temp;
        }
        return temp;
    }
    public String hRegToHexString()       //high reg to 
    {
        String temp = Integer.toHexString(hRegValue);
        while(temp.length() < 8)
        {
            temp = "0" + temp;
        }
        return temp;
    }    
    public String toHexString16()    ////
    {
        String temp = Integer.toHexString(regValue);
        while(temp.length() < 16)
        {
            temp = "0" + temp;
        }
        temp = "" + temp;
        return temp;
    }
    public String hRegtoHexString16()    ////
    {
        String temp = Integer.toHexString(hRegValue);
        while(temp.length() < 16)
        {
            temp = "0" + temp;
        }
        temp = "" + temp;
        return temp;
    }
    
    public String longRegToHexString()
    {
        return hRegToHexString() + toHexString();
    }

    public void add(int val)   //change low 32 bits only - no change in upper 32 bits
    {
        regValue += val;
        
    }  
    public void hAdd(int val)   //change uppper 32 bits only - no change in lower 32 bits
    {
        hRegValue += val;
        
    }
    public void longAdd(int val)  //change all 64 bits
    {
        long temp1 = (((long) hRegValue) << 32);
        long temp2 = (((long) regValue) << 32) >> 32;       
        long temp = (temp1 | temp2) + (long) val;
        this.regValue =  (int) ((temp << 32) >> 32);
        this.hRegValue = (int)(temp >> 32);        
        
    }    
    public void longAdd(long val)  //change all 64 bits
    {
        long temp1 = (((long) hRegValue) << 32);
        long temp2 = (((long) regValue) << 32) >> 32;       
        long temp = (temp1 | temp2) + val;
        this.regValue =  (int) ((temp << 32) >> 32);
        this.hRegValue = (int)(temp >> 32);        
    }        
    public void add(FRegister r)  // change low 32 bits - upper 32 bits unchanged
    {
        regValue += r.regValue;
    }
    public void addLong(FRegister r)  // change low 32 bits - upper 32 bits unchanged
    {
        long temp1 = r.getLongRegValue();
        long temp2 = this.getLongRegValue();
        temp1 += temp2;
        this.setLongRegValue(temp1);
        
        
    }
    public void subtractLong(FRegister r)  // change low 32 bits - upper 32 bits unchanged
    {
        long temp2 = r.getLongRegValue();
        long temp1 = this.getLongRegValue();
        temp1 -= temp2;
        this.setLongRegValue(temp1);
        
        
    }    
    public void addLong(long val)  // change low 32 bits - upper 32 bits unchanged
    {
//         long temp1 =(((long) hRegValue) << 32) + regValue;
//         long temp2 =
//         temp1 += temp2;
//         
        
    }    
    public void subtract(FRegister r)  //change low 32 bits - upper 32 bits unchanged
    {
        regValue -= r.regValue;
    }   
//     public void longSubtract(FRegister r)  //change all 64 bits
//     {
//         longRegValue -= r.longRegValue;
//         long temp = longRegValue;
//         this.regValue =  (int) ((temp << 32) >> 32);
//         temp = longRegValue;
//         this.hRegValue = (int)(temp >> 32);         
//     }       
    public void subtract(int val)
    {
        regValue -= val;
    }
//         public void hSubtract(int val)   //change uppper 32 bits only - no change in lower 32 bits
//     {
//         hRegValue -= val;
//         
//     }
//     public void longSubtract(int val)  //change all 64 bits
//     {
//         longRegValue -= val;
//         long temp = longRegValue;
//         this.regValue =  (int) ((temp << 32) >> 32);
//         temp = longRegValue;
//         this.hRegValue = (int)(temp >> 32);        
//         
//     }    
//     public void longSubtract(long val)  //change all 64 bits
//     {
//         longRegValue -= val;
//         long temp = longRegValue;
//         this.regValue =  (int) ((temp << 32) >> 32);
//         temp = longRegValue;
//         this.hRegValue = (int)(temp >> 32);        
//     }            
    /*
     * returns a return code to indicate the results of the compare
     */
    public int compare(FRegister r)
    {
        int returnCode = 0;
        if (regValue < r.regValue)
        {
            returnCode = 1; //low
        }
        if (regValue > r.regValue)
        {
            returnCode = 2; //high
        }
        if (regValue == r.regValue)
        {
            returnCode = 0;
        }
        return returnCode;
    }
    public String getByteAsString(int i)
    {
        String temp = toHexString();
        return temp.substring(2*i,2*i+2);
    }
    public String getHRegByteAsString(int i)
    {
        String temp = hRegToHexString();
        return temp.substring(2*i,2*i+2);
    }
    public String getGRegByteAsString(int i)
    {
        String temp1 = toHexString();
        String temp2 = hRegToHexString();
        String temp3 = temp2 + temp1;
        return temp3.substring(2*i,2*i+2);
    }    
    public boolean equals(Object obj)
    {
        if (obj == null) return false;
        if (getClass() != obj.getClass()) return false;
        FRegister objFRegister = (FRegister) obj;
        return ((regValue == objFRegister.regValue) && (regNumber == objFRegister.regNumber));
    }
    public int getBit(int n)
    {
      int b = regValue; // Don't change the register
      int x = 0;
      if (b >= 0)
      {
         for(int i = 32 - n; i > 0; i--)
         {
            x = b % 2;
            b = b / 2;
         }
      }
      else
      {
          b = - b;  //compute...
          b = b - 1;  //...one's complement
         for(int i = 32 - n; i > 0; i--)
         {
            x = b % 2;
            b = b / 2;
         }
         if ( x == 1) 
           x = 0;
         else
           x = 1;
      }
      return x;
    }
    public void addLogical(FRegister r)
    {
        int[] x = new int[32];
        int[] y = new int[32];
        for(int i=0;i < 32;i++)
        {
            x[i] = getBit(i);
            y[i] = r.getBit(i);
        }
        int carry = 0;
        for(int i=31; i>=0;i--)
        {
            int sum = x[i] + y[i] + carry;
            switch(sum){
                case 0: x[i] = 0;
                        carry = 0;
                        break;
                case 1: x[i] = 1;
                        carry = 0;
                        break;
                case 2: x[i] = 0;
                        carry = 1;
                        break;
                case 3: x[i] = 1;
                        carry = 1;
            }
        }
        //convert array x[] to int
        int val = 0;
        int power2 = 1;
        for(int i=31; i>=0; i--)
        {
            if(x[i] == 1)
            {
                val = val + power2;
            }
            power2 = power2 * 2;
        }
        regValue = val;
        if (regValue == 0 && carry == 0) 
        {
            psw.setConditionCode(0);
        }
        if(regValue == 0 && carry == 1)
        {
            psw.setConditionCode(2);
        }
        if(regValue != 0 && carry == 0)
        {
            psw.setConditionCode(1);
        }
        if(regValue != 0 && carry == 1)
        {
            psw.setConditionCode(3);
        }
    }
    public void subtractLogical(FRegister r)
    {
        //needs to be tested!
        int[] x = new int[32];
        int[] y = new int[32];
        for(int i=0;i < 32;i++)
        {
            x[i] = getBit(i);
            y[i] = r.getBit(i) == 0 ? 1 : 0;    //flip the bits to compute the 1's complement
        }
        int carry = 1;                         //start with a 1 carry to compensate
        for(int i=31; i>=0;i--)
        {
            int sum = x[i] + y[i] + carry;
            switch(sum){
                case 0: x[i] = 0;
                        carry = 0;
                        break;
                case 1: x[i] = 1;
                        carry = 0;
                        break;
                case 2: x[i] = 0;
                        carry = 1;
                        break;
                case 3: x[i] = 1;
                        carry = 1;
            }
        }
        //convert array x[] to int
        int val = 0;
        int power2 = 1;
        for(int i=31; i>=0; i--)
        {
            if(x[i] == 1)
            {
                val = val + power2;
            }
            power2 = power2 * 2;
        }
        regValue = val;
        if (regValue == 0 && carry == 1) 
        {
            psw.setConditionCode(2);
        }
        if(regValue != 0 && carry == 0)
        {
            psw.setConditionCode(1);
        }
        if(regValue != 0 && carry == 1)
        {
            psw.setConditionCode(3);
        }
    }        
}
