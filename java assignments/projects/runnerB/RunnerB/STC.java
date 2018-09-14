public class STC extends RXInstruction
{
	/**
	 * Constructor for objects of class STC
	 */
	public STC(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " STC - Store Character - RX\n Object Code:  OPCODE|R1X2|B2D2|D2D2\n Explicit Format: R1,D2(X2,B2)";
		setDescription(d);		
		setSourceHighlighting(-1);
		setTargetHighlighting(getEffectiveAddress());
		setSourceRegHighlighting(getReg1().getRegNumber());
		setTargetRegHighlighting(getBaseReg2().getRegNumber());		
		setIndexRegHighlighting(getIndexReg2().getRegNumber());		
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());
	}

	/**
	 * execute - emulates execution of an STC instruction
	 * 
	 */
	public void execute()
	{
		Register b1 = getReg1();
		Register b2 = getBaseReg2();
		Register i2 = getIndexReg2();
		int target = getEffectiveAddress();
		Memory memory = getMemory();
		if (target - 1 > memory.getSize())
		{
		    System.out.println("0C4 - Protection Exception");
		}
        String  bs = b1.getByteAsString(3); //rightmost byte
        int ival = Hex.toIntFromHexString2(bs);
        memory.setByte(target,new Byte((byte) ival));
	}
}