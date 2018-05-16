int count;
void setup() {
  // put your setup code here, to run once:
pinMode(LED_BUILTIN, OUTPUT);
Serial.begin(9600);

 count = 0;
}

void loop() {
  // put your main code here, to run repeatedly:
  if (count<=5){
digitalWrite(LED_BUILTIN, HIGH);
delay(1000);
Serial.println("on");
digitalWrite(LED_BUILTIN, LOW);
delay(1000);
Serial.println("off");
count=count+1;
}
if (count == 5){
Serial.println("end");
}
}
