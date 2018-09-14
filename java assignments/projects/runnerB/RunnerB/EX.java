public class EX extends RXInstruction
{
	/**
	 * Constructor for objects of class EX
	 */
	public EX(int addr, Memory myMemory,PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		String d = " EX - Execute - RX\n Object Code:  OPCODE|R1X2|B2D2|D2D2\n Explicit Format: R1,D2(X2,B2)";
		setDescription(d);	
		setTargetHighlighting(getEffectiveAddress()); // no highlighting in memory
		setSourceHighlighting(-1);
		setTargetRegHighlighting(getBaseReg2().getRegNumber());
		setSourceRegHighlighting(getReg1().getRegNumber());		
		setIndexRegHighlighting(getIndexReg2().getRegNumber());		
        setBaseReg2Highlighting(getBaseReg2().getRegNumber());		
	}

	/**
	 * execute - emulates execution of an EX instruction
	 * 
	 */
	public void execute()
	{
       //no code needed here - the CPU handles this instruction
	}
}
