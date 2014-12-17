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
long frq;
long temp;

// serial setup
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

// unpacks variables into
void unpack() {
  // reads in a four element array from ChucK
  Serial.readBytes(bytes, 4);

  // unpacks piezo number 0-31
  num = byte(bytes[0]) >> 3;
  
  // unpacks frequency value, 0-134217728
  frq = (byte(bytes[0]) & 8) << 24;
  temp = byte(bytes[1]);
  frq += temp << 16;
  temp = byte(bytes[2]);
  frq += temp << 8; 
  temp = byte(bytes[3]);
  frq += temp;
  
  // gives 4 decimal point precision
  frq = frq * 0.0001;
  
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









