/* James Tenney Harmonic Space Crystal Implementation
/* Author: Danny Clarke, with copious thanks to Peter Nelson
/* Developed in collaboration with Eric Heep at CalArts
/* Date: 12/29/2014

/* Explanation:
    You define the prime numbers that comprise your three dimensions for growth.
    Each pitch in the crystal is defined by a three-value coordinate that 
    represents the exponents applied to each of those dimensions.
    1. Generate potential new coordinates
    2. Find the potential coordinate that has the shortest "manhattan" distance
        and which doesn't already exist in the crystal. Add it to the crystal
    To get frequency of a coordinate: apply the coordinate values to the
    dimension values as exponents, then multiply those results together and
    take log2. Multiply that result by the fundamental frequency.
*/
// TODO: troubleshoot this using  dimensions == 1

public class TCrystal  {
    // -- Variables
    [2.0, 3.0, 5.0] @=> float dim[]; // pitch dimensions of cube (separate from
                        //      geometric dimensions)
    1.0 => float mutateVar; 
    0::ms => dur pulseRate;
    3 => int dimensions; // number of dimensions that we care about
    200 => float baseFreq;

    // -- CRYSTAL
    float crystalArray[1][dimensions]; // store [dimension][node coordinates]
        
    // -- FUNCTIONS
    fun void init( float mVar, dur pR, float d[], int numD, float bFreq ) {
        mVar => mutateVar;
        pR => pulseRate;
        d @=> dim;
        numD => dimensions;
        bFreq => baseFreq;
        new float[1][dimensions] @=> crystalArray;
        
        "Crystal created with:\n" => string msg;
        "\tMutation Var: " + mutateVar +=> msg;
        "\tPulse Rate: " + (pulseRate / ms) +=> msg;
        "\t# of dimensions: " + dimensions +=> msg;
        "\tDimensions: " +=> msg;
        for ( 0 => int i; i < dim.cap(); i++ ) {
            dim[i] + ", " +=> msg;
        }
        "\n\tBase Frequency: " + baseFreq +=> msg;
        <<< msg >>>;
    }
        
    fun float lastNote( int print ) {
        // Grow the crystal by a node and then
        // access a freq value of the last-added node in crystal
        float result;
        crystalArray.cap() - 1 => int lastInd;

        grow( print );
        pulseRate => now;
        getFreq( crystalArray[lastInd] ) => result;

        return result;
    } 

    fun void grow(int print) {
        // Add a new node to the crystal
        float node[dimensions];
        999999999999.0 => float distance;
        float store[0];

        for ( 0 => int i; i < crystalArray.cap(); i++ ) {
            for ( 0 => int j; j < dimensions; j++ ) {
                new float[dimensions] @=> node;
                makeNode( crystalArray[i] , j ) @=> node;                    
                // store the node if it isn't already in crystal and
                //  is shortest so far
                //<<< "distance:",distance >>>;
                //<<< "Node coords:" >>>;
                //printArr( node );
                //<<< "node distance:", hDist( node ) >>>;  

                if ( hDist( node ) < distance ) {
                    if ( doesExist( node ) == 0 ) {
                        hDist( node ) => distance; 
                        node @=> store;
                             
                        //<<< "new node coords:\n" >>>;
                        //printArr( store );                    
                        //<<< "New Node Distance:", hDist( node ), "\n" >>>; 
                    }
                }
                //pulseRate => now; 
            }
        }                  
        
        // Add the new node to the blank node in the crystal
        if ( store.cap() > 0 ) {
            // Add a new empty node to the crystal
            addNode();

            //<<< "adding store to crystal" >>>;
            store @=> crystalArray[ crystalArray.cap() - 1 ];     
        }
        
        // print the crystal
        if ( print == 1 ) {
            printCrystal();
        }
    }
    
