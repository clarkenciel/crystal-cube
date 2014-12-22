// chuck_to_avr.ino
// Eric Heep
// recieves messages from ChucK to send to piezo speakers

// ID number of the arduino, each robot must have a different one
#define arduinoID 3
#define PIN_DDR DDRB
#define PIN_PORT PORTB
#define NUM_PIEZOS 2

// communication variables
int num;
long temp;
int handshake;
char bytes[4];
long phase_inc_input;

// stores pin configuration
uint8_t pin_map;

// phase 
double phase[NUM_PIEZOS];
double phase_inc[NUM_PIEZOS];
double mult = pow(10, -7);

// delicious pi
double pi = 3.14159265359;
double two_pi = pi * 2.0;

void setup() { 
  // serial setup
  Serial.begin(9600);

  // readying piezos
  PIN_DDR |= (1 << DDB0)|(1 << DDB1)|(1 << DDB2)|(1 << DDB3)|(1 << DDB4)|(1 << DDB5);
  // halts interrupts
  cli();
  TCCR0A = 0;
  TCCR0B = 0;
  TCNT0  = 0;
  // set compare match register for 15.625khz increments
  OCR0A = 1;
  // turn on CTC mode
  TCCR0A |= (1 << WGM01);
  //TCCR1B |= (1 << WGM12);
  //TCCR2A |= (1 << WGM21);
  // Set CS12 bit for 256 prescaler
  TCCR0B |= (1 << CS12) | (1 << CS10);   
  // enable timer compare interrupt
  TIMSK0 |= (1 << OCIE0A);
  // allows interrupts
  sei();
}

// loops at 62500hz
ISR(TIMER0_COMPA_vect){
  pin_map = 0;
  for (int i = 0; i < NUM_PIEZOS; i++) {
    phase[i] += phase_inc[i];

    if (phase[i] <= pi && phase_inc[i] != 0.0) {
      pin_map = pin_map | 1 << (i + 1);
    }

    // wrap
    if (phase[i] >= two_pi) {
      phase[i] -= two_pi; 
    }
  }
  PIN_PORT = pin_map;
}

// receives bytes from ChucK for unpacking
void recieveBytes() {
  // reads in a four element array from ChucK
  Serial.readBytes(bytes, 4);

  // unpacks piezo number 0-31
  num = byte(bytes[0]) >> 3;

  // unpacks phase increment
  phase_inc_input = (byte(bytes[0]) & 8) << 24;
  temp = byte(bytes[1]);
  phase_inc_input += temp << 16;
  temp = byte(bytes[2]);
  phase_inc_input += temp << 8; 
  temp = byte(bytes[3]);
  phase_inc_input += temp;
  phase_inc[num] = (phase_inc_input * mult) - 1.0;
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

// loop
void loop() {
  if (Serial.available() && handshake == 1) {
    recieveBytes();
  }
  else if (Serial.available() && handshake == 0) {
    sendID();
  }
}
