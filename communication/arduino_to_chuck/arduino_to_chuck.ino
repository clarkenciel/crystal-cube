// arduino_to_chuck.ion
// Eric Heep
// sends analog sensor messages to ChucK

// ID number of the arduino, each robot must have a different one
#define arduinoID 0

// used to pair arduinos together
int handshake;

// constant
#define NUM_SENSORS 6

// for storing analog values and 
// reducing redudant serial messages
int sensor[NUM_SENSORS];
int val[NUM_SENSORS];

// for sending data
uint8_t bytes[4];

// serial setup
void setup() {
  Serial.begin(9600);
}

// main program
void loop() {
  // initializing arrays to zero
  for (int i = 0; i < NUM_SENSORS; i++) {
    sensor[i] = 0;
    val[i] = 0;  
  }
  if (handshake == 1) {
    sendBytes();
  }
  else if (Serial.available() && handshake == 0) {
    sendID();
  }
}

void sendBytes() {
  // loops through number of ultrasonics
  // sends serial if the value has changed
  for (int i = 0; i < NUM_SENSORS; i++) {
    // reads in values starting at analog pin 2
    val[i] = analogRead(i + 2); 

    // only sends if receiving a new value
    if (val[i] != sensor[i]) {
      sensor[i] = val[i];

      // bit packing
      bytes[0] = B1000000;
      bytes[1] = B1000000;
      bytes[2] = i << 3 | sensor[i] >> 7;
      bytes[3] = sensor[i] & 127;
      Serial.write(bytes, 4);
    }
  }
  // standard 10 millisecond delay for analog sensors
  delay(10);
}

// intializes communication
void sendID() {
  char initialize[2];
  Serial.readBytes(initialize, 2);

  if (byte(initialize[0]) == 255 && byte(initialize[1]) == 255) { 
    Serial.write(arduinoID);
    handshake = 1;
  }
}





