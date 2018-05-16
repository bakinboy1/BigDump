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
import java.math.*;
/**
 * The PackedDecimal class contains methods for working with packed-decimal data.
 * 
 * @author Woolbright
 * @version 2012
 */
public class PackedDecimal 
{
   public static BigInteger packedToBigInteger(Memory m, int address, int noBytes)throws NumberFormatException
   {
       BigInteger retValue = new BigInteger("0");
       int lDigit;
       int rDigit;
       Byte nextByte = m.getByte(address);
       for(int i = 0; i < noBytes - 1; i++)
       {
           lDigit = Hex.leftDigitAsInt(nextByte);
           rDigit = Hex.rightDigitAsInt(nextByte);
           if (! ((lDigit >= 0) && (lDigit <= 9))) throw new NumberFormatException("Data not packed");
           if (! ((rDigit >= 0) && (rDigit <= 9))) throw new NumberFormatException("Data not packed");           
           Integer nexttwo =  (10 * Hex.leftDigitAsInt(nextByte)) + Hex.rightDigitAsInt(nextByte);
           BigInteger nt = new BigInteger(nexttwo.toString());
           BigInteger hundred = new BigInteger("100");
           retValue = retValue.multiply(hundred);
           retValue = retValue.add(nt);
           address = address + 1;
           nextByte = m.getByte(address);
       }
       lDigit = Hex.leftDigitAsInt(nextByte);
       if (! (lDigit >= 0) && (lDigit <= 9))
       {
          throw new NumberFormatException("Data not packed");
       }
       retValue = retValue.multiply(BigInteger.TEN);
       Integer ld = new Integer(lDigit);
       BigInteger BIld = new BigInteger(ld.toString());
       retValue = retValue.add(BIld);
       if (! Hex.isRightDigitValidSign(nextByte))
       {
          throw new NumberFormatException("Sign is not valid");
       }
       switch (Hex.rightDigitAsInt(nextByte))
       {
           case 11:
           case 13: retValue = retValue.negate();
       }
       return retValue;
   }
   
   public static void BigIntegerToPackedDecimal(Memory m, int address, int noBytes, BigInteger value)
   {
       byte result = 0;
       if (BigInteger.ZERO.compareTo(value) > 0)
       {
           value =  value.negate();
           int d = value.mod(BigInteger.TEN).intValue();
           switch (d)
           {
               case 0:  result = 13;
                        break;
               case 1:  result = 29;
                        break;
               case 2:  result = 45;
                        break;
               case 3:  result = 61;
                        break;
               case 4:  result = 77;
                        break;
               case 5:  result = 93;
                        break;
               case 6:  result = 109;
                        break;
               case 7:  result = 125;
                        break;
               case 8:  result = -115;
                        break;
               case 9:  result = -99;
           }   

       }
       else
       {
           int d = value.mod(BigInteger.TEN).intValue();
           switch (d)
           {
               case 0:  result = 12;  //0c
                        break;
               case 1:  result = 28;  //1c
                        break;
               case 2:  result = 44;  //2c
                        break;
               case 3:  result = 60;  //3c
                        break;
               case 4:  result = 76;  //4c
                        break;
               case 5:  result = 92;  //5c
                        break;
               case 6:  result = 108;  //6c
                        break;
               case 7:  result = 124;  //7c
                        break;
               case 8:  result = -116; //8c
                        break;
               case 9:  result = -100;  //9c  
           }
       }
       value = value.divide(BigInteger.TEN);
       address = address + noBytes - 1;
       m.setByte(address, new Byte(result)); //rightmost byte is correct
       address = address - 1;   // working right to left
       for(int i = 0; i < noBytes -1; i++) 
       {
           int digit = (value.mod(BigInteger.TEN)).intValue();
           result = (byte) digit;
           value = value.divide(BigInteger.TEN);
           digit = (value.mod(BigInteger.TEN)).intValue() * 16;
           //digit = ((int) (value % 10)) * 16;
           result = (byte) (digit + result);
           value = value.divide(BigInteger.TEN);
           m.setByte(address, new Byte(result));
           address = address - 1;
        }     
   }   
   public static boolean overFlow(BigInteger answer, int length)      //Did the answer overflow the length?
   {
       int noDigits = (2 * length) - 1;
       BigInteger [] limit = new BigInteger[32];
       String t = "1";
       for (int i = 0; i <= 31; i++)
       {
           limit[i] = new BigInteger(t);
           t = t + "0";
        }
       if (answer.compareTo(limit[noDigits]) >= 0) return true;
       if (answer.compareTo(limit[noDigits].negate())  <= 0) return true;
       return false;
   }
      public static int packedToInt(Memory m, int address, int noBytes)throws NumberFormatException
   {
       int retValue = 0;
       int lDigit;
       int rDigit;
       Byte nextByte = m.getByte(address);
       for(int i = 0; i < noBytes - 1; i++)
       {
           lDigit = Hex.leftDigitAsInt(nextByte);
           rDigit = Hex.rightDigitAsInt(nextByte);
           if (! ((lDigit >= 0) && (lDigit <= 9))) throw new NumberFormatException("Data not packed");
           if (! ((rDigit >= 0) && (rDigit <= 9))) throw new NumberFormatException("Data not packed");           
           retValue = (100 * retValue) + (10 * Hex.leftDigitAsInt(nextByte)) + Hex.rightDigitAsInt(nextByte);
           address = address + 1;
           nextByte = m.getByte(address);
       }
       lDigit = Hex.leftDigitAsInt(nextByte);
       if (! ((lDigit >= 0) && (lDigit <= 9)))
       {
          throw new NumberFormatException("Data not packed");
       }
       retValue = (10 * retValue) + lDigit;
       if (! Hex.isRightDigitValidSign(nextByte))
       {
          throw new NumberFormatException("Sign is not valid");
       }
       switch (Hex.rightDigitAsInt(nextByte))
       {
           case 11:
           case 13: retValue = -1 * retValue;
       }
       return retValue;
   }
   
