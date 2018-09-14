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
 * Write a description of class OpenDCBs here.
 * 
 * @author Woolbright 
 * @version 2012
 */
public class OpenDCBs
{
   private  HashMap<Integer,DCB> odcbs;
   
   public OpenDCBs()
   {
      odcbs = new HashMap<Integer,DCB>();
   }
   public void add(Integer addr, DCB dcb)
   {
       odcbs.put(addr,dcb);
   }
   public DCB getDCB(Integer addr)
   {
       DCB dcb = odcbs.get(addr);  // get the dcb
       return dcb;
   }
   public String getDDName(Integer addr)
   {
       DCB dcb = odcbs.get(addr);  // get the dcb
       if (dcb != null)
          return dcb.getDDName();
       else
          return "Not found";
   }
   public String getMode(Integer addr)
   {
       DCB dcb = odcbs.get(addr);
       if (dcb != null)
          return dcb.getMode();
       else
          return "Not found";
   }
   public void removeDCB(DCB dcb)
   {
       int addr = dcb.getPhysicalAddress();
       odcbs.remove(addr);
   }
}
