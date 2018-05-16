const int buttonPin = A0;     
   

int buttonState = 0;      

void setup() {
 
 double pin= pinMode(buttonPin, INPUT);
}

void loop() {
  buttonState = digitalRead(buttonPin);

Serial.println(pin);
delay(500);
}
