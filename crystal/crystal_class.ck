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
			// 	geometric dimensions)
	float mutateVar; 
	dur pulseRate;

	// -- CRYSTAL
	float crystalArray[0][3]; // store [dimension][node coordinates]
	
	// -- FUNCTIONS
	public fun void run() {
		spork ~ autoGrow(); // just keep growing!
		spork ~ autoMutate();
		spork ~ autoNormalize();
	}

	public fun void autoGrow() {
		// container that loops grow function infinitely for sporking
		while ( true ) {
			grow();	
			pulseRate => now;
		}
	}

	public fun void autoMutate() {
		// container to loop mutation listener/mutater
		while( true ) {

			if ( usListen ) {
				// if the ultrasonics pick something up
				//	do a mutation
				spork ~ mutate();
			}
		}
	}

	public fun void autoNormalize() {
		// container to loop normalizer
		while( true ) {
			normalize();
		}		
	}

	public fun void grow() {
		// add new coordinates to the crystal

		// -- FUNC VARS
		// 1. generate new points
		newNodes( crystalArray ) @=> float newNodes[][];
		float nodalDist[ newNodes.cap() ];

		// 2. find distance of each point
		for ( 0 => int i; i < newNodes.cap(); i++ ) {
			hDist( newNodes[i] ) @=> nodalDist[i];	
		}

		// 3. select point with shortest distance
		shortest( nodalDist ) => int least; 
		
		// 4. add those coordinates to the crystal array
		addNode(); // add new blank node to the crystal
		for ( 0 => int i; i < newNodes[least].cap(); i++ ) {

		}
	}

	public fun void mutate() {
		// mutate the various variables
	}

	private fun void normalize() {

	}
	private fun float hDist( float newCoord[] ) {
		float totSum; // distance of new point to each existing
				// point

		float tempSum; // distance of new point to a single 
				// existing point 

		// Cycle through each existing point in crystal 
		for ( 0 => int i; i < crystalArray.cap(); i++ ) {

			// loop through the specific coordinates of each crystal node
			for ( 0 => int j; j < crystalArray[j].cap(); j++ ){
				// get difference in each coordinate
				Math.fabs( newCoord[j] - crystalArray[i][j] ) +=> tempSum;
			} 			

			// add temporary sum to the total sum
			tempSum +=> totSum;
		}

		// return the total distance of this node	
		return totSum;
	}
							
	private fun float[][] newNodes( float crystal[][] ) {
		// generate coordinates for new nodes based on existing nodes in the 
		//  crystal
	}
	
	private fun int shortest( float nodeDists[] ) {
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
		//	distance
		return leastInd;
	}

	private fun void addNode() {
		// add blank node to the crystal array
	}
}


