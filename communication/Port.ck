// Port.ck

// Eric Heep
// Matches serial ports with their Arduino IDs 
// receives ultrasonic sensor values and sends piezo 
// phase increment values,

// Created for the Crystal Cube installation in 
// collaboration with Danny Clarke
// CalArts Music Tech // MTIID4LIFE

public class Port { 
    // collects list of all connected serial devices
    SerialIO.list() @=> string list[];
    int serial_port[list.cap()];
    
    // calls numPorts() to find how many USB ports are available
    SerialIO serial[numPorts()];
    int arduinoID[serial.cap()];

    // array for receiving sensor values
    int sensor[9];
    
    // arduino sampling rate
    float arduino_sr;
    arduinoSamplingRate(15625);

    // exponential multiplier for sending serial
    Math.pow(10, 7) => float mult;

    // two pi
    pi * 2.0 => float two_pi;

    // pairs arduinos and ports
    fun void init() { 
        for (int i; i < arduinoID.cap(); i++) {
            i => arduinoID[i];
        }
        openPorts();
        handshake();
    } 

    // sets arduino sampling rate
    fun void arduinoSamplingRate(float asr) {
        asr => arduino_sr;
    }

    // matches the proper arduino ID to the arduinoID array index
    fun int port(int ID) {
        for (int i; i < arduinoID.cap(); i++) {
            if (ID == arduinoID[i]) {
                return i;
            }
        }
        return -1;
    }

    // returns how many usb serial connections are available
    fun int numPorts() {
        int num;
        <<< "-", "" >>>;
        for (int i; i < serial_port.cap(); i++) {
            if (list[i].find("usb") > 0) {
                i => serial_port[num];
                num++;
            }
        }
        <<< "Found", num, "available USB ports:", "" >>>;
        return num;
    }
   
    // opens only how many serial ports there are usb ports connected
    fun void openPorts() {
        for (int i; i < serial.cap(); i++) {
            if (!serial[i].open(serial_port[i], SerialIO.B57600, SerialIO.BINARY)) {
                <<< "Unable to open serial device:", "\t", list[serial_port[i]] >>>;
            }
            else {
                <<< list[serial_port[i]], "assigned to port", serial_port[i], "" >>>;
            }
        }
        <<< "-", "" >>>;
        2.5::second => now;
    }

    // pings the Arduinos and returns their 'arduinoID'
    fun void handshake() {
        // flush out old messages
        [255, 255] @=> int ping[];
        for (int i ; i < serial.cap(); i++) {
            serial[i].writeBytes(ping);
            serial[i].onByte() => now;
            serial[i].getByte() => int ID;
            // sets arduino ID array
            ID => arduinoID[i];
            <<< ID, "" >>>;
            300::ms => now;
        }
    }

    // spork to begin receiving notes
    fun void receive(int ID) {
        int which, val;
        int data[3];

        port(ID) => int p;
        while (true) {
            // waits
            serial[p].onBytes(4) => now;
            serial[p].getBytes() @=> data;

            // bit unpacking
            (data[2] >> 3) & 15 => which;
            (data[2] & 7) << 7 | data[3] => val;

            // garbage filter
            if (data[0] == 64 && data[1] == 64) {
                val => sensor[which];
            }
        }
    }

    // tranlates frequency to phase increment
    fun float frequencyToPhaseIncrement(float frq) {
        return (frq / arduino_sr) * two_pi;
    }

    // turns float into an int for sending over serial
    fun int intPacking(float f) {
        return ((f + 1.0) * mult) $ int; 
    }

    // sends serial, allows note numbers 0-32
    // and phase increment 0-134217728 
    fun void note(int ID, int num, float frq) {
        int bytes[4];

        intPacking(frequencyToPhaseIncrement(frq)) => int phase_inc;

        // bit packing
        num << 3 => bytes[0];
        (phase_inc >> 24) | bytes[0] => bytes[0];
        (phase_inc >> 16) & 255 => bytes[1];
        (phase_inc >> 8) & 255 > bytes[2];
        phase_inc & 255 => bytes[3];

        // matches port to ID
        port(ID) => int p;
        if (p != -1) {
            serial[p].writeBytes(bytes);
        }
        else {
            <<< "No matching port for Arduino ID", ID >>>;
        }
    }
}


/*
Port p;
p.init();

2::second => now;
spork ~ p.receive(0);

while (true) {  
    <<< p.sensor[0], p.sensor[1] >>>;
    // p.note(Math.random2(1, 9), Math.random2(0,2), Math.random2(400, 1500));
    //  p.note(i + 1, 2, Math.random2(400, 500));
    200::ms => now;
}*/
