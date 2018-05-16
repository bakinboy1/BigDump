#include <SoftwareSerial.h>
//define variables
#define _baudrate 115200
#define _rxpin 4
#define _txpin 5
SoftwareSerial debug(_rxpin, _txpin);
//wifi connection
#define SSID "IoT-Zero"
#define PASSWORD "IoTL@BZero"
//socket setup
#define IP "192.168.0.10"
#define PORT "40001"

void setup() {
  // put your setup code here, to run once:
  Serial.begin(_baudrate);
  debug.begin(_baudrate);

  sendDebug("AT");
  delay(5000);
  if (Serial.find("OK")) {
    debug.println("recieved ok");
    connectWifi();
  }
}

void loop() {
  // put your main code here, to run repeatedly:
updateGateway();
delay(5000);
}
void updateGateway() {
  //setup gateway connection
  String cmd = "AT+CIPSTART=\"UDP\",\"";
  cmd += IP;
  cmd += "\",";
  cmd += PORT;
  sendDebug(cmd);
  Serial.println("AT+CISFR");
  delay(3000);
  if (Serial.find("ERROR")) {
    debug.println("RECIEVED: ERROR");
    return;
  }
  //repurposing cmd command. saves memory
  cmd = "hello";
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
