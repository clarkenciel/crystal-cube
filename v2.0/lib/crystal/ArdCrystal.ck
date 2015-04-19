// ArdCrystal.ck
// Interface for working with Arduino sculpture
// REQUIRES: 
//      crystal/TennyArray.ck
//      communication/Port.ck
// Author: Danny clarke

public class ArdCrystal {
    Port ard_out;
    int sines[0][4];
    TenneyArray freqCrystal;
    int connections[0][0];
    dur pulseRate;

    void init( int num_ards ) {
        ard_out.init();
        sines.size(num_ards);
        for( int i; i < num_ards; i++ ) {
            new int[4] @=> sines[i];
            for( int j; j < sines[i].size(); i ++ )
                j => sines[j];
        }
    }

    void portOff( int p_idx ) {
        ports[p_idx];
    }

    void portOn( int p_idx, float freq, float amp ) {

    }

    // generate an array of connections between piezo speakers
    //  using BFS
    void BFS( int start_idx ) {
        int q[0];

        NULL @=> q;
    }
    
    // generate an array of connections between piezo speakers
    //  using DFS
    void DFS( int start_idx ) {
        int q[0];

        NULL @=> q;
    } 
}
