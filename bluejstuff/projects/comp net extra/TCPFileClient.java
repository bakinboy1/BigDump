import java.io.*;
import java.net.*;
import java.util.*;
import java.util.Scanner;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileInputStream;

public class TCPFileClient{
    public static void main(String argv[]) throws Exception{
        String sentence;
        String modifiedSentence;
        InetAddress host= InetAddress.getByName("127.0.0.0");
        Socket clientSocket= new Socket(host, 6689);
        DataOutputStream outToServer= new DataOutputStream(clientSocket.getOutputStream());
        BufferedReader inFromServer= new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));

        int numLines = 0;
        int m = 0;
        long startTime, endTime, tGap, totalTime;
        byte [] sendData = new byte[1024];
        File fs= new File("small.txt");
        FileInputStream fin = new FileInputStream(fs);
        int fileLength = (int)fs.length();
        int numBytes = 0;
        totalTime =0;
		////////////////////////////////////////
		
		////////////////////////////////////////
        while (true){
            if (fileLength < 1024){
                numBytes = fin.read(sendData, 0 , fileLength);
            }

            else {
                numBytes = fin.read(sendData, 0, 1024);
                startTime = System. currentTimeMillis();
            }
            while (numBytes != -1){
                sentence = new String(sendData);
                //inFromServer.writeBytes( sentence);
                outToServer.writeBytes( sentence);
                numBytes= fin.read(sendData, 0, 1024);
            }
            endTime= System.currentTimeMillis();
            tGap= endTime - startTime;
            totalTime= totalTime + tGap;
            System.out.println("i am done for "+ m +"th time sending with time: "+ tGap);
            fs.close();
            clientSocket.close();

            m++;
        
            if(m==100){ 
                break;
            }
            else{
                clientSocket = new Socket(host, 6689);
                outToServer = new DataOutputStream(clientSocket.getOutputStream());
                fs= new File("Test2.txt");
                fin = new FileInputStream(fs);
                fileLength= (int)fs.length();
            }

        }
        System.out.println("i am done to send "+m +" times file, and the average time is: "+(double)totalTime/m);
    }

}