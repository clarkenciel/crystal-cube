// ultrasonic_to_chuck.ion

// Eric Heep
// Sends analog sensor messages to ChucK

// Created for the Crystal Cube installation
// in collaboration with Danny Clarke
// CalArts Music Tech // MTIID4LIFE

// ID number of the arduino
#define arduinoID 0

// used to pair arduinos together
int handshake;

// amount of sensors connected 
#define NUM_SENSORS 6

// for storing analog values and 
// reducing redudant serial messages
int sensor[NUM_SENSORS];
int val[NUM_SENSORS];

// for sending data
uint8_t bytes[4];

// loops at 10ms
void sendBytes() {
  // loops through collection of sensors 
  for (int i = 0; i < NUM_SENSORS; i++) {
    // reads in values starting at analog pin 2
    val[i] = analogRead(i + 2); 

    // checks for a new value
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

  // sends back arduion ID if handshake matches
  if (byte(initialize[0]) == 255 && byte(initialize[1]) == 255) { 
    Serial.write(arduinoID);
    handshake = 1;
  }
}

// serial setup
void setup() {
  Serial.begin(57600);
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
