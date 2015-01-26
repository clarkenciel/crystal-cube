import oscP5.*;

// ----------------CRYSTAL CLASS----------------
class Crystal {
  int[] queue;
  Node[] points;
  int[] tempC;
  int[] undoQ;
  
  Crystal( int numNodes ) { // constructor
    points = new Node[numNodes];
    queue = new int[0];
    undoQ = new int[0];
    tempC = new int[3];
    int x, y, z;
    
    // set the nodes up with coordinates
    for ( int i = 0; i < numNodes; i++ ) {
      x = (i % 9) * -20; // width
      y = (floor( i / 9 ) ) * 50; // height
      z = floor( i / 3 ) % 3 * 50; // depth
      
      // constructing coordinate array
      tempC[0] = x + 350;
      tempC[1] = y + 200;
      tempC[2] = z;
      
      // adding coordinates and neighbors to point
      points[i] = new Node( i, tempC );
      makeNeighbors( points[i] );
      
      // resetting coords
      tempC = new int[3];
    }
  }
  
  // breadth-first search  
  void bfs( int nId ) {
    println( nId );
    if( queue.length < 1) {
      queue = append(queue, points[nId].id);
    }
    println( "marking node: " + nId );
    points[nId].mark(); // mark node as visited    
    
    for( int i = 0; i < points[nId].neighbors.length; i++ ) {
      // cycle through point's neighbors
      if( !points[ points[nId].neighbors[i] ].marked && !onQ(points[nId].neighbors[i]) ) {
        // if neighbor is unmarked and not already on the queue, add it
        queue = append( queue, points[ points[nId].neighbors[i] ].id );
      }
    }
    
    // remove first item from queue
    println( "queue length: " + queue.length );
    removeFirst();
  }
  
  // find neighbors for node  
  void makeNeighbors( Node n ) {
    int[] tempN = new int[0];
    if( (n.id + 1) % 3 != 0 ) {
      tempN = append( tempN, n.id + 1 );
    }
    
    if( (n.id + 3) < 9 ) {
      tempN = append( tempN, n.id + 3 );
    }
    
    if( (n.id + 9) < 27 ) {
      tempN = append( tempN, n.id + 9 );
    }
    
    n.addNeighbor( tempN );    
  }

  // show the cube  
  void show() { // show all nodes
    for ( int i = 0; i < points.length; i++ ) {
      points[i].show();
    }
  }
  
  // see if a node ide is already on queue
  boolean onQ( int nId ) {
    boolean check = false;
    for( int i = 0; i < queue.length; i++ ) {
      if( queue[i] == nId ) {
       check = true;
      }
    }
    return check; 
  }
  
  // remove first element in array
  void removeFirst(){
    int[] output = new int[0];
    for( int i = 1; i < queue.length; i++ ) {
      output = append( output, queue[i] );
    }
    
    queue = new int[0];
    for( int i = 0; i < output.length; i++ ) {
      queue = append( queue, output[i]);
    }
  }
}

// -----------------NODE CLASS --------------
class Node {
  int id;
  int[] coords; // x,y,z coordinates
  int[] neighbors;// ids of neighbors
  boolean marked;
  color c;
  int size;

  Node( int aid, int[] acoords ) { // constructor
    id = aid;
    coords = new int[0];
    neighbors = new int[0];
    for( int i = 0; i < acoords.length; i++ ) {
      coords = append( coords, acoords[i] );
    }
    
    marked = false;
    c = color( 0 ); // start with color as black
    size = 5;
  }
  
  void addNeighbor( int[] aneigh ) {
    neighbors = aneigh;
  }

  void mark() { // mark a node as visited or not
//println( "node:" + id );
    if ( marked ) {
      marked = false;
      size = 5;
      c = color( 0 );
    } else {
      marked = true;
      size = 5;
      c = color( 255   );
    }
  }

  void show() {
    noStroke();
    fill( c );
    translate( coords[0], coords[1], coords[2] );
    sphere( size );
    
    translate( -coords[0], -coords[1], -coords[2] ); //reset translation
  }
}
