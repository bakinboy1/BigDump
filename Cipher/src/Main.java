import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;


///////////////////////////////////////////
//overly dimmadang complicated ceasar cipher
///////////////////////////////////////////
public class Main {
	static char[] alphabet = "abcdefghijklmnopqrstuvwxyz".toCharArray();
	
	public static void main(String[] args) {
		while(true){ 
		Scanner scan = new Scanner(System.in);
		String stringCipher="";
		System.out.println("enter message:");
		String message=scan.nextLine();
		ArrayList<Character> shiftedPositions=new ArrayList<Character>();
		message=message.toUpperCase();
		char[] messageArray=message.toCharArray();

		String shift;
		boolean isInt=false;
		
		
		while(isInt==false) {
			
		System.out.println("enter cipher shift amount");
		 shift=scan.nextLine();
		if (shift.matches("-?(0|[1-9]\\d*)")) {
			
			//take user shift # entry, convert from string to int, and %26 it
			int intShift=Integer.parseInt(shift);
			intShift=intShift%26;
			shiftedPositions.clear();
			
			//go through each element in letterPositions and add intShift to it
			//%26 the new value before putting it into shiftedPositions in the corresponding element position
			for(int i=0;i<messageArray.length;i++) {
				int temp=0;
				temp=messageArray[i];
				
				//deal with it turning all spaces into T's
				if(Character.isWhitespace(messageArray[i])==false) {
					
				temp+=intShift;
				//some crap to do with ASCII chart. dont feel like figuring out why, but this compensates for it
				temp=(temp-13)%26;
				
				//adds letter to shifted array corresponding to letter in 'temp' array index
				
				stringCipher+=alphabet[temp];
				}
				else {
					//adds letter to shifted array corresponding to letter in 'temp' array index
					
					stringCipher+=' ';
					}
				
				
			}
			
			
			System.out.println(stringCipher+"\n");
			isInt=true;
		}
		else {
			System.out.println("you must enter an integer");
		}
		}
	}
}
	
}
