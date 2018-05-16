
import java.io.*;
import java.net.*;
import java.util.Scanner;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;

public class TCPClient {
    public static void main(String argv[]) throws Exception
    {
        //strings that will be used to read file lines
        String sentence;
        String modifiedSentence;
        
        
        
        //endtime-startime
        long calculatedTime = 0;
        //time when file starts
        long startTime = 0;
        //when file is done
        long endTime = 0;
        //average=total/100
        long averageTime= 0;

        // total amout of time it takes to transfer files
        long totalTime = 0;
        //school's ip address. 
        //WARNING
        //program ONLY works at school, connection times out using home IP address
        //why? probably security issue im guessign
        String ipAddress = "168.27.189.60";
        //assigned port number
        int port = 9877;
        //file name to be assigned
        String fileName = "";
        //variable of file that will be sent
        File sendFileName = new File("small.txt");
        //outputs where the program is connecting to
        System.out.println("I am connecting to server side: " + ipAddress);
        //while less than 100 packs have been sent it runs
        for(int i = 0; i < 100; i++)
        {
            //scanner in used to read sendFileName
            Scanner scan = new Scanner(sendFileName);
            //use socket with the given ipAddress and port
            Socket clientSocket = new Socket(ipAddress, port);
            // the data that will be sent
            DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
            //start time is given a value to be used later for calculation
            startTime = System.currentTimeMillis();
            //output- states which file it's sending out
            System.out.println("I am sending: "+sendFileName+"   "+"for the "+(i + 1)+"th time");
            //writes data to be sent
            while(scan.hasNextLine()){
                outToServer.writeBytes(scan.nextLine() + '\n');
            }
            scan.close();
            //states when file is done sending
            System.out.println("I am finishing sending file: "+sendFileName+" for the "+(i + 1)+"th time");
            //assigns time to endTime to calculate how long it took
            endTime = System.currentTimeMillis();
            //# of miliseconds to recieve file
            calculatedTime = (endTime - startTime);
             //calculated times are added up to calculate average later
            totalTime+= calculatedTime;
            //output saying how long it took to send the file
            System.out.println("The time used in millisecond to send file " + sendFileName+ " for the " + (i + 1) + "th time is: " +calculatedTime);
            clientSocket.close();
        }
        //average time calculated
        averageTime = totalTime / 100;
        // prints average time and done statement
        System.out.println("The average time to send file " + sendFileName+ " in millisecond is: " +averageTime);
        System.out.println("I am done now!");

    }
}

