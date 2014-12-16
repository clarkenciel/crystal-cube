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

    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // THIS FUNCTION MIGHT NOT BE NEEDED AT ALL
    // MIGHT TRY DOING ALL COMMUNICATION FROM THIS CLASS
    // AND ACCESSING MEMBERS FROM THE CLASS
    // returns the proper arduino ID to the child class
    fun int port(int ID) {
        return serial_port[arduinoID[ID]];
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
        [255, 255, 255, 255] @=> int ping[];
        for (int i ; i < serial.cap(); i++) {
            serial[i].writeBytes(ping);
            serial[i].onByte() => now;
            serial[i].getByte() => int ID;
            ID => arduinoID[i];
        }
        
    }

    // spork to being receiving notes
    fun void receive() {
        while (true) {
            int data[2];

            //TODO: implement bit packing scheme for two vals
            // which = 5 bits (16 values), 1 byte plus 3 bits (1024 values)

            serial[ID].onBytes(2) => now;
            serial[ID].getBytes() @=> data;
            <<< "Receiving:", data[0], data[1] >>>:

            //TODO: unpack values here and put into which and val
            int which, val;

            val => sensor[which];
        }
    }

    // sends serial, allows note numbers 0-16 and frequency 0-134217728 (13421.7728hz)
    fun void note(int ID, int num, int frq) {
        int bytes[4];

        // num 0-16, frq 0-134217728 (allows for four decimal precision)
        num << 3 => bytes[0];
        (vel >> 24) | bytes[0] => bytes[0];
        (vel >> 16) & 255 => bytes[1];
        (vel >> 8) & 255 => bytes[2];
        vel & 255 => bytes[3];

        serial[ID].writeBytes(bytes);
    }
}
