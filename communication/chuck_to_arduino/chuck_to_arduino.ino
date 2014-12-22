// chuck_to_arduino.ino
// Eric Heep
// recieves messages from ChucK to send to piezo speakers

// ID number of the arduino, each robot must have a different one
#define arduinoID 3

// used to pair arduinos together
int handshake;

// stores our incoming messages
char bytes[4];

// for converting bytes to values
int num;
long temp;
long phase_inc;

// serial setup
void setup() {
  Serial.begin(9600);
}

// main program
void loop() {
  if (Serial.available() && handshake == 1) {
    recieveBytes();
  }
  else if (Serial.available() && handshake == 0) {
    sendID();
  }
}

// receives bytes from ChucK for unpacking
void recieveBytes() {
  // reads in a four element array from ChucK
  Serial.readBytes(bytes, 4);

  // unpacks piezo number 0-31
  num = byte(bytes[0]) >> 3;
  
  // unpacks frequency value, 0-134217728, 27-bits
  phase_inc = (byte(bytes[0]) & 8) << 24;
  temp = byte(bytes[1]);
  phase_inc += temp << 16;
  temp = byte(bytes[2]);
  phase_inc += temp << 8; 
  temp = byte(bytes[3]);
  phase_inc += temp;
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
