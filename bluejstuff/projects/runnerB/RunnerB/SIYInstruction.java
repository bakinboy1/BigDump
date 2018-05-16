
/**
 * Write a description of class SIYInstruction here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class SIYInstruction extends Instruction
{
    private int br1No;
    private Register b1Reg;
    private int constant;
    private int displacement;
    private int effectiveAddress;
    
	/**
	 * Constructor for objects of class SIYInstruction
	 */
	public SIYInstruction(int addr, Memory myMemory, PSW psw,Registers registers)
	{
		super(addr,myMemory,psw,registers);
		setInstructionLength(6);     //all SIY instructions are 6 bytes long
		br1No = Hex.leftDigitAsInt(getCodeI(2));
		b1Reg = getRegisters().getRegister(br1No);
		displacement = Hex.getDisplacement20(getCodeI(2),getCodeI(3),getCodeI(4));
		constant = getPlainBinary(1);
		if (br1No!= 0)
 		{
    		   effectiveAddress = b1Reg.getRegValue() + displacement;
        }
        else
        {
               effectiveAddress = displacement;
        }
		myMemory.setHighlighting(1, 6, getSourceHighlighting(), getTargetHighlighting(), -1,-1,-1,br1No,-1);				
    }


	public Register getBaseReg1()
	{
	    return b1Reg;
	}
	public int getBaseReg1No()
	{
	    return br1No;
	}
	public int getDisplacement()
	{
	    return displacement;
	}
	public int getEffectiveAddress()
	{
	    return effectiveAddress;
	}
	public int getConstant()
	{
	    return constant;
	}
	public void execute()
	{
	    System.out.println("I'm executing");
   }
}