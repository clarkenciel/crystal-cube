// TenneyArray.ck
// Implementation of James Tenney's cyrstal growth formula for harmonic space
// Freq Limits: 3000 Hz - 12000 Hz
// Author: Danny Clarke

public class TenneyArray {
    private int numDimensions;
    private float dimNumbers[0];
    private float vals[0];
    
    fun void init( int numD, int dimNums[] ) {
        numD => numDimensions;
        dimNumbers.size(numD);
        for( int i; i < numDimensions; i++ ) {
            dimNums[i] => dimNumbers[i];
        }
    }

    fun float[] generate() {
        
    }

    fun float val( int idx ) {
        return vals[idx];
    }

    fun void clear() {
        dimNumbers.size(0);
        vals.size(0);
    }
}
