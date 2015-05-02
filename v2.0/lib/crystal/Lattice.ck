// Lattice.ck
// Implementation of James Tenney's cyrstal growth formula for harmonic space
// Freq Limits: 3000 Hz - 12000 Hz
// Author: Danny Clarke

public class Lattice 
{
    3 => int numDimensions;
    [2, 3, 5] @=> int dimNumbers[];
    float vals[0];
    [3000.0, 12000.0] @=> float lims[];
    
    // -------------------------------MAIN FUNCTIONS--------------------------
    /*
    * set( number_of_dimensions, dimensional_spaces )
    * sets the number of dimensions the lattice will have
    * and the overtone space of those dimensions
    */
    fun void set( int dimNums[] ) 
    {
        dimNums.size() => numDimensions;
        dimNumbers.size(numDimensions);
        for( int i; i < numDimensions; i++ ) {
            dimNums[i] => dimNumbers[i];
        }
    }

    /*
    * generate( fundamental, size )
    * take a fundamental and generate a lattice with "size" points
    * using the dimensional information setup using Lattice.set()
    */
    fun float[] generate( float fundamental, int size)
    {
        float coords[0][0];             // array of coordinates
        float new_coord[numDimensions]; // potential new coordinate
        float best[numDimensions];      // current best choice
        float test;
        getDist(coords, best) => float shortest_dist; // distance of the current best
        vals.size(size);                // resize our vals array

        while(coords.size() < size) {
            999 => shortest_dist;

            // for each coordinate:
            for(int i; i < coords.size(); i++ ) {
                // for each node, try expanding in each dimension
                copy(coords[i]) @=> new_coord;
                for(int j; j < new_coord.size(); j++ ) {
                    1 +=> new_coord[j];

                    // see if we already have that coordinate
                    if(!in(coords, new_coord)) {
                        // see if it is closer than our current best
                        getDist(coords, new_coord) => test;
                        if(test<= shortest_dist) {
                            test => shortest_dist;
                            copy(new_coord) @=> best;
                        }
                    }
                    1.0 -=> new_coord[j];
                }
            }

            coords.size(coords.size() + 1);
            copy(best) @=> coords[coords.size() - 1];
        }	

        // convert our coordinates to freqs
        for(int i; i < coords.size(); i++)    
            coordToFreq(coords[i], fundamental) @=> vals[i];

        NULL @=> coords;
        NULL @=> new_coord;
        NULL @=> best;
        return vals;
    }

    // ---------------------SUPPORT-----------------------

    /*
    * coordToFreq( coordinate, fundamental )
    * convert a given coordinate into a frequency value
    */
    fun float coordToFreq(float coord[], float fund)
    { 
        [1.0, 0.5] @=> float mod[];
        1.0 => float sum;
        for(int i; i < coord.size(); i++ )
            Math.pow(dimNumbers[i], coord[i]) * sum => sum;
        
        Math.fabs(sum * fund) * mod[Math.random2(0,1)] => float out;
        limit(out) => out;
        return out;
    }

    /*
    * scale( freqeuncy )
    * take a frequency and put it inside some bounds by adjusting
    * by octave
    * these bounds are the physical limits of the piezo speakers
    */
    fun float limit(float start_freq)
    {
        while(start_freq < lims[0]) 2.0 *=> start_freq;
        while(start_freq > lims[1]) 0.5 *=> start_freq;
        return start_freq;
    }

    /*
    * getDist( existing_coordinates, new_coordinate )
    * find the distance of a  coordinate from other coordinates
    */
    fun float getDist( float coords[][], float coord[] )
    {
        float dist;

        for(int i; i < coords.size(); i++ ) {
            for(int j; j < coords[i].size(); j++ ) {
                coord[j] - coords[i][j] +=> dist;
            }
        }
        return dist;
    }

    /*
    * in( existing_coordinates, new_coordinates )
    * check if a coordinate already exists
    */
    fun int in( float coords[][], float coord[] )
    {
        int sum;
        for(int i; i < coords.size(); i++ ) {
            0 => sum;
            for(int j; j < coords[i].size(); j++ ) {
                if(coords[i][j] == coord[j])
                    1 +=> sum;
            }
            if(sum == numDimensions)
                return 1;
        }
        return 0;
    }

    /*
    * copy( coordinate )
    * return a copy of a coordinate
    * this is to avoid problems with ChucK's handling of references
    */
    fun float[] copy(float a[])
    {
        float out[a.size()];
        for(int i; i < a.size(); i++)
            a[i] => out[i];
        return out;
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

