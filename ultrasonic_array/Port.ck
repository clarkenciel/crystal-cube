// Port.ck
// Eric Heep
// communicates with the Arduinos, pairs them up with the ports
// CalArts Music Tech // MTIID4LIFE

public class Handshake { 

    SerialIO.list() @=> string list[];
    int serial_port[list.cap()];
    
    // calls num_ports() to find how many USB ports are available
    SerialIO serial[num_ports()];
    int robotID[serial.cap()];

    fun void init() { 
        for (int i; i < robotID.cap(); i++) {
            i => robotID[i];
        }
        open_ports();
        handshake();
    } 

    fun int port(int ID) {
        // returns the proper robot ID to the child class
        return serial_port[robotID[ID]];
    }

    fun int num_ports() {
        // returns how many usb serial connections are available
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
   
    fun void open_ports() {
        // opens only how many serial ports there are usb ports connected
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

    fun void handshake() {
        // pings the Arduinos and returns their 'arduinoID'
        [255, 255] @=> int ping[];
        for (int i ; i < serial.cap(); i++) {
            serial[i].writeBytes(ping);
            serial[i].onByte() => now;
            serial[i].getByte() => int arduinoID;
            arduinoID => robotID[i];
        }
        
    }

    fun void note(int ID, int num, int vel) {
        // bitwise operations, allows note numbers 0-63 and note velocities 0-1023
        int bytes[2];
        (num << 2) | (vel >> 8) => bytes[0]; 
        vel & 255 => bytes[1];
        serial[ID].writeBytes(bytes);
    }
}
