// Eric Heep
// ave_piezo.ion

// setting 
#define PIN_DDR DDRD
#define PIN_PORT PORTD
#define NUM_PIEZOS 3

uint8_t pin_map;
uint16_t mult = pow(10, 7);

double sr = 31250;
double frq[NUM_PIEZOS];
double cycles[NUM_PIEZOS];
double phase[NUM_PIEZOS];
double phase_inc[NUM_PIEZOS];

// delicious pi
double pi = 3.14159265359;
double two_pi = pi * 2;

// integer pi
uint16_t int_pi = pi * int(mult);
uint16_t int_two_pi = two_pi * int(mult);
uint16_t int_phase_inc[NUM_PIEZOS]; 
uint16_t int_phase[NUM_PIEZOS];

void setup() {  
  for (int i = 0; i < NUM_PIEZOS; i++) {
    frq[i] = 440 + (i * 220);
    cycles[i] = frq[i] / sr;
    phase_inc[i] = cycles[i] * two_pi;
    int_phase_inc[i] = pow(10, 7) * int(phase_inc);
  }

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
  OCR0A = 2;// = (16*10^6) / (20000*64) - 1 (must be <256)
  // turn on CTC mode
  TCCR0A |= (1 << WGM01);
  // Set CS12 bit for 256 prescaler
  TCCR0B |= (1 << CS12);   
  // enable timer compare interrupt
  TIMSK0 |= (1 << OCIE0A);

  // allows interrupts
  sei();
}

// loops at 2 millionths of a second (I wish, still figuring out timing)
ISR(TIMER0_COMPA_vect){
  pin_map = 0;
  for (int i = 0; i < NUM_PIEZOS; i++) {
    phase[i] += phase_inc[i];

    if (phase[i] <= pi) {
      pin_map = pin_map | 1 << (i + 2);
    }

    // wrap
    if (phase[i] >= int_two_pi) {
      phase[i] -= int_two_pi; 
    }
  }
  PIN_PORT = pin_map;
}

// this loop just HAS to be here
void loop() {
  Serial.print("!");
  // boring loop is boring
}











