// Port.ck

// Eric Heep
// April, 2015

// Matches serial ports with their Arduino IDs 
// receives ultrasonic sensor values and sends piezo 
// phase increment values,

// Created for the Crystal Growth installation in 
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
    
    // exponential multiplier for sending serial
    Math.pow(10, 3) => float mult;

    // pairs arduinos and ports
    fun void init() { 
        for (int i; i < arduinoID.cap(); i++) {
            i => arduinoID[i];
        }
        openPorts();
        handshake();
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
            if (!serial[i].open(serial_port[i], SerialIO.B28800, SerialIO.BINARY)) {
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
        [0xff, 0xff] @=> int ping[];
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

    fun void receive(int ID) {
        // will replace with CityGram
    }

    fun int[] bytePacker(int val, int num_bytes) {
        int bytes[num_bytes];

        for (int i; i < num_bytes; i++) {
            val >> (i * 8) & 0xff => bytes[i]; 
        }

        return bytes;
    }

    // sends serial
    fun void note(int ID, int num, float frq, float amp) {
        int bytes[6];  
    
        // safety byte
        0xff => bytes[5];

        // clamps amp
        if (amp > 1.0) {
            1.0 => amp;
        }
        if (amp < 0.0) {
            0.0 => amp;
        }

        num => bytes[4];

        // amplitude byte
        (amp * 0xff) $ int => bytes[3];

        bytePacker((frq * mult) $ int, 3) @=> int freq[];

        freq[2] => bytes[2];    
        freq[1] => bytes[1];    
        freq[0] => bytes[0];    

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

1::second => now;
int inc;
while (true) {  
    inc++; 
    p.note(2, 0, inc, 1.0);
    200::ms => now;
}
*/
