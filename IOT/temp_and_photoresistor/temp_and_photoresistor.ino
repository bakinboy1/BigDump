//wifi stuff
#include <math.h>
#include <SoftwareSerial.h>
#define _baudrate 115200
#define _rxpin 4
#define _txpin 5
SoftwareSerial debug(_rxpin, _txpin);
//wifi connection
#define SSID "IoT-Zero"
#define PASSWORD "IoTL@BZero"
//socket setup
#define IP "192.168.0.10"
#define PORT "10011"
//sensor stuff
const int flame= A0;
const int ledPin=3;
int sensorPin = A1;
int value;

double Thermistor(int RawADC) {
  double Temp,Vo;
  Vo=float(RawADC)*(3.3/4095);
  Temp = log(10000*(3.3/Vo-1));
  Temp = 1 / (0.001129148 + (0.000234125 + (0.0000000876741 * Temp * Temp ))* Temp );
  Temp = Temp - 206.15;// Convert Kelvin to Celcius
  return Temp;
}

void setup() {
  // put your setup code here, to run once:
//wifi stuff
Serial.begin(_baudrate);
  debug.begin(_baudrate);

  sendDebug("AT");
  delay(5000);
  if (Serial.find("OK")) {
    debug.println("recieved ok");
    connectWifi();
  }
//sensor stuff
pinMode(ledPin,OUTPUT);
pinMode(flame, INPUT);
}
int on = 0;
int off = 0;
void loop() {
  int readVal=analogRead(sensorPin);
  double temp =  Thermistor(readVal);
 int fire=analogRead(flame);
updateGateway(temp, fire);

Serial.print( "temp: ");
Serial.println(  temp);

Serial.print( "flame: ");
Serial.println(fire);
delay(500);
 
if(fire<800 ){
  digitalWrite(ledPin,HIGH);
  if(off<1){

  off=off+1;
  on=0;  }
  }
else{
 
    if(on<1){

  digitalWrite(ledPin,LOW);
  on=on+1;
  off=0;
  }
  }
  
}


//////////////////////////////////
//wifi stuff
void updateGateway(int temp, int fire) {
  //setup gateway connection
  String cmd = "AT+CIPSTART=\"UDP\",\"";
  cmd += IP;
  cmd += "\",";
  cmd += PORT;
  sendDebug(cmd);
  Serial.println("AT+CISFR");
  delay(300);
  if (Serial.find("ERROR")) {
    debug.println("RECIEVED: ERROR");

    return;
  }
  //repurposing cmd command. saves memory
  //temp, value-photoresistor
  cmd = String(temp) + " "+ String(fire);
  Serial.print("AT+CIPSEND=");
  Serial.println(cmd.length());
  delay (200);
  if (Serial.find(">")) {
    debug.print(">");
    debug.println(cmd);
    Serial.print(cmd);
  }
  else {
    sendDebug("AT+CIPCLOSE");

  }
  if (Serial.find("OK")) {
    sendDebug("Recieved: OK");
    //maybe not needed
     sendDebug("AT+CIPCLOSE");
  }
  else {
    sendDebug("Recieved: ERROR");

  }
}
void sendDebug(String cmd) {
  debug.print("SEND: ");
  debug.println(cmd);
  Serial.println(cmd);
}
boolean connectWifi() {
  Serial.println("AT+CWMODE=1");
  delay(200);
  String cmd = "AT+CWJAP=\"";
  cmd += SSID;
  cmd += "\",\"";
  cmd += PASSWORD;
  cmd += "\"";

  sendDebug(cmd);
  delay(9000);
  if (Serial.find("OK")) {
    debug.println("RECIEVED: OK");
    Serial.println("CONNECTED");
    return true;
  }
  else {
    debug.println("RECIEVED: ERROR");
    return false;
  }
}

