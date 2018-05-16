//wifi stuff
#include <math.h>
#include <SoftwareSerial.h>
#define _baudrate 115200
#define _rxpin 5
#define _txpin 6
SoftwareSerial debug(_rxpin, _txpin);
//wifi connection
#define SSID "IoT-Zero"
#define PASSWORD "IoTL@BZero"
//socket setup
#define IP "192.168.0.10"
#define PORT "10011"
//sensor stuff
const int flame= A0;
const int pin3=3;
const int pin4=4;
const int button=2;
int buttonState=0;
int sensorPin = A1;
int value;
boolean change = false;
int GR=0;
String mode="LOW";

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
pinMode(pin3,OUTPUT);
pinMode(pin4,OUTPUT);

pinMode(button, INPUT);
}



void loop() {
  buttonState=digitalRead(button);
  int readVal=analogRead(sensorPin);
  float temp =  Thermistor(readVal);
 int fire=analogRead(flame);

//
//Serial.print( "temp: ");
//Serial.println(  temp);
//
//Serial.print( "flame: ");
//Serial.println(fire);
delay(500);
 
if(buttonState==HIGH && change==true){
  if(GR==0){
 digitalWrite(pin3,HIGH);
  digitalWrite(pin4,LOW);
//Serial.println("pin3");
mode="LOW";
 GR=1;
 }
 else{
   digitalWrite(pin4,HIGH);
    digitalWrite(pin3,LOW);
    mode="HIGH";
//Serial.println("pin4");
   GR=0;
  }
 change=false;
 
 
  }
  
else if(buttonState==LOW && change==false){
 
   change=true;

  }
  updateGateway(temp, fire, mode);
}


//////////////////////////////////
//wifi stuff
void updateGateway(int temp, int fire, String mode) {
  //setup gateway connection
  String cmd = "AT+CIPSTART=\"UDP\",\"";
  cmd += IP;
  cmd += "\",";
  cmd += PORT;
  sendDebug(cmd);
  Serial.println("AT+CISFR");
  delay(30000);
  if (Serial.find("ERROR")) {
    debug.println("RECIEVED: ERROR");
    
    return;
  }
  //repurposing cmd command. saves memory
  //temp, value-photoresistor
  
  cmd = String(temp) + " "+ String(fire)+" "+String(mode);
 Serial.print("AT+CIPSEND=");
  Serial.println(cmd.length());
  
    delay (2000);
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
  delay(2000);
  String cmd = "AT+CWJAP=\"";
  cmd += SSID;
  cmd += "\",\"";
  cmd += PASSWORD;
  cmd += "\"";

  sendDebug(cmd);
  delay(5000);
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

