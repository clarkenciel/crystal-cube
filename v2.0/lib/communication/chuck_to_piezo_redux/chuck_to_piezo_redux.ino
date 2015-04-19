// chuck_to_piezo_redux.ino

// Eric Heep
// recieves messages from ChucK to simultaneously 
// control multiple piezo speakers, created for the
// Crystal Cube installation in collaboration with Danny Clarke

// includes FlixiTimer2 library
#include <FlexiTimer2.h>

// ID number of the arduino, each robot must have a different one
#define arduinoID 2
#define PIN_DDR DDRB
#define PIN_PORT PORTB

// only reliable for up to 5 piezos at a time
#define NUM_PIEZOS 1

// communication variables
byte handshake;
char bytes[4];

// piezo variables
byte num;
long phase_inc_input;

// for converting from phase increment from int to float
double mult = pow(10, -7);

// stores pin configuration
uint8_t pin_map;

// phase 
double phase[NUM_PIEZOS];
double phase_inc[NUM_PIEZOS];

// delicious pi
double pi = 3.14159265359;
double two_pi = pi * 2.0;

// sets up serial and timer interrupt
void setup() { 
  // serial setup
  Serial.begin(57600);

  // readying piezos pins
  PIN_DDR |= (1 << DDB0);//|(1 << DDB1)|(1 << DDB2)|(1 << DDB3)|(1 << DDB4)|(1 << DDB5);
  
  //FlexiTimer2::set(1, 1.0/1000, serial);
  //FlexiTimer2::start();
  
  phase_inc[0] = (440.0/10000) * two_pi;
  //phase_inc[1] = (440.0/50000) * two_pi;
  //phase_inc[2] = (440.0/50000) * two_pi;
  //phase_inc[3] = (440.0/50000) * two_pi;
  
  /*
  // halts interrupts, disabled
  // cli();
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1  = 0;
  // set compare match register for 15.625khz increments
  OCR1A = 1;
  // turn on CTC mode
  //TCCR0A |= (1 << WGM21);
  TCCR1B |= (1 << WGM12);
  //TCCR2A |= (1 << WGM01);

  // Set CS12 and CS10 bit for 1024 prescaler
  TCCR1B |= (1 << CS12) | (1 << CS10);  
  // enable timer compare interrupt
  TIMSK1 |= (1 << OCIE0A);
  // allows interrupts
  sei();
  */
}

/*
// loops at 15625hz
ISR(TIMER1_COMPA_vect){
  // resets pin map
  pin_map = 0;

  // cycles through piezos
  for (int i = 0; i < NUM_PIEZOS; i++) {
    phase[i] += phase_inc[i];

    // sets individual piezo on the pin map
    if (phase[i] <= pi && phase_inc[i] != 0.0) {
      //pin_map = pin_map | 1 << (i + 3);
      pin_map = PIN_PORT | 1 << (i + 1);
    }
    //else {
      //pin_map = PIN_PORT | 0 << (i + 3);
    //}

    // wraps if above two pi
    if (phase[i] >= two_pi) {
      phase[i] -= two_pi; 
    }
  }
  // sets pin map
  PIN_PORT = pin_map;
}
*/

// receives bytes from ChucK for unpacking
void recieveBytes() {
  // reads in a four element array from ChucK
  Serial.readBytes(bytes, 4);

  // unpacks piezo number 0-31
  num = byte(bytes[0]) >> 3;

  // unpacks phase increment as a long int
  phase_inc_input = (byte(bytes[0]) & 8) << 24;
  phase_inc_input += long(byte(bytes[1])) << 16;
  phase_inc_input += long(byte(bytes[2])) << 8; 
  phase_inc_input += long(byte(bytes[3]));

  // converts phase increment value back to float
  phase_inc[num] = (phase_inc_input * mult) - 1.0;
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

// loop
void serial() {
  if (Serial.available() && handshake == 1) {
    recieveBytes();
  }
  else if (Serial.available() && handshake == 0) {
    sendID();
  }
}

void loop() {
  // cycles through piezos
  for (int i = 0; i < NUM_PIEZOS; i++) {
    phase[i] += phase_inc[i];

    // sets individual piezo on the pin map
    if (phase[i] <= pi) {
      //pin_map = pin_map | 1 << (i + 3);
      pin_map |= 1 << i;
    }
    else {
      pin_map &= 0 << i;
    }

    // wraps if above two pi
    if (phase[i] >= two_pi) {
      phase[i] -= two_pi; 
    }
  }
  // sets pin map
  PIN_PORT = pin_map;
  delayMicroseconds(100);
}
