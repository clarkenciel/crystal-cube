// Eric Heep
// ave_piezo.ion

// setting 
#define PIN_DDR DDRD
#define PIN_PORT PORTD

double sr = 80000;
double frq = 440.0;
double cycles;
double phase;
double phase_inc;

// delicious pi
double pi = 3.14159265359;
double two_pi = pi * 2;

void setup() {  
  frq = 440;
  cycles = frq / sr;
  phase_inc = cycles * two_pi;

  // making my LEDs all ready
  PIN_DDR |= (1 << DDB0)|(1 << DDB1)|(1 << DDB2)|(1 << DDB3)|(1 << DDB4)|(1 << DDB5)|(1 << DDB6)|(1 << DDB7);

  // halts interrupts
  cli();

  // serial setup
  Serial.begin(9600);

  // setting timer 0 at 2khz
  TCCR0A = 0;
  TCCR0B = 0;
  TCNT0  = 0;
  // set compare match register for 2khz increments
  OCR0A = 1;// = (16*10^6) / (20000*64) - 1 (must be <256)
  // turn on CTC mode
  TCCR0A |= (1 << WGM01);
  // Set CS01 and CS00 bits for 64 prescaler
  TCCR0B |= (1 << CS01) | (1 << CS00);   
  // enable timer compare interrupt
  TIMSK0 |= (1 << OCIE0A);

  // allows interrupts
  sei();
}

// loops at 2 millionths of a second (I wish, still figuring out timing)
ISR(TIMER0_COMPA_vect){

  phase += phase_inc;

  if (phase <= pi) {
    PIN_PORT = B11111111;
  }
  else {
    PIN_PORT = 0; 
  }

  // wrapp
  if (phase >= two_pi) {
    phase -= two_pi; 
  }
}

// this loop just HAS to be here
void loop() {
  Serial.print("!");
  // boring loop is boring
}






