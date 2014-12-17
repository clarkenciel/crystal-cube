// sensor-receive.ino
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
long long frq;

void setup() {
  Serial.begin(9600);

  // LED testing
  for (int i = 0; i < 3; i++) {
    pinMode(11 + i, OUTPUT);
  }
}

// main program
void loop() {
  if (Serial.available() && handshake == 1) {
    unpack();
  }
  else if (Serial.available() && handshake == 0) {
    sendID();
  }
}

void unpack() {
  // reads in a four element array from ChucK
  Serial.readBytes(bytes, 4);

  // bit unpacking
  num = byte(bytes[0]) >> 3;
  //frq = (byte(bytes[0]) << 24 | byte(bytes[1]) << 16 | byte(bytes[2]) << 8 | byte(bytes[3])) & 134217727; 
  frq = byte(bytes[2] << 8); 
  digitalWrite(12, HIGH);
  delay(50);
  digitalWrite(12, LOW); 
  
  if (frq == 59904) {
    digitalWrite(11, HIGH);
    delay(50);
    digitalWrite(11, LOW); 
  }
  // will write to piezos here
  // -------------------------
  // num
  // frq * 0.001 
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









