public class CL extends RXInstruction
{
	/**
	 * Constructor for objects of class CL
	 */
	public CL(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " CL - Compare Logical - RX\n Object Code:  OPCODE|R1X2|B2D2|D2D2\n Explicit Format: R1,D2(X2,B2)";
		setDescription(d);	
		setTargetHighlighting(-1); // no highlighting in memory
		setSourceHighlighting(getEffectiveAddress());
		setTargetRegHighlighting(getReg1().getRegNumber());
	//	setSourceRegHighlighting(getBaseReg2().getRegNumber());		
		setIndexRegHighlighting(getIndexReg2().getRegNumber());		
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());		
	}

	/**
	 * execute - emulates execution of an CL instruction
	 * 
	 */
	public void execute()
	{
	    Register b1 = getReg1();
		PSW psw = getPSW();
		int source = getEffectiveAddress();
		if (source - 4 > getMemory().getSize())
		{
		    System.out.println("0C4 - Protection Exception");
		}
		Memory memory = getMemory();
		int val1 = b1.getRegValue();
		int val2 = Memory.toIntFromFourBytes(memory.getByte(source),
		                                    memory.getByte(source+1),
		                                    memory.getByte(source+2),
		                                    memory.getByte(source+3));
        int[] x = new int[32];
        int[] y = new int[32];
        for(int i=0;i < 32;i++)
        {
            x[i] = val1 % 2;
            val1 = val1 / 2;
            y[i] = val2 % 2;
            val2 = val2 / 2;
        }
        int i = 31;
        while ((i >=0) && (x[i] == y[i]))
        {
            i = i - 1;
        }
        if (i < 0)
        {
            psw.setConditionCode(0);
        }
        else if (x[i] > y[i])
        {
            psw.setConditionCode(1);
        }
        else
        {
            psw.setConditionCode(2);
        }
	}
}
