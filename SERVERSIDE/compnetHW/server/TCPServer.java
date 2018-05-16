
import java.io.*;
import java.net.*;

public class TCPServer {
    public static void main(String argv[]) throws Exception
    {
        //boolean that will be used on checking if generated files match recieved files
        boolean fileCheck=true;
        //file reader
        BufferedReader ClientFile;
        //socket vaciable, gets assigned the coded socket
        Socket connectionSocket;
        //variable assigned to read lines of file
        String clientSentence;
        //socketchoice becomes serverSocket 9877
        ServerSocket SocketChoice = new ServerSocket(9877);
        // total amout of time it takes to transfer files
        long totalTime = 0;
        //endtime-startime
        long calcTime = 0;
        //average=total/100
        long averageTime = 0;
        //when file is done
        long endTime = 0;
        
        //time when file starts
        long startTime = 0;
        //counter for when a file error is detected
        int fileErrors=0;
       
        //output
        System.out.println("I am ready for any client side request...");

        String outputFileName = "output";

        //start for loop to read file through 100 times
        for(int i = 0; i < 100; i++){
            //start time is given a value to be used later for calculation
            startTime = System.currentTimeMillis();
            //socket is connected
            connectionSocket = SocketChoice.accept();
            // file is connected
            ClientFile = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
            // recieved file copy is generated
            PrintWriter outputFile = new PrintWriter(outputFileName +(i +1) +".txt");
            //states which file is being recieved
            
            System.out.println("I am starting receiving file: "+outputFileName +(i + 1) +".txt" + " "+"for the " +(i + 1) +"th time");
           //loop that reads file contents
            while(true){
                clientSentence = ClientFile.readLine();
                //if there is nothing on the line, stop reading
                if(clientSentence == null) break;

                outputFile.println(clientSentence);

            }
            
            //states when file is done being recieved
            System.out.println("I am finishing receiving file: "+outputFileName  + (i +1) + ".txt" +" for the " + (i + 1)+ "th time");
            //assigns time to endTime to calculate how long it took
            endTime = System.currentTimeMillis();
            //# of miliseconds to recieve file
            calcTime = (endTime-startTime);
            //system output for how long it took to receive n file
            System.out.println("The time used in millisecond to send file "+ outputFileName + (i +1) + ".txt" + " for the " + (i + 1)   + "th time is: " +calcTime);
            //calculated times are added up to calculate average later
            totalTime +=calcTime;
            
            //scanner to read output files
            BufferedReader fileScan = new BufferedReader(new FileReader("output"+(i +1) + ".txt"));
            //new strings to read input and generated files 
            String originalFile= ClientFile.readLine();
            String generatedFile= fileScan.readLine();
            //file compare function
            //based on 
            //https://www.youtube.com/watch?v=zHnOgHGRvgw
            //while both scanners are not null
            while (originalFile != null || generatedFile != null)
            {
                //checks if both scanners are null
                if(originalFile == null || generatedFile == null)
                {
                    fileCheck = false;
                }
                else if(! originalFile.equalsIgnoreCase(generatedFile))
                {
                    fileCheck = false;
                }
                originalFile = ClientFile.readLine();
                generatedFile = fileScan.readLine();
            }
            // if the files read do not match up, the error counter is incremented
            if(fileCheck!= true)
            {
                fileErrors++;
            }
            outputFile.close();
        }
        //average time calculated
        averageTime = totalTime / 100;
        //system outputs average time, done statement, # of file errors detected
        System.out.println("The average time to send file in millisecond is: " +averageTime);
        System.out.println("I am done now");
        System.out.println("# of fileErrors file transfers: "+ fileErrors);
        SocketChoice.close();
    }
}
