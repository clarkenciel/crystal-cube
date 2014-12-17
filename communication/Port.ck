// Port.ck
// Eric Heep
// communicates with the Arduinos, pairs them up with the ports
// CalArts Music Tech // MTIID4LIFE

public class Port { 

    SerialIO.list() @=> string list[];
    int serial_port[list.cap()];
    
    // calls num_ports() to find how many USB ports are available
    SerialIO serial[num_ports()];
    int arduinoID[serial.cap()];

    // array for receiving sensor values
    int sensor[9];

    fun void init() { 
        for (int i; i < arduinoID.cap(); i++) {
            i => arduinoID[i];
        }
        open_ports();
        handshake();
    } 

    // returns the proper arduino ID to the child class
    fun int port(int ID) {
        for (int i; i < arduinoID.cap(); i++) {
            if (ID == arduinoID[i]) {
                return i;
            }
        }
        return -1;
    }

    // returns how many usb serial connections are available
    fun int num_ports() {
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
    fun void open_ports() {
        for (int i; i < serial.cap(); i++) {
            if (!serial[i].open(serial_port[i], SerialIO.B9600, SerialIO.BINARY)) {
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
        [255, 255] @=> int ping[];
        for (int i ; i < serial.cap(); i++) {
            serial[i].writeBytes(ping);
            <<< "Waiting", "" >>>;
            serial[i].onByte() => now;
            serial[i].getByte() => int ID;
            <<< ID >>>;
            // sets arduino ID array
            ID => arduinoID[i];
        }
    }

    // spork to begin receiving notes
    fun void receive(int ID) {
        while (true) {
            int data[2];

            // waits for next messages
            serial[ID].onBytes(2) => now;
            serial[ID].getBytes() @=> data;

            // bit unpacking
            data[0] >> 2 => int which;
            (data[0] << 8 | data[1]) => int val;

            // chucks val to sensor array
            val => sensor[which];
        }
    }

    // sends serial, allows note numbers 0-32 and frequency 0-134217728 (13421.7728hz)
    fun void note(int ID, int num, int frq) {
        int bytes[4];

        // bit packing
        num << 3 => bytes[0];
        (frq >> 24) | bytes[0] => bytes[0];
        (frq >> 16) & 255 => bytes[1];
        (frq >> 8) & 255 => bytes[2];
        frq & 255 => bytes[3];

        // matches port to ID
        port(ID) => int p;
        if (p != -1) {
            <<< bytes[0], bytes[1], bytes[2], bytes[3] >>>;
            serial[p].writeBytes(bytes);
        }
        else {
            <<< "No matching port for Arduino ID", ID >>>;
        }
    }
}

Port p;
p.init();

int inc;
while (true) {
    (inc + 1) % 6 => inc;
    0.5::second => now;
    p.note(3, 3, 11160000);
}
