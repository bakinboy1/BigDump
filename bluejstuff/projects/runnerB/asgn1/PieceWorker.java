// Lab Exercise 1: PieceWorker.java
// PieceWorker class extends Employee.

public class PieceWorker extends Employee 
{
   /* declare instance variable wage */
   /* declare instance variable pieces */

   // five-argument constructor
   private double wage;
   private int pieces;
   
   public PieceWorker( String first, String last, String ssn, 
      double wagePerPiece, int piecesProduced )
   {
       super(first, last, ssn);
       setWage(wagePerPiece);
      setPieces(piecesProduced);
      /* write code to initialize a PieceWorker */
   } // end five-argument PieceWorker constructor

   // set wage
   /* write a set method that validates and sets the PieceWorker's wage */
   public void setWage(double newWage){
       wage=newWage;

   }
   // return wage
   /* write a get method that returns the PieceWorker's wage */
   public double getWage(){
       return wage;

   }
   // set pieces produced
   /* write a set method that validates and sets the number of pieces produced */
   public void setPieces(int newPieces){
       pieces=newPieces;
   }
   // return pieces produced
   /* write a get method that returns the number of pieces produced */
   public int getPieces(){
       return pieces;
   }
   // calculate earnings; override abstract method earnings in Employee
   public double earnings()
   {
       return getWage()*getPieces();
      /* write code to return the earnings for a PieceWorker */
   } // end method earnings

   // return String representation of PieceWorker object
   public String toString()
   {
       return String.format( "PieceWorker employee: %s\n%s: $%,.2f %s: $%s", 
         super.toString(),"wage per piece ", getWage(),"pieces produced ", getPieces() );
      /* write code to return a string representation of a PieceWorker */
   } // end method toString
} // end class PieceWorker

