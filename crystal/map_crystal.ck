private class Node {
    int id;
    int coords[2];
    int neighbors[0];
    0 => int marked;

    //OscOut out;
    //out.dest( "localhost", 7000 );

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

        //out.start( "/nodes/" + "0" + id + ", i" );
        //1 => out.add;
        //out.send();
        // something to turn on an arduino here
    }

    fun void unMark() {
        0 => marked;
        //out.start( "/nodes/" + "0" + id + ", i" );
        //0 => out.add;
        //out.send();
        // something to turn off an arudino here
    }
}

public class MapCrystal {
   
   int coords[27][2];
   int special;
   Node nodes[27];
   Node queue[0];
   TCrystal tc;
   Port port;
   int unQ[0];
   dur pulse;
   float gliss[4];
   1.0 => float active;
   2 => int offset;

   // -----------------------SETUP---------------------
   fun void init( dur p ) {
        // initialize nodes
        getCoords();
        drawGraph();
        p => pulse;
        
        for( 0 => int i; i < gliss.cap(); i ++ ) {
            0.0 @=> gliss[i];
        }
        <<< "kicking off port","" >>>;
        port.init();
        <<< "port cleared","" >>>;
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
    fun void BFS( int id ) {
        ///<<< "\t\t\t\tBFS Starting @:"+id >>>;

        // BFS of the array
        Node neighbor;
        nodes[id] @=> Node n;

        nodes[id].mark(); // mark node as visited
        //<<< "Node", id, "Marked" >>>;
        unQ << id;
        
        // safety for first run
        // also, init tenney crystal
        if ( queue.cap() < 1 ) {
            //<<< "New TC" >>>;
            queue << n;
            tc.init(); 
        }
        //<<< "sending pitch" >>>;

        // grow the crystal by one step and send the frequency
        tc.lastNote(0) => float nFreq;
        float g;
        if( id == 0 || id == 1 || id == 3 || id == 4 ) {
            gliss[0] @=> g;
        } else if( id == 1 || id == 2 || id == 4 || id == 5 ) {
            gliss[1] @=> g;
        } else if( id == 3 || id == 4 || id == 6 || id == 7 ) {
            gliss[2] @=> g;
        } else if( id == 4 || id == 5 || id == 7 || id == 8 ) {
            gliss[3] @=> g;
        }
        Math.random2f( -1*g, g) => g;
        port.note( nodes[id].coords[0] + offset, nodes[id].coords[1],(nFreq + g) * active);
        //<<< nFreq,"Sent","">>>;

        // put unvisited neighbors on queue
        for ( 0 => int i; i < n.neighbors.cap(); i++ ) {
            if ( nodes[ n.neighbors[i] ].marked == 0 && isIn( nodes[n.neighbors[i]].id, queue ) == 0 ) {
                queue << nodes[ nodes[ n.neighbors[i] ].id ];
            }
        }

        // remove this node from queue
        for( 1 => int i; i < queue.cap(); i++ ) {
            queue[i] @=> queue[i-1]; // shift values to left
        }
        queue.size(queue.cap() - 1); // resize 1 smaller

        // if queue has members, pulse recursively
        if ( queue.cap() > 0 ) {
            //<<< pulse/ms >>>;
            //<<< "next BFS node:",queue[0].id,"" >>>;
            pulse => now; // wait
            BFS( queue[0].id );
        } else {
            //unmarkNodes(); // or, reset the nodes
        }
                
    }

    fun void inOrder( int startId, int dir ) {
        ///<<< "\t\t\tIn-order search starting @:" + startId >>>;
        int place;
        float nFreq;
        tc.init();

        if( dir < 0 ) Math.abs( dir ) => dir;
        for( startId => int i; i < nodes.cap() ; dir +=> i ) {
            ( startId + i) % 27 => place;
            nodes[ place ].mark();
            
            if( nodes[ (place + 25) % 27 ].marked == 1 ) {
                nodes[ (place + 25) % 27 ].unMark();
                tc.lastNote(0) => nFreq;
                
                float g;
                if( place == 0 || place == 1 || place == 3 || place == 4 ) {
                    gliss[0] @=> g;
                } else if( place == 1 || place == 2 || place == 4 || place == 5 ) {
                    gliss[1] @=> g;
                } else if( place == 3 || place == 4 || place == 6 || place == 7 ) {
                    gliss[2] @=> g;
                } else if( place == 4 || place == 5 || place == 7 || place == 8 ) {
                    gliss[3] @=> g;
                }
                Math.random2f( -1*g, g) => g;
                port.note( nodes[place].coords[0] + offset, nodes[place].coords[1],(nFreq + g) * active);
            }
            //<<< pulse / ms >>>;
            pulse => now;
        }
        
    }

    fun void DFS( int id  ) {
        0 => int check;

        nodes[id].mark(); // mark node
        //<<< "Node", id, "Marked" >>>;
        unQ << id;
        //<<< "new crystal" >>>;
        tc.init(); 

        tc.lastNote(0) => float nFreq;
        
        float g;
        if( id == 0 || id == 1 || id == 3 || id == 4 ) {
            gliss[0] @=> g;
        } else if( id == 1 || id == 2 || id == 4 || id == 5 ) {
            gliss[1] @=> g;
        } else if( id == 3 || id == 4 || id == 6 || id == 7 ) {
            gliss[2] @=> g;
        } else if( id == 4 || id == 5 || id == 7 || id == 8 ) {
            gliss[3] @=> g;
        }
        Math.random2f( -1*g, g) => g;
        port.note( nodes[id].coords[0] + offset, nodes[id].coords[1],(nFreq + g) * active);
        //<<< nFreq >>>;

        for( 0 => int i; i < nodes[id].neighbors.cap(); i++ ) {
            // loop through neighbors, calling DFS recursively
            if( nodes[ nodes[id].neighbors[i] ].marked == 0 ) {
                //<<< pulse/ms >>>;
                pulse => now;
                //<<< nodes[id].neighbors[i] >>>;
                DFS( nodes[id].neighbors[i],  check++ );
            }
        }

        //unPulse();
    }

    // overload above
    fun void DFS( int id,  int check ) {
        nodes[id].mark(); // mark node
        //<<< "Node", id, "Marked" >>>;
        unQ << id;

        tc.lastNote(0) => float nFreq;
        
        float g;
        if( id == 0 || id == 1 || id == 3 || id == 4 ) {
            gliss[0] @=> g;
        } else if( id == 1 || id == 2 || id == 4 || id == 5 ) {
            gliss[1] @=> g;
        } else if( id == 3 || id == 4 || id == 6 || id == 7 ) {
            gliss[2] @=> g;
        } else if( id == 4 || id == 5 || id == 7 || id == 8 ) {
            gliss[3] @=> g;
        }
        Math.random2f( -1*g, g) => g;
        port.note( nodes[id].coords[0] + offset, nodes[id].coords[1],(nFreq + g) * active);
        
        for( 0 => int i; i < nodes[id].neighbors.cap(); i++ ) {
            // loop through neighbors, calling DFS recursively
            if( nodes[ nodes[id].neighbors[i] ].marked == 0 ) {
                //<<< pulse/ms >>>;
                pulse => now;
                DFS( nodes[id].neighbors[i], check++ );
            }
        }
    }

    fun void unPulse( float mod ) {
        for( 0 => int i; i < unQ.cap(); i++ ) {
            <<< "Unpulse:",i+1,"">>>;
            nodes[ unQ[i] ].unMark();
            port.note( nodes[ unQ[i] ].coords[0] + offset, nodes[ unQ[i] ].coords[1], 0 );
            pulse * mod => now;
        }
    }

    fun void unPulse() {
        unPulse( 1.0 );
    }

    // ------------------------SUPPORT FUNCS-----------------

    fun void unmarkNodes() {
        unmarkNodes( 1.0 );
    }
    
    fun void unmarkNodes( float m ) {
        // unmark all nodes in crystal
        for ( 0 => int i; i < nodes.cap(); i++ ) {
            nodes[i].unMark();
            <<<"turning off", nodes[i].coords[0]+offset,"">>>;
            port.note(nodes[i].coords[0] + offset, nodes[i].coords[1], 0);
            pulse * m => now;
        }
    }
    
    fun void sSauce() {
        for( 0 => int i; i < nodes.cap(); i++ ) {
            nodes[i].mark(); // mark all in attempt to kill any search funcs
        }
        for( 0 => int i; i < nodes.cap(); i++ ) {
            port.note(nodes[i].coords[0] + offset, nodes[i].coords[1], tc.baseFreq * ((i % 8) + 1) );
            50::ms => now;
            port.note(nodes[i].coords[0] + offset, nodes[i].coords[1], 0);
            50::ms => now;
        }
    }

    fun void kill() {
        for( 0 => int i; i < nodes.cap(); i ++ ) {
            port.note(nodes[i].coords[0] + offset, nodes[i].coords[1], 0);
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
m.init();WvIn apollo;
apollo.path(me.dir() + "apollo11saturnVaudio.wav");
apollo.rate(1.0);
for ( 0 => int i; i < 27; i ++ ) {
    <<< "new pulse" >>>;
    m.pulse( i );
    second => now;
}*/