   public static void intToPackedDecimal(Memory m, int address, int noBytes, int value)
   {
       byte result = 0;
       if (value < 0)
       {
           value = - value;
           switch (value % 10)
           {
               case 0:  result = 13;
                        break;
               case 1:  result = 29;
                        break;
               case 2:  result = 45;
                        break;
               case 3:  result = 61;
                        break;
               case 4:  result = 77;
                        break;
               case 5:  result = 93;
                        break;
               case 6:  result = 109;
                        break;
               case 7:  result = 125;
                        break;
               case 8:  result = -115;
                        break;
               case 9:  result = -99;
           }   

       }
       else
       {
           switch (value % 10)
           {
               case 0:  result = 12;  //0c
                        break;
               case 1:  result = 28;  //1c
                        break;
               case 2:  result = 44;  //2c
                        break;
               case 3:  result = 60;  //3c
                        break;
               case 4:  result = 76;  //4c
                        break;
               case 5:  result = 92;  //5c
                        break;
               case 6:  result = 108;  //6c
                        break;
               case 7:  result = 124;  //7c
                        break;
               case 8:  result = -116; //8c
                        break;
               case 9:  result = -100;  //9c  
           }
       }
       value = value / 10;
       address = address + noBytes - 1;
       m.setByte(address, new Byte(result)); //rightmost byte is correct
       address = address - 1;   // working right to left
       for(int i = 0; i < noBytes -1; i++) 
       {
           int digit = value % 10;
           result = (byte) digit;
           value = value / 10;
           digit = (value % 10) * 16;
           result = (byte) (digit + result);
           value = value / 10;
           m.setByte(address, new Byte(result));
           address = address - 1;
        }     
   }   
   public static boolean overFlow(int answer, int length)      //Did the answer overflow the length?
   {
       int noDigits = (2 * length) - 1;
       int limit = (int) Math.pow( 10.0, noDigits);
       if (answer >= limit) return true;
       if (answer <=  - limit) return true;
       return false;
   }
   
   public static int isPacked(Memory m, int address, int noBytes)
   {    
      // Resulting Condition Code:
      final int ALLGOOD = 0;      //  All digit codes and the sign valid
      final int BADSIGN = 1;      //  Sign invalid 
      final int BADDIGIT = 2;     //  At least one digit code invalid 
      final int BADSIGNDIGIT = 3; //  Sign invalid and at least one digit code invalid 
       int retValue = ALLGOOD;
       int lDigit;
       int rDigit;
       Byte nextByte = m.getByte(address);
       for(int i = 0; i < noBytes - 1; i++)
       {
           lDigit = Hex.leftDigitAsInt(nextByte);
           rDigit = Hex.rightDigitAsInt(nextByte);
           if (! ((lDigit >= 0) && (lDigit <= 9)))
           {
               retValue = BADDIGIT;
           }
           if (! ((rDigit >= 0) && (rDigit <= 9)))
           {
               retValue = BADDIGIT;           
           }
           address = address + 1;
           nextByte = m.getByte(address);
       }
       lDigit = Hex.leftDigitAsInt(nextByte);
       if (! ((lDigit >= 0) && (lDigit <= 9)))
       {
          retValue = BADDIGIT;
       }
       if (! Hex.isRightDigitValidSign(nextByte))
       {
           if (retValue == BADDIGIT)
           {
               retValue = BADSIGNDIGIT;
           }
           else
           {
               retValue = BADSIGN;
           }
       }
       return retValue;
   }
}


