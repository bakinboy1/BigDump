const int pResistor= A2;
const int ledPin=9;
const int bPin=3;
int bVal=0;
int value;
void setup() {
  // put your setup code here, to run once:

pinMode(ledPin,OUTPUT);
pinMode(pResistor, INPUT);
pinMode(bPin, INPUT);
Serial.begin(9600);
}
int on = 0;
int off = 0;
void loop() {
  // put your main code here, to run repeatedly:
value=analogRead(pResistor);
Serial.println(bVal);
delay(500);
bVal= digitalRead(bPin);

    
  
if(value<800 || bVal == HIGH){
  digitalWrite(ledPin,HIGH);
  if(off<1){
  Serial.println("on- low light");
  off=off+1;
  on=0;
  }
  }
else{
 
    if(on<1){
  Serial.println("off- sufficient light");
  digitalWrite(ledPin,LOW);
  on=on+1;
  off=0;
  }
  }
  
}

