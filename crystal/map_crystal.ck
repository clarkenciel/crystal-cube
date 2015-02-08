private class Node {
    int id;
    int coords[2];
    int neighbors[0];
    0 => int marked;

    OscOut out;
    out.dest( "localhost", 7000 );

    fun void init( int aid, int acoords[] ){
        aid => id;
        acoords @=> coords;
        //<<< "initializing node",id,"with coordinates:",coords[0],",",coords[1] >>>;
        
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
        ///<<< "\t\t\t\t\t\t\tMARKING NODE:",id >>>;
        1 => marked;

        out.start( "/nodes/" + "0" + id + ", i" );
        1 => out.add;
        out.send();
        // something to turn on an arduino here
    }

    fun void unMark() {
        0 => marked;
        out.start( "/nodes/" + "0" + id + ", i" );
        0 => out.add;
        out.send();
        // something to turn off an arudino here
    }
}

public class MapCrystal {
   
   int coords[27][2];
   Node nodes[27];
   Node queue[0];
   TCrystal tc;
   Port port;
   int unQ[0];
   // some code here using Port.ck

   // -----------------------SETUP---------------------
   fun void init() {
        // initialize nodes
        getCoords();
        drawGraph();

        //printNodes( nodes );
        //printInts( coords );

        port.init();
        2::second => now;
   }

   fun void getCoords() {
        // create list of arudino coordinates
        // [ arduino column, order in column ]
        float j;
        for ( 0 => int i; i < coords.cap(); i++ ) {
            Math.floor( i / 9 ) => j;

            i % 9 @=> coords[i][0];
            j $ int @=> coords[i][1];
        }
   }

   fun void drawGraph() {
        // create computer representation of arduino array connections
        int id;
        int conn[3];
        
        for ( 0 => int i; i < 27; i ++ ) {
            // for each node, create an id and give it connections
            i => id;
            conn.clear();

            if ( (i + 1) % 3 > 0 && i + 1 < 27  ) {
                conn << i + 1;
                nodes[i + 1].neighbors << id;
            }
            if ( (i + 3) % 9 > 0 && i + 3 < 27 ) {
                conn << i + 3;
                nodes[i + 3].neighbors << id;
            }
            if ( (i + 9) < 27 ) {
                conn << i + 9;
                nodes[i + 9].neighbors << id;
            }

            ///<<< "giving node"+id+"neighbors"+(i+1)+(i+3)+(i+9) >>>;
        
            addNode( id, conn, coords[i] );
        }
    }

    fun void addNode( int nId, int nConn[], int nCoords[] ){
        // create a new node and add it to the array 
        nodes[nId].init( nId, nCoords );
        nodes[nId].addNeighbors( nConn );
    }

    // ---------------------SOUND PATTERNS----------------
    fun void pulse( 
        int id, 
        dur pause,
        float mutater, 
        float dimensions[],
        int numDimensions,
        float baseFreq,
        float glisser) {
        ///<<< "\t\t\t\tBFS Starting @:"+id >>>;

        // BFS of the array
        Node neighbor;
        nodes[id] @=> Node n;

        nodes[id].mark(); // mark node as visited
        unQ << id;
        
        // safety for first run
        // also, init tenney crystal
        if ( queue.cap() < 1 ) {
            queue << n;
            tc.init( mutater, dimensions, numDimensions, baseFreq ); 
        }

        // grow the crystal by one step and send the frequency
        //nodes[id].play( tc.lastNote(1) );
        tc.lastNote(0) + glisser => float nFreq;
        port.note( nodes[id].coords[0] + 1, nodes[id].coords[1],nFreq);
        //<<< nFreq >>>;
        //<<< "port coords: [",nodes[id].coords[0],",",nodes[id].coords[1],"]">>>;

        // put unvisited neighbors on queue
        for ( 0 => int i; i < n.neighbors.cap(); i++ ) {
            if ( nodes[ n.neighbors[i] ].marked == 0 && isIn( nodes[n.neighbors[i]].id, queue ) == 0 ) {
                queue << nodes[ nodes[ n.neighbors[i] ].id ];
            }
        }

        // remove this node from queue
        for( 1 => int i; i < queue.cap(); i++ ) {
            queue[i] @=> queue[i-1];
        }
        queue.size(queue.cap() - 1);

        // if queue has members, pulse recursively
        if ( queue.cap() > 0 ) {
            pause => now; // wait
            pulse( queue[0].id, pause, mutater, dimensions, numDimensions, baseFreq, glisser);
        } else {
            unmarkNodes(); // or, reset the nodes
        }
                
    }

    fun void inOrder( int startId, int dir, dur pulse ) {
        ///<<< "\t\t\tIn-order search starting @:" + startId >>>;
        int place;

        for( startId => int i; i < nodes.cap(); dir +=> i ) {
            ( startId + i) % 27 => place;
            nodes[ place ].mark();
            if( nodes[ (place + 25) % 27 ].marked == 1 ) {
                nodes[ (place + 25) % 27 ].unMark();
            }
            pulse => now;
        }
    }

    fun void DFS( int id, 
        dur pulse, 
        float mutater,
        float dimensions[],
        int numDimensions,
        float baseFreq ) {

        0 => int check;

        nodes[id].mark(); // mark node
        unQ << id;
        tc.init( mutater, dimensions, numDimensions, baseFreq ); 

        tc.lastNote(0) => float nFreq;
        port.note( nodes[id].coords[0] + 1, nodes[id].coords[1],nFreq);

        for( 0 => int i; i < nodes[id].neighbors.cap(); i++ ) {
            // loop through neighbors, calling DFS recursively
            if( nodes[ nodes[id].neighbors[i] ].marked == 0 ) {
                pulse => now;
                DFS( nodes[id].neighbors[i], pulse, check++ );
            }
        }

        unPulse();
    }

    // overload above
    fun void DFS( int id, dur pulse, int check ) {
        nodes[id].mark(); // mark node
        unQ << id;

        tc.lastNote(0) => float nFreq;
        port.note( nodes[id].coords[0] + 1, nodes[id].coords[1],nFreq);

        for( 0 => int i; i < nodes[id].neighbors.cap(); i++ ) {
            // loop through neighbors, calling DFS recursively
            if( nodes[ nodes[id].neighbors[i] ].marked == 0 ) {
                pulse => now;
                DFS( nodes[id].neighbors[i], pulse, check++ );
            }
        }
    }

    fun void unPulse() {
        for( 0 => int i; i < unQ.cap(); i++ ) {
            nodes[ unQ[i] ].unMark();
            port.note( nodes[ unQ[i] ].coords[0] + 1, nodes[ unQ[i] ].coords[1], 0 );
        }
    }

    // ------------------------SUPPORT FUNCS-----------------

    fun void unmarkNodes() {
        // unmark all nodes in crystal
        for ( 0 => int i; i < nodes.cap(); i++ ) {
            nodes[i].unMark();
            port.note(nodes[i].coords[0] + 1, nodes[i].coords[1], 0);
        }
    }

    fun int isIn( int n, Node a[] ){
        // check if val is in array (JUST FOR QUEUE)
        0 => int check;

        for ( 0 => int i; i < a.cap(); i++ ) {
            if ( n == a[i].id ) {
                1 => check;
            }
        }
        return check;
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
/*
MapCrystal m;
m.init();
for ( 0 => int i; i < 27; i ++ ) {
    <<< "new pulse" >>>;
    m.pulse( i );
    second => now;
}*/
