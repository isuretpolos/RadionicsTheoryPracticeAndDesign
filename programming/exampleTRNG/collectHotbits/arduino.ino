const int analogPin = A0;
int previousReading = 0;
int currentReading = 0;
unsigned long randomInteger = 0;
int bitCount = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  currentReading = analogRead(analogPin);

  if (currentReading > previousReading) {
    randomInteger = (randomInteger << 1) | 0x01; // Append '1'
    bitCount++;
    delay(1);
  } else if (currentReading < previousReading) {
    randomInteger = (randomInteger << 1); // Append '0'
    bitCount++;
  }

  previousReading = currentReading;

  if (bitCount >= 24) {
    Serial.println(randomInteger);
    randomInteger = 0;
    bitCount = 0;
  }
}
