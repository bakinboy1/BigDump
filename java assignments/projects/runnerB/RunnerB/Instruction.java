
/**
 * Write a description of class Instruction here.
 * 
 * @author Woolbright 
 * @version October 2007
 */
public class Instruction
{
    private Memory memory;          //a reference to the Memory object
    private PSW psw;                //a reference to the PSW
    private Registers registers;    //a reference to the Registers object
	private Byte[] code;            //a six byte area that contains object code
	private final int NOBYTES = 6;  //instruction sizes are 2,4,and 6 bytes, allow for max size
	private String opcode;
	private int instructionLength;
	private String description;
	private int sourceHighlighting;
	private int targetHighlighting;
	private int sourceRegHighlighting;
	private int targetRegHighlighting;
	private int indexRegHighlighting;
	private int baseReg1Highlighting;
	private int baseReg2Highlighting;	
    public static final int EQUAL = 0;   //Condition code
    public static final int LOW = 1;
    public static final int HIGH = 2;
    public static final int OVERFLOW = 3;
    

	/**
	 * Constructor for objects of class Instruction
	 */
	public Instruction(int addr, Memory memory, PSW psw,Registers registers)
	{
	    this.memory = memory;
	    this.psw = psw;
	    this.registers = registers;
	    instructionLength = NOBYTES;
	    code = new Byte[NOBYTES] ;
	    for (int i = 0; i < NOBYTES; i++)
	    {
	        code[i] = Byte.decode(memory.getByte(addr++).toString());  //This creates a new Byte object for each mem[] cell
	    }
	    opcode = Hex.toHex(code[0]);
	    switch (opcode)
	    {
	        case "a7" :	 
	        case "c0" :
	        case "c2" :
	        case "c4" :
	                     opcode += Hex.toLowerHexDigit(Hex.rightDigitAsInt(code[1]));
	                     break;
	        case "eb" :  
	        case "ec" :
	        case "e3" :
	                     opcode += Hex.toHex(code[5]);
	                     break;
	        case "b2" :
	        case "b9" :
	                     opcode += Hex.toHex(code[1]);
	    }
	    description = "Instruction description";
	}
	public String getOpcode()
	{
	    return opcode;
	}
    public Byte getCodeI(int i)
    {
        return code[i];
    }
    public int getPlainBinary(int i)
    {
        int y = code[i].intValue();
        if (code[i].intValue() < 0)
        {
           return code[i].intValue() + 256;
        }
        else
        {
           return code[i].intValue();
        }
    }
    public int getPlainBinary2(int i)
    {
        int y1 = 0;
        int y2 = 0;
        if (code[i].intValue() < 0)
        {
           y1 = code[i].intValue() + 256;
        }
        else
        {
           y1 = code[i].intValue();
        }
        if (code[i+1].intValue() < 0)
        {
           y2 = code[i+1].intValue() + 256;
        }
        else
        {
           y2 = code[i+1].intValue();
        }  
        return (y1 * 256) + y2;
    }    
    public int getLength1()
    {
        if (code[1].intValue() < 0)
        {
           return (code[1].intValue() + 256) / 16;
        }
        else
        {
           return (code[1].intValue() / 16);
        }
    }
    public int getLength2()
    {
        if (code[1].intValue() < 0)
        {
           return (code[1].intValue() + 256) % 16;
        }
        else
        {
           return (code[1].intValue() % 16);
        }
    }
    public Memory getMemory()
    {
        return memory;
    }
    public PSW getPSW()
    {
        return psw;
    }
    public Registers getRegisters()
    {
        return registers;
    }
    public void setCodeI(int i, byte xx)
    {
        code[i] = xx;
    }
    public String toString()
    {
        String temp = "";
        for (int i = 0; i < NOBYTES; i++)
        {
            temp += Hex.toHex(code[i]);           //convert each Byte to a hexadecimal string of length 2 (2 hex digits per Byte)       
        }
        return temp;
    }
    public int getInstructionLength()
    {
        return instructionLength;
    }
    public void setInstructionLength(int len)
    {
        instructionLength = len;
    }
    public void execute()
    {
        System.out.println("I'm executing");
    }
    public void setDescription(String d)
    {
        description = d;
    }
    public String getDescription()
    {
        return description;
    }
    public int getSourceHighlighting()
    {
        return sourceHighlighting;
    }
    public int getTargetHighlighting()
    {
        return targetHighlighting;
    }
    public void setSourceHighlighting(int s)
    {
        sourceHighlighting = s;
    }
    public void setTargetHighlighting(int t)
    {
        targetHighlighting = t;
    }
    public void setSourceRegHighlighting(int val)
    {
        sourceRegHighlighting = val;
    }
    public void setTargetRegHighlighting(int val)
    {
        targetRegHighlighting = val;
    }
    public void setIndexRegHighlighting(int val)
    {
        indexRegHighlighting = val;
    }
    public void setBaseReg1Highlighting(int val)
    {
        baseReg1Highlighting = val;
    }
    public void setBaseReg2Highlighting(int val)
    {
        baseReg2Highlighting = val;
    }    
    public int getSourceRegHighlighting()
    {
        return sourceRegHighlighting;
    }
    public int getTargetRegHighlighting()
    {
        return targetRegHighlighting;
    }
    public int getIndexRegHighlighting()
    {
        return indexRegHighlighting;
    }
    public int getBaseReg1Highlighting()
    {
        return baseReg1Highlighting;
    }
    public int getBaseReg2Highlighting()
    {
        return baseReg2Highlighting;
    }    

}
