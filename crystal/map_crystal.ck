public class MapCrystal {
    // MEMBER VARIABLES
    int piezos[][]; // representation of physical piezo array 
    TCrystal tc; // Tenney crystal holding pitch info
    int shape[][]; // representation of the shape

    // MEMBER FUNCTIONS
    fun void init( int numCols, int numPiezos ) {
        float tempArr[numCols][numPiezos];

        for ( 0 => int i; i < numCols; i++ ) {
            for ( 0 => int j; j < numPiezos; j++ ) {
                j => tempArr[i][j];
            }
        }
    }

    // ----TRANSFORMATION FUNCTIONS
    // -----These can be combined to accomplish more interesting transformations 
    fun void translate( string axis, int amt ) {
        // Increment or decrement one coordinate class (x,y,z) for
        //  all coordinates in crystal

    }

    fun void rotate( string axis, int amt ) {
        // Increment or decrement one coordinate class (x,y,z) for
        //  two coordinates in crystal

    }

    fun void moveOrigin() {
        // change the origin of the shape to a different coordinate in the shape
        //  This basically controls the order in which piezos receive pitches and
        //  so it isn't a transformation of the shape itself

    } 

    // ----PITCH FUNCTIONS 
    fun void send( float freq, int coords[][] ){
        // send a pitch to a certain coordinate
        

    }
}
