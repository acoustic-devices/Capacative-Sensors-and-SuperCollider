// ESP32 Touch Test


void setup()
{
  Serial.begin(115200);
  delay(1000); // give me time to bring up serial monitor
  Serial.println("ESP32 Touch Test");
}

void loop()
{
  Serial.println(touchRead(T0));  // get value using T0 - GPIO 4
  delay(200);
  Serial.println(touchRead(T6));  // get value using T6 - GPIO 14
  delay(200);
}
