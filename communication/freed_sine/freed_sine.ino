// Atmega table-based digital oscillator
// using "DDS" with 32-bit phase register to illustrate efficient
// accurate frequency.
// 20-bits is on the edge of people pitch perception
// 24-bits has been the usual resolution employed.
// so we use 32-bits in C, i.e. long.

// smoothly interpolates frequency and amplitudes illustrating
// lock-free approach to synchronizing foreground process  control and background (interrupt)
// sound synthesis
// copyright 2009. Adrian Freed. All Rights Reserved.
// Use this as you will but include attribution in derivative works.>
// tested on the Arduino Mega
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

int freq;
byte bytes[4];

// look Up Table size: has to be power of 2 so that the modulo LUTsize
// can be done by picking bits from the phase avoiding arithmetic
const unsigned int LUTsize = 1 << 8;

int8_t sintable[LUTsize] PROGMEM = {
  127,130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,
  176,179,182,184,187,190,193,195,198,200,203,205,208,210,213,215,
  217,219,221,224,226,228,229,231,233,235,236,238,239,241,242,244,
  245,246,247,248,249,250,251,251,252,253,253,254,254,254,254,254,
  255,254,254,254,254,254,253,253,252,251,251,250,249,248,247,246,
  245,244,242,241,239,238,236,235,233,231,229,228,226,224,221,219,
  217,215,213,210,208,205,203,200,198,195,193,190,187,184,182,179,
  176,173,170,167,164,161,158,155,152,149,146,143,139,136,133,130,
  127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,
  78,75,72,70,67,64,61,59,56,54,51,49,46,44,41,39,
  37,35,33,30,28,26,25,23,21,19,18,16,15,13,12,10,
  9,8,7,6,5,4,3,3,2,1,1,0,0,0,0,0,
  0,0,0,0,0,0,1,1,2,3,3,4,5,6,7,8,
  9,10,12,13,15,16,18,19,21,23,25,26,28,30,33,35,
  37,39,41,44,46,49,51,54,56,59,61,64,67,70,72,75,
  78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124
};

const int timerPrescale=1<<9;
struct oscillator
{
  uint32_t phase;
  int32_t phase_increment;
  int32_t frequency_increment;
  int16_t amplitude;
  int16_t amplitude_increment;
  uint32_t framecounter;
} 
o1;

// 16 bit fractional phase
const int fractionalbits = 16; 

// compute a phase increment from a frequency
unsigned long phaseinc(float frequency_in_Hz)
{
  return LUTsize *(1l<<fractionalbits)* frequency_in_Hz/(F_CPU/timerPrescale);
}

// The above requires floating point and is robust for a wide range of parameters
// If we constrain the parameters and take care we can go much
// faster with integer arithmetic
// We control the calculation order to avoid overflow or resolution loss
//
// we chose "predivide" so that (pow(2,predivide) divides F_CPU,so 4MHz (1.7v), 8Mhz, 12Mhz (3.3v) and 16Mhz 20Mhz all work
// AND note that "frequency_in_Hz" is not too large. We only have about 16Khz bandwidth to play with on
// Arduino timers anyway
const int predivide = 8;

unsigned long phaseinc_from_fractional_frequency(unsigned long frequency_in_Hz_times_256)
{
  return (1l<<(fractionalbits-predivide))* ((LUTsize*(timerPrescale/(1<<predivide))*frequency_in_Hz_times_256)/(F_CPU/(1<<predivide)));
}

#define PWM_PIN 3
#define PWM_VALUE_DESTINATION OCR2B

#define PWM_INTERRUPT TIMER2_OVF_vect

void initializeTimer() {
  TCCR2A = _BV(COM2B1) | _BV(WGM20);
  TCCR2B = _BV(CS20);
  TIMSK2 = _BV(TOIE2);
  pinMode(PWM_PIN,OUTPUT);
}

void setup() {
  Serial.begin(9600);
  o1.phase = 0;
  o1.phase_increment = 0;
  o1.amplitude_increment = 0;
  o1.frequency_increment = 0;
  o1.framecounter = 0;
  o1.amplitude = 255 * 256;
  initializeTimer();
}

long byteUnpack(byte in[], int num_bytes) {  
  long val = 0;
  for (int i = 0; i < num_bytes; i++) {
    val += in[i] << (i * 8);
  }

  return val;
}

void loop() {
  if (Serial.available()) {
    Serial.readBytes((char*)bytes, 4);

    if (byte(bytes[3]) == 0xff) {
      long freq = byteUnpack(bytes, 3);
      o1.phase_increment = phaseinc(freq);
    }
  }
}

// this is the heart of the wavetable synthesis. A phasor looks up a sine table
int8_t outputvalue = 0;
SIGNAL(PWM_INTERRUPT)
{
  //output first to minimize jitter
  PWM_VALUE_DESTINATION = outputvalue; 
  outputvalue = (((uint8_t)(o1.amplitude>>8)) * pgm_read_byte(sintable+((o1.phase>>16)%LUTsize)))>>8;
  o1.phase += (uint32_t)o1.phase_increment;
}
