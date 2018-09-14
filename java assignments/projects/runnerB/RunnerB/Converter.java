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

import java.util.HashMap;
/**
 * Write a description of class Conversion here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Converter
{
    private static HashMap<Byte,Character> table;

    /**
     * Constructor for objects of class Conversion
     * EBCIDIC to ASCII converter
     */
    public Converter()
    {
        table = new HashMap<Byte,Character>();
        table.put(new Byte((byte)193),new Character('a'));   //(EBCDIC,ASCII)
        table.put(new Byte((byte)194),new Character('b'));
        table.put(new Byte((byte)195),new Character('c'));   //(EBCDIC,ASCII)
        table.put(new Byte((byte)196),new Character('d'));
        table.put(new Byte((byte)197),new Character('e'));   //(EBCDIC,ASCII)
        table.put(new Byte((byte)198),new Character('f'));
        table.put(new Byte((byte)199),new Character('g'));   //(EBCDIC,ASCII)
        table.put(new Byte((byte)200),new Character('h'));  
        table.put(new Byte((byte)201),new Character('i'));    
        table.put(new Byte((byte)209),new Character('j'));  
        table.put(new Byte((byte)210),new Character('k'));            
        table.put(new Byte((byte)209),new Character('j'));  
        table.put(new Byte((byte)210),new Character('k'));  
        table.put(new Byte((byte)211),new Character('l'));  
        table.put(new Byte((byte)212),new Character('m'));  
        table.put(new Byte((byte)213),new Character('n'));  
        table.put(new Byte((byte)214),new Character('o'));  
        table.put(new Byte((byte)215),new Character('p'));  
        table.put(new Byte((byte)216),new Character('q'));  
        table.put(new Byte((byte)217),new Character('r'));  
        table.put(new Byte((byte)226),new Character('s'));  
        table.put(new Byte((byte)227),new Character('t'));  
        table.put(new Byte((byte)228),new Character('u'));  
        table.put(new Byte((byte)229),new Character('v'));  
        table.put(new Byte((byte)230),new Character('w'));  
        table.put(new Byte((byte)231),new Character('x'));  
        table.put(new Byte((byte)232),new Character('y'));  
        table.put(new Byte((byte)233),new Character('z'));                
        table.put(new Byte((byte) 64),new Character(' '));   //space
        table.put(new Byte((byte)240),new Character('0'));   //0        
        table.put(new Byte((byte)241),new Character('1'));   //1
        table.put(new Byte((byte)242),new Character('2'));
        table.put(new Byte((byte)243),new Character('3'));
        table.put(new Byte((byte)244),new Character('4'));
        table.put(new Byte((byte)245),new Character('5'));
        table.put(new Byte((byte)246),new Character('6'));
        table.put(new Byte((byte)247),new Character('7'));
        table.put(new Byte((byte)248),new Character('8'));
        table.put(new Byte((byte)249),new Character('9'));
       
    }
    public static Character EBCDICtoASCII(byte b)
    {
        Character ch = table.get(b);
        return ch;
    }
}
