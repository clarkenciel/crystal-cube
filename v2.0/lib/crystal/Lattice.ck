// Lattice.ck
// Implementation of James Tenney's cyrstal growth formula for harmonic space
// Freq Limits: 3000 Hz - 12000 Hz
// Author: Danny Clarke

public class Lattice 
{
    3 => private int numDimensions;
    [2, 3, 5] @=> private float dimNumbers[];
    private float vals[0];
    
    // -------------------------------MAIN FUNCTIONS--------------------------
    /*
    * set( number_of_dimensions, dimensional_spaces )
    * sets the number of dimensions the lattice will have
    * and the overtone space of those dimensions
    */
    fun void set( int numD, int dimNums[] ) 
    {
        numD => numDimensions;
        dimNumbers.size(numD);
        for( int i; i < numDimensions; i++ ) {
            dimNums[i] => dimNumbers[i];
        }
    }

    /*
    * generate( fundamental, size )
    * take a fundamental and generate a lattice with "size" points
    * using the dimensional information setup using Lattice.set()
    */
    fun float[] generate(fundamental, size)
    {
        float coords[size][numDimensions];  // array of coordinates
        vals.size(size);                    // resize our vals array 
        
        for(int i; i < coords.size; i++) 
            coordToFreq(coords[i]) @=> vals[i];

        NULL @=> coords;
        return vals;
    }

    // ---------------------SUPPORT-----------------------

    /*
    * coordToFreq( coordinate, fundamental )
    * convert a given coordinate into a frequency value
    */
    fun float coordToFreq(coord, fund)
    {
        float freq;

        return freq;
    }

    /*
    * scale( freqeuncy )
    * take a frequency and put it inside some bounds by adjusting
    * by octave
    * these bounds are the physical limits of the piezo speakers
    */
    fun float scale(start_freq)
    {
        while(start_freq < 3000.0) start_freq * 2;
        while(start_freq > 12000.0) start_freq * 0.5;
        return start_freq;
    }

    /*
    * val( index )
    * return the value stored in vals[] at the given index
    */
    fun float val( int idx ) 
    {
        return vals[idx];
    }

    /*
    * clear()
    * clear the vals array
    */
    fun void clear() 
    {
        vals.size(0);
    }
}
