public class CH extends RXInstruction
{
	/**
	 * Constructor for objects of class CH
	 */
	public CH(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " CH - Compare Halfword - RX\n Object Code:  OPCODE|R1X2|B2D2|D2D2\n Explicit Format: R1,D2(X2,B2)";
		setDescription(d);	
		setTargetHighlighting(-1); // no highlighting in memory
		setSourceHighlighting(getEffectiveAddress());
		setTargetRegHighlighting(getReg1().getRegNumber());
	//	setSourceRegHighlighting(getBaseReg2().getRegNumber());		
		setIndexRegHighlighting(getIndexReg2().getRegNumber());		
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());		
	}

	/**
	 * execute - emulates execution of an CH instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getReg1();
		Register b2 = getBaseReg2();
		Register i2 = getIndexReg2();
		PSW psw = getPSW();
		int source = getEffectiveAddress();
		if (source - 4 > getMemory().getSize())
		{
		    System.out.println("0C4 - Protection Exception");
		}
		Memory memory = getMemory();
		int regValue = b1.getRegValue();
		int val = Memory.toIntFromFourBytes(new Byte("0"), 
		                                    new Byte("0"),
		                                    memory.getByte(source),
		                                    memory.getByte(source+1));
		int returnCode = 0;
        if (regValue < val)
        {
            returnCode = 1; //low
        }
        if (regValue > val)
        {
            returnCode = 2; //high
        }
        psw.setConditionCode(returnCode);
	}
}