    fun float hDist( float newCoord[] ) {
        1 => float totSum; // distance of new point to each existing point

        float tempSum[dimensions]; // distance of new point to a single existing point 

        // Cycle through each existing point in crystal 
        for ( 0 => int i; i < crystalArray.cap(); i++ ) {

            // loop through the specific coordinates of each crystal node
            for ( 0 => int j; j < dimensions; j++ ){
                    // get difference in each coordinate
                Math.fabs( newCoord[j] - crystalArray[i][j] ) +=> tempSum[j] ;
                //<<< "temp sum:", tempSum, "\n\tj:", j >>>;
            }                          
        }
            
        for ( 0 => int i; i < tempSum.cap(); i++ ) {
            Math.pow( dim[i], tempSum[i] ) * totSum => totSum;
            //<<< "Total Sum:", totSum >>>;
        }

        Math.log2( totSum ) => totSum; 

        // return the total distance of this node       
        return totSum;
    }                                           
       
    fun void addNode() {
        // add blank node to the crystal array: create longer copy
        new float[ crystalArray.cap() + 1 ][dimensions] @=> float tempArr[][];
                
        for ( 0 => int i; i < crystalArray.cap(); i++ ) {
            for ( 0 => int j; j < crystalArray[i].cap(); j++ ) {
                crystalArray[i][j] @=> tempArr[i][j];
            }
            //<<< "Adding to Crystal:" >>>;
            //printArr(tempArr[i]);
        }
         
        tempArr @=> crystalArray;
    }

    fun int doesExist( float node[] ) {
        // Loop through each node in crystal and check each of it's
        //  coords against the input node. There is a match if the
        //  match sum == #dimensions.
        0 => int testSum;
        0 => int check;
        for ( 0 => int i; i < crystalArray.cap(); i++ ) {
            0 => testSum;
            for ( 0 => int j; j < dimensions; j++ ) {
                if ( node[j] == crystalArray[i][j] ) {
                    testSum++;
                    //<<< "node:",node[j],"crystal:",crystalArray[i][j] >>>;
                    //<<< "testSum",testSum>>>;
                }
            }
            if ( testSum == dimensions ) {
                1 => check;
            }
        } 
        //<<< "Check",check >>>;
        return check;
    }

    fun float[] makeNode( float node[], int dimension ) {
        // Create a node from an existing node that is expanded
        //  in one dimension 
        float result[];
        new float[dimensions] @=> result;
        [-1.0, 1.0] @=> float choice[];

        for ( 0 => int i; i < node.cap(); i++ ) {
            node[i] @=> result[i];
        }

        choice[ Math.random2(0, 1) ] * (mutateVar + result[dimension] ) @=> result[dimension];
        return result; 
    } 
    
    fun float getFreq( float node[] ) {
        // use this function in "main" program function
        1 => float sum;
        for ( 0 => int i; i < node.cap(); i++ ) {
            Math.pow( dim[i], node[i] ) * sum => sum;
            //<<< "sum: ", sum >>>;
        }
        return Math.fabs( sum * baseFreq );
    }

    fun void reset() {
        // reset the crystal
        new float[1][dimensions] @=> crystalArray; 
    }

    fun void printCrystal() {
        string print;
        "Current Crystal Coordinates: \n" => print;
        for ( 0 => int i; i < crystalArray.cap(); i++ ) {
            "\t[ " +=> print;
            for ( 0 => int j; j < dimensions; j++ ) {
              crystalArray[i][j] + ", " +=> print;
            }
            "]\n" +=> print; 
        }
        "\n" +=> print;
        <<< print >>>;
    }

    fun void printArr( float arr[] ) {
        string print;
        "\n\t[ " +=> print;
        for ( 0 => int i; i < arr.cap(); i++ ) {
           arr[i] + ", " +=> print;
        }
        "]" +=> print;
        <<< print >>>;
    } 
    
    fun void printArr( int arr[] ) {
        string print;
        "\n\t[ " +=> print;
        for ( 0 => int i; i < arr.cap(); i++ ) {
           arr[i] + ", " +=> print;
        }
        "]" +=> print;
        <<< print >>>;
    }
}
