// ArdCrystal.ck
// Interface for working with Arduino sculpture
// REQUIRES: TennyArray.ck
// Author: Danny clarke

public class ArdCrystal {
    int ports[0];
    TenneyArray freqCrystal;
    int connections[0][0];
    dur pulseRate;

    void init( int num_ports, int first_id ) {
        ports.size(num_ports);
        for( first_id => int i; i < num_ports; i ++ ) {
            ports << i;
        }
    }
}
