private class Node {
    int id;
    int coords[2];
    int neighbors[0];
    0 => int marked;

    fun void init( int aid, int acoords[] ){
        aid => id;
        acoords @=> coords;
        <<< "initializing node",id,"with coordinates:",coords[0],",",coords[1] >>>;
    }

    fun void addNeighbors( int n[] ) {
        // add neighbor nodes to array
        for ( 0 => int i; i < n.cap(); i++ ) {
            neighbors << n[i];
        }
    }

    fun int[] getConn() {
        return neighbors;
    }

    fun void mark() {
        <<<"marking:", id>>>;
        1 => marked;
        // something to turn on an arduino here
    }

    fun void unMark() {
        0 => marked;
        // something to turn off an arudino here
    }
}

public class MapCrystal {
   
   int coords[27][2];
   Node nodes[27];
   Node queue[0];

   fun void init() {
        // initialize nodes
        getCoords();
        drawGraph();

        printNodes( nodes );
        printInts( coords );
   }

   fun void getCoords() {
        // create list of arudino coordinates
        // [ arduino column, order in column ]
        for ( 0 => int i; i < coords.cap(); i++ ) {
            for ( 0 => int j; j < 3; j++ ){
                coords << [i % 9, j];
            }
        }
   }

   fun void drawGraph() {
        // create computer representation of arduino array connections
        int id;
        int conn[0];
        
        for ( 0 => int i; i < 27; i ++ ) {
            // for each node, create an id and give it connections
            i => id;
            new int[0] @=> conn;

            if ( (i + 1) % 3 > 0 ) {
                conn << i + 1;
            }
            if ( (i + 3) % 9 > 0 ) {
                conn << i + 3;
            }
            if ( (i + 9) % 27 > 0) {
                conn << i + 9;
            }
        
            addNode( id, conn, coords[i] );
        }
    }

    fun void addNode( int nId, int nConn[], int nCoords[] ){
        // create a new node and add it to the array 
        nodes[nId].init( nId, nCoords );
        nodes[nId].addNeighbors( nConn );
    }

    fun void pulse( Node n ) {
        // BFS of the array
        Node neighbor;

        n.mark(); // mark node as visited

        // put unvisited neighbors on queue
        for ( 0 => int i; i < n.neighbors.cap(); i++ ) {
            nodes[ n.neighbors[i] ] @=> neighbor; 
            if ( neighbor.marked == 0 ) {
                queue << nodes[ neighbor.id ];
            }
        }

        // remove this node from queue
        Node nuQ[ queue.cap() - 1];
        for ( 1 => int i; i < queue.cap(); i++ ) {
            queue[i] @=> nuQ[i];
        }

        new Node[ nuQ.cap() ] @=> queue;
        for ( 0 => int i; i < nuQ.cap(); i++ ) {
            nuQ[i] @=> queue[i];
        }

        
        // if queue has members, pulse recursively
        if ( queue.cap() > 0 ) {
            pulse( queue[0] );
        } else {
            unmarkNodes(); // or, reset the nodes
        }
                
    }

    fun void unmarkNodes() {
        // unmark all nodes in crystal
        for ( 0 => int i; i < nodes.cap(); i++ ) {
            nodes[i].unMark();
        }
    }

    fun void printNodes( Node a[] ){
        "[" => string print;
        for ( 0 => int i; i < a.cap(); i++ ){
            " " + a[i].id + "," +=> print;
        }
        " ]" +=> print;
        <<< print, "\n">>>;
    }

    fun void printInts( int a[] ){
        "[" => string print;
        for ( 0 => int i; i < a.cap(); i++ ){
            " " + a[i] + "," +=> print;
        }
        " ]" +=> print;
        <<< print, "\n" >>>;
    }

    fun void printInts( int a[][] ) {
        "[" => string print;
        for ( 0 => int i; i < a.cap(); i++ ) {
            "\n[" +=> print;
            for ( 0 => int j; j < a[i].cap(); j++ ) {
                " " + a[i][j] + "," +=> print;
            }
            "]" +=> print;
        }
        "]" +=> print;
        <<< print >>>;
    }
}


//------------TESTS----------------
MapCrystal m;
m.init();
