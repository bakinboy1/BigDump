int redLED=9;
int yellowLED=10;
int redLEDon=250;
int redLEDoff=250;
int yellowLEDon=250;
int yellowLEDoff=250;
int red=0;
int yellow=0;
void setup() {
  // put your setup code here, to run once:
pinMode(redLED, OUTPUT);
pinMode(yellowLED, OUTPUT);
Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  while (red<5){
  digitalWrite(redLED, HIGH);
  delay(redLEDon);
  digitalWrite(redLED, LOW);
  delay(redLEDoff);
  red=red+1;
  yellow=0;
  Serial.println("red");
  }

while (yellow<5){
  digitalWrite(yellowLED, HIGH);
  delay(yellowLEDon);
  digitalWrite(yellowLED, LOW);
  delay(yellowLEDoff);
  yellow=yellow+1;
  red=0;
  Serial.println("yellow");
}
}
