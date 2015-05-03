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
            if (list[i].find("tty") > 0) {
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
            if (!serial[i].open(serial_port[i], SerialIO.B9600, SerialIO.BINARY)) {
                <<< "Unable to open serial device:", "\t", list[serial_port[i]] >>>;
            }
            else {
                <<< list[serial_port[i]], "opened on port", serial_port[i], "" >>>;
            }
        }
        <<< "-", "" >>>;
        3.0::second => now;
    }

    // pings the Arduinos and returns their 'arduinoID'
    fun void handshake() {
        [0xff, 0xff] @=> int ping[];
        
        for (int i ; i < serial.cap(); i++) {
            -1 @=> int ID;
            while (ID == -1) {
                serial[i].writeBytes(ping);

                serial[i].onByte() => now;
                serial[i].getByte() => int arr;

                if (arr == 0xff) {
                    serial[i].onByte() => now;
                    serial[i].getByte() => ID;
                }
            }

            // sets arduino ID array
            ID => arduinoID[i];
            <<< "ID", ID, "" >>>;

            250::ms => now;
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
    
        // sentinel byte
        0xff => bytes[0];

        // clamps amp
        if (amp > 1.0) {
            1.0 => amp;
        }
        if (amp < 0.0) {
            0.0 => amp;
        }

        num => bytes[1];

        // amplitude byte
        (amp * 0xff) $ int => bytes[2];

        for (int i; i < 3; i++) {
            (frq * mult) $ int >> i * 8 & 0xff => bytes[i + 3];
        }

        // matches port to ID
        port(ID) => int p;

        if (p != -1) {
            serial[p].writeBytes(bytes);
        }
        else {
            <<< "No matching port for Arduino ID", ID >>>;
        }
        <<< bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], frq * mult $ int >>>;
    }
}

Port p;
p.init();

2 => int ID;

while (true) {  
    p.note(ID, 0, 5000.00, 1.0);
    0.1::second => now;
    p.note(ID, 1, 5000.00, 1.0);
    0.1::second => now;
}
