// Eric Heep
// ave_piezo.ion

// setting 
#define PIN_DDR DDRD
#define PIN_PORT PORTD

// my incrementer
uint8_t inc;
uint8_t num;
uint8_t val;

void setup() {  
  num = 5;
  
  // making my LEDs all ready
  PIN_DDR |= (1 << DDB0)|(1 << DDB1)|(1 << DDB2)|(1 << DDB3)|(1 << DDB4)|(1 << DDB5)|(1 << DDB6)|(1 << DDB7);

  // halts interrupts
  cli();

  // settin timer one
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1  = 0;
  // setting reset clock to 65535 (max for timer 1, which is a 16bit clock)
  OCR1A = 249;
  // turn on CTC mode
  TCCR1B |= (1 << WGM12);
  // set clk/8
  // TCCR1B |= (1 << CS11);  
  // set clk/256
  TCCR1B |= (1 << CS12);  
  // enable timer compare interrupt
  TIMSK1 |= (1 << OCIE1A);

  // allows interrupts
  sei();
}

// loops at 2 millionths of a second
ISR(TIMER1_COMPA_vect){
  inc = (inc + 1) % num;
  if (inc == 0) {
    val = (val + 1) % 2;
  }
  if (val == 0) {
    PIN_PORT = B11111111;
  }
  else {
    PIN_PORT = 0; 
  }
}

// I guess this loop just HAS to be here
void loop() {
  // boring loop is boring
}

