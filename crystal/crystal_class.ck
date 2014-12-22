// TODO: try this with associative arrays -> dynamic adding

/* James Tenney Harmonic Space Crystal Implementation
/* Author: Danny Clarke, with copious thanks to Peter Nelson
/* Date: 12/17/2014

/* Explanation:
        taxi distances! for all new points! also think of them not as
        ratios, but as points on a plane where the coordinates = 
        the exponents for the different dimensional #s yay peter!!
        
        So:
        1. Find the coordinates for each potential new point
        2. Find the taxi distance for each of those new points
        3. Choose the coordinate with the least taxi distance
        4. Add that coordinate to the array
        5. Repeat
*/
public class TCrystal  {
        // -- Variables
        [2.0, 3.0, 5.0] @=> float dim[]; // pitch dimensions of cube (separate from
                        //      geometric dimensions)
        float mutateVar; 
        20::ms => dur pulseRate;
        3 => int dimensions; // number of dimensions that we care about

        // -- CRYSTAL
        float crystalArray[1][3]; // store [dimension][node coordinates]
        
        // -- FUNCTIONS
        fun void run() {
                spork ~ autoGrow(); // just keep growing!
                //spork ~ autoMutate();
                spork ~ autoNormalize();
        }

        fun void autoGrow() {
                // container that loops grow function infinitely for sporking
                while ( true ) {
                        grow(); 
                        pulseRate => now;
                }
        }
        /*
        fun void autoMutate() {
                // container to loop mutation listener/mutater
                while( true ) {

                        if ( usListen ) {
                                // if the ultrasonics pick something up
                                //      do a mutation
                                spork ~ mutate();
                        }
                }
        }
        */
        fun void autoNormalize() {
                // container to loop normalizer
                while( true ) {
                        normalize();
                }               
        }

       fun void mutate() {
            // mutate the various variables
            Math.random2f(1.0, 10.0) => mutateVar;
        }

        fun void normalize() {
        // gradually move back to a normal state
        }
 
        fun void grow() {
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
                                 
                        <<< "new node coords:\n" >>>;
                        printArr( store );                    
                        <<< "New Node Distance:", hDist( node ), "\n" >>>; 
                    }
                    }
                    pulseRate => now; 
                }
            }                  
            
            // Add a new empty node to the crystal
            addNode();
            
            // Add the new node to the blank node in the crystal
            if ( store.cap() > 0 ) {
                <<< "adding store to crystal" >>>;
                store @=> crystalArray[ crystalArray.cap() - 1 ];     
            }
            
            // print the crystal
            printCrystal();
        }
    
     fun float hDist( float newCoord[] ) {
        1 => float totSum; // distance of new point to each existing
                                // point

        float tempSum[dimensions]; // distance of new point to a single 
                            // existing point 

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
            <<< "Total Sum:", totSum >>>;
        }

        Math.log2( totSum ) => totSum; 

        // return the total distance of this node       
        return totSum;
    }
                                                        
       
    fun void addNode() {
        // add blank node to the crystal array: create longer copy
        new float[ crystalArray.cap() + 1 ][3] @=> float tempArr[][];
                
        for ( 0 => int i; i < crystalArray.cap(); i++ ) {
            for ( 0 => int j; j < crystalArray[i].cap(); j++ ) {
                crystalArray[i][j] @=> tempArr[i][j];
            }
            <<< "Adding to Crystal:" >>>;
            printArr(tempArr[i]);
        }
         
        tempArr @=> crystalArray;
    }

    fun int doesExist( float node[] ) {
        // Loop through each node in crystal and check each of it's
        //  coords against the input node. There is a match if the
        //  match sum == 3.
        0 => int testSum;
        0 => int check;
        for ( 0 => int i; i < crystalArray.cap(); i++ ) {
            0 => testSum;
            for ( 0 => int j; j < dimensions; j++ ) {
                if ( node[j] == crystalArray[i][j] ) {
                    testSum++;
                    <<< "node:",node[j],"crystal:",crystalArray[i][j] >>>;
                    <<< "testSum",testSum>>>;
                }
            }
            if ( testSum == dimensions ) {
                1 => check;
            }
        } 
        <<< "Check",check >>>;
        return check;
    }

    fun float[] makeNode( float node[], int dimension ) {
        // Create a node from an existing node that is expanded
        //  in one dimension 
        float result[];
        new float[dimensions] @=> result;

        for ( 0 => int i; i < node.cap(); i++ ) {
            node[i] @=> result[i];
        }

        1.0 + result[dimension] @=> result[dimension];
        return result; 
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


