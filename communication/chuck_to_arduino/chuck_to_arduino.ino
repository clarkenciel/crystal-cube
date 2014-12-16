// sensor-receive.ino
// Eric Heep
// recieves messages from ChucK to send to piezo speakers

// ID number of the arduino, each robot must have a different one
#define arduinoID 6

// used to pair arduinos together
int handshake;

// stores our incoming messages
char bytes[4];

// for converting bytes to values
int num;
long long frq;

void setup() {
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {
    // reads in a four element array from ChucK
    Serial.readBytes(bytes, 4);

    // bit unpacking
    num = byte(bytes[0]) >> 4;
    frq = (byte(bytes[0]) << 24 | byte(bytes[1]) << 16 | byte(bytes[2]) << 8 | byte(bytes[3])) & 134217727; 

    // message required for "handshake" to occur
    if (handshake == 0 && num == 15 && frq == 134217727) { 
      Serial.write(arduinoID);
      handshake = 1;
    }
    else {
      // will write ti piezos here
      // -------------------------
      // num
      // frq * 0.001
    }
  }
}
