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
 * Write a description of class Hex here.
 * 
 * @author Woolbright 
 * @version 2011
 */
import java.math.BigInteger;
public class Hex
{
    public static void main(String[] args)
    {
        byte b = -128; //byte value range -128 to 127

 
        for (int i = 0; i < 256; i++)
        {
            String temp = Integer.toHexString(b);
            if (b < 0)
            {
                temp = temp.substring(6);
            }
            if (temp.length() == 1)
            {
                temp = "0" + temp;
            }
            System.out.println(temp);
            b++;
        }
    }
	/**
	 * Constructor for objects of class Hex
	 */
	public Hex()
	{
		// initialise instance variables

	}
    public static String toHex(byte b)
    {
         String temp = Integer.toHexString(b);
         if (b < 0)
         {
             temp = temp.substring(6);
         }
         if (temp.length() == 1)
         {
             temp = "0" + temp;
         }
        return temp;
    }
    public static String toHexDigit(int d)
    {
        assert d < 16;
        String dig = "";
        if (d == 0) dig = "0";
        if (d == 1) dig = "1";
        if (d == 2) dig = "2";
        if (d == 3) dig = "3";
        if (d == 4) dig = "4";
        if (d == 5) dig = "5";
        if (d == 6) dig = "6";
        if (d == 7) dig = "7";
        if (d == 8) dig = "8";
        if (d == 9) dig = "9";
        if (d == 10) dig = "A";
        if (d == 11) dig = "B";
        if (d == 12) dig = "C";
        if (d == 13) dig = "D";
        if (d == 14) dig = "E";
        if (d == 15) dig = "F";        
        return dig;
    }
    public static String toLowerHexDigit(int d)
    {
        assert d < 16;
        String dig = "";
        if (d == 0) dig = "0";
        if (d == 1) dig = "1";
        if (d == 2) dig = "2";
        if (d == 3) dig = "3";
        if (d == 4) dig = "4";
        if (d == 5) dig = "5";
        if (d == 6) dig = "6";
        if (d == 7) dig = "7";
        if (d == 8) dig = "8";
        if (d == 9) dig = "9";
        if (d == 10) dig = "a";
        if (d == 11) dig = "b";
        if (d == 12) dig = "c";
        if (d == 13) dig = "d";
        if (d == 14) dig = "e";
        if (d == 15) dig = "f";        
        return dig;
    }    
    public static int leftDigitAsInt(Byte b)
    {
        
        String hexDigs = Integer.toHexString(b.intValue());
        int pos = 0;
        if (hexDigs.length() > 1)
        {
            pos = hexDigs.length() - 2;
        }
        
        if (hexDigs.length() == 1)
        {
            return 0;
        }
       
        String hexDigit =  hexDigs.substring(pos,pos + 1);                                 
        return Hex.toIntFromHexDigit(hexDigit);
    }
    public static int rightDigitAsInt(Byte b)
    {
        String hexDigs = Integer.toHexString(b.intValue());
        int pos = 0;   //assume 1 digit
        if (hexDigs.length() > 1)
        {
            pos = hexDigs.length() - 1;
        }
        String hexDigit =  hexDigs.substring(pos,pos + 1);                                            
        return Hex.toIntFromHexDigit(hexDigit);
    } 
    public static boolean isRightDigitValidSign(Byte b)
    {
        int temp = rightDigitAsInt(b);
        return (temp >= 10) && (temp <= 16);
    }
    public static int getDisplacement(Byte b1, Byte b2)
    {
        String hexDigs1 = Integer.toHexString(b1.intValue());
        int len = hexDigs1.length();
        String hexDigit1 =  hexDigs1.substring(len -1);  
        int dig1 = Hex.toIntFromHexDigit(hexDigit1);
        
        String hexDigs2 = Integer.toHexString(b2.intValue());
        len = hexDigs2.length();
        int dig2 = 0;
        if (len > 1)
        {
           String hexDigit2 =  hexDigs2.substring(len - 2, len - 1);  
           dig2 = Hex.toIntFromHexDigit(hexDigit2);
        }
        String hexDigit3 =  hexDigs2.substring(len - 1);  
        int dig3 = Hex.toIntFromHexDigit(hexDigit3);
        return (256 * dig1) + (16 * dig2) + dig3;
    }
    public static int getDisplacement20(Byte b1, Byte b2, Byte b3)
    {
        String disp = Hex.toHex(b3) +Hex.toHex(b1).substring(1,2) + Hex.toHex(b2);
        int result = hexToDec20(disp);
        return result;
       // int dl = getDisplacement(b1,b2);
       // Byte dummy = new Byte("0");
       // int dh = getDisplacement(dummy,b3);
       // return (dh * 4096) + dl;
    }

   
    public static Integer hexToDec20(String hex)  {
       Integer num = Integer.valueOf(hex, 16);
       return (num > 524287) ? num - 1048576 : num;
    }
    public static int toIntFromHexDigit(String d)
    {
        int temp = 0;
        if (d.equals("0")) temp = 0;
        if (d.equals("1")) temp = 1;
        if (d.equals("2")) temp = 2;
        if (d.equals("3")) temp = 3;     
        if (d.equals("4")) temp = 4;
        if (d.equals("5")) temp = 5;
        if (d.equals("6")) temp = 6;
        if (d.equals("7")) temp = 7;    
        if (d.equals("8")) temp = 8;
        if (d.equals("9")) temp = 9;
        if (d.equals("a")) temp = 10;
        if (d.equals("b")) temp = 11;     
        if (d.equals("c")) temp = 12;
        if (d.equals("d")) temp = 13;
        if (d.equals("e")) temp = 14;
        if (d.equals("f")) temp = 15; 
        return temp;
    } 
    public static int toIntFromHexString2(String d)
    {
        int val = Integer.parseInt(d,16);
        if (val > 127)
        {
            val = - ( 256 - val);
        }
        return val;
    }
    
    public static int toUnsignedIntFromHexString2(String d)
    {
        int val = Integer.parseInt(d,16);
        return val;
    }
}
