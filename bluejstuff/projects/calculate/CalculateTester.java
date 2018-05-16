
/**
 * Write a description of class calculatorTester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class CalculateTester
{
  public static void main(String[] args){
      Calculate c1= new Calculate();
      System.out.println(c1.add(2,3));
      System.out.println(c1.add(2.5,7.0));
      
      Calculator c2= newCalculator2();
      System.out.println(c2.add(2,3));
      System.out.println(c2.multiply(2.5,7.0));
      
      Cancalculate c = new CanCalculate();
      c.add(1,2);
      c.multiply(3.0,4.5);
      //dynamic method lookup
      //an expression of polymorphism
      c= new Calculate2();
      c.add(1,2);
      c.multiply(3.0,4.5);
      
      Calculate[] array1 = new Calculate[2]; 
      // the value in the new Calculator[#] indicates how many values you want in your array
      array1[0]= new Calculate();
      array1[1]= new Calculate();
      
      Calculate[] array2 = new Calculate2[2]; 
      // the value in the new Calculator[#] indicates how many values you want in your array
      array2[0]= new Calculate2();
      array2[1]= new Calculate2();
      //polymorphism and dynamic method lookup`
      CanCalculate[] versatile= newCanCalculate[2];
      versatile[0]= new Calculator();
      versatile[1]= new Calculator2();
      versatile[0].add(5,7);
      versatile[1].add(5,7);
      
    }
}
