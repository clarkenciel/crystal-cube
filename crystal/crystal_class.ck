// TODO: try this with associative arrays -> dynamic adding

/* James Tenney Harmonic Space Crystal Implementation
/* Author: Danny Clarke, with copious thanks to Peter Nelson
/* Date: 12/17/2014

/* Explanation:
        s( dimension 1 expansion ) = log2( dim1Num^sumDim1Vals );
        s( dimension 2 expansion ) = log2( dim1Num^ );
        
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
        float dim[][]; // pitch dimensions of cube (separate from
                        //      geometric dimensions)
        float mutateVar; 
        20::ms => dur pulseRate;
        2 => int dimensions; // number of dimensions that we care about

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

        fun void grow() {
                // add new coordinates to the crystal

                // -- FUNC VARS
                // 1. generate new points
                newNodes( crystalArray ) @=> float potential[][];
                 //<<< "new nodes generated" >>>;
                float nodalDist[ potential.cap() ];

                // 2. find distance of each point
                for ( 0 => int i; i < potential.cap(); i++ ) {
                        hDist( potential[i] ) @=> nodalDist[i]; 
            
                }
                //<<< "distances acquired" >>>;

                // 3. select point with shortest distance
                shortest( nodalDist ) => int least; 
                <<< least >>>;
                // 4. add those coordinates to the crystal array
                addNode(); // add new blank node to the crystal
                
            for ( 0 => int i; i < potential[least].cap(); i++ ) {
                    potential[least][i] @=> crystalArray[ crystalArray.cap() -1 ][i];
                    <<< "New Node:", crystalArray[ crystalArray.cap() - 1][i] >>>;
                    ms => now;
            }
        }

        fun void mutate() {
                // mutate the various variables
                Math.random2f(1.0, 10.0) => mutateVar;
        }

        fun void normalize() {
        // gradually move back to a normal state
        }
    
        fun float hDist( float newCoord[] ) {
            float totSum; // distance of new point to each existing
                                // point

            float tempSum; // distance of new point to a single 
                                // existing point 

            // Cycle through each existing point in crystal 
            for ( 0 => int i; i < crystalArray.cap(); i++ ) {

                // loop through the specific coordinates of each crystal node
                for ( 0 => int j; j < crystalArray[i].cap(); j++ ){
                    // get difference in each coordinate
                    Math.fabs( newCoord[j] - crystalArray[i][j] ) +=> tempSum;
                    //<<< "temp sum:", tempSum, "\n\tj:", j >>>;
                }                          

                // add temporary sum to the total sum
                tempSum +=> totSum;
                //<<< "totSum:",totSum>>>;
            }

            // return the total distance of this node       
            return totSum;
        }
                                                        
        fun void newNodes() {
            // generate coordinates for new nodes based on existing nodes in the 
            //  crystal
            float node[dimensions];
            float distance;
            float store[dimensions];
 
            for ( 0 => int i; i < crystal.cap(); i++ ) {
                for ( 0 => int j; j < dimensions; j++ ) {
                    makeNode( crystal[i] ) @=> node;                    
                    
                    if ( !doesExist( node ) && hDist( node ) < dist ) {
                        node @=> store;
                    }
                }
            }                  
            
            addNode();
            node @=> crystal[ crystal.cap() - 1 ];
                
        }
        
        fun int shortest( float nodeDists[] ) {
                // find new node with shortest distance to existing crystal
                nodeDists[0] => float leastVal;
                0 => int leastInd;

                for ( 0 => int i; i < nodeDists.cap(); i++ ) {
                        if ( nodeDists[i] < leastVal ) {
                                nodeDists[i] => leastVal;
                                i => leastInd;
                        }                                       
                } 

                // return the index of the new node with the shortest
                //      distance
                return leastInd;
        }

        fun void addNode() {
                // add blank node to the crystal array
                new float[ crystalArray.cap() + 1 ][3] @=> float tempArr[][];
                
                for ( 0 => int i; i < crystalArray.cap(); i++ ) {
                        for ( 0 => int j; j < crystalArray[i].cap(); j++ ) {
                                crystalArray[i][j] @=> tempArr[i][j];
                        }
                }
        
                tempArr @=> crystalArray;
        }

    fun int doesExist( float node[] ) {

    }

    fun float[] makeNode( float node[], int dimension ) {

    } 
}


