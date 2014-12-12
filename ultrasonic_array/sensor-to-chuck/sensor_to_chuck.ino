// MAJOR TODO:
// add handshaking to distinguish between various Arduinos

// ultrasonic_to_chuck.ino
// Eric Heep
// sends any number of analog sensors out through
// serial granted there are enough available analog pins

// constant
#define NUM_SENSORS 6

// for storing analog values and 
// reducing redudant serial messages
byte sensor[NUM_SENSORS];
byte val;

// for sending data
byte bytes[2];

void setup() {
    Serial.begin(9600);
}

void loop() {
    // loops through number of ultrasonics
    // sends serial if the value has changed
    for (int i = 0; i < NUM_SENSORS; i++) {

      // reads in values starting at analog pin 2
      val = analogRead(i + 2); 
      
      // only sends if receiving a new value
      if (val != sensor[i]) {
         sensor[i] = val;
         
         // packs values into an array
         bytes[0] = i;
         bytes[1] = val;
         
         // serial send as an array
         Serial.write(bytes, 2);
       }
    }
    // standard 10 millisecond delay for analog sensors
    delay(10);
}
