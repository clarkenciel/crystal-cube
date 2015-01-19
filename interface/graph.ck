private class Node {
    int id;
    int coords[2];
    int connections[0];
    0 => int marked;

    fun void init( int aid, int acoords[] ){
        aid => id;
        acoords @=> coords;
        <<< "initializing node",id,"with coordinates:",coords[0],",",coords[1] >>>;
    }

    fun void connect( int aid ) {
        connections << aid;
        <<< "connecting", id, "to", aid >>>;
    }

    fun int[] getConn() {
        return connections;
    }

    fun void mark() {
        <<<"marking:", id>>>;
        1 => marked;
    }

    fun void unMark() {
        0 => marked;
    }
}

public class Graph {
    int gid;
    Node nodes[0];
    Node queue[0];
    int paths[0][0];

    fun void init( int numNodes, int aid ) {
        aid => gid;
        new Node[numNodes] @=> nodes;
        new int[numNodes][0] @=> paths;
    }

    fun Node getNode( int n ) {
        return nodes[ n ];
    }

    fun void addNode( Node n, int loc ){
        <<< "adding node",n.id,"to graph",gid >>>;
        n @=> nodes[loc];
    }

    fun void bfs( Node n ) {
        if ( queue.cap() == 0 ) {
            queue << n;
        }
        <<< "looking at node: ", n.id >>>;
        0 => int check; // init checker to 0
        n.getConn() @=> int adj[];// get adjacent nodes 
        n.mark(); // mark this node

        // place unmarked adjacent nodes on the queue
        for ( 0 => int i; i < adj.cap(); i++ ) {
            <<< "finding adjacent nodes" >>>;
            if ( nodes[adj[i]].marked == 0 ) {
                <<< "adding node: ", adj[i], nodes[adj[i]].id >>>;
                queue << nodes[adj[i]];
                paths[adj[i]] << n.id; // add self to the path to each adjacency
                1 => check;
            }
        }
        
        // remove this node from queue
        Node nuQ[queue.cap() - 1];
        for ( 1 => int i; i < queue.cap(); i++ ) {
            <<< i >>>;
            queue[i] @=> nuQ[i-1];
        }
        <<< "queue before" >>>;
        printNodes( queue );

        new Node[nuQ.cap()] @=> queue;
        for ( 0 => int i; i < nuQ.cap(); i++ ) {
            nuQ[i] @=> queue[i]; 
        }
        <<< "queue after" >>>;
        printNodes( queue );

        <<< "\n Paths:">>>;
        for ( 0 => int i; i < paths.cap(); i++ ) {
            for ( 0 => int j; j < paths[i].cap(); j++ ){
                <<< paths[i][j] >>>;
            }
        }
        <<< "\n" >>>;
        bfs( queue[0] ); // do bs for the next item in the queue
    }

    fun void printNodes( Node a[] ){
        "[" => string print;
        for ( 0 => int i; i < a.cap(); i++ ){
            " " + a[i].id + "," +=> print;
        }
        " ]" +=> print;
        <<< print, "\n">>>;
    }
}

Graph g;
g.init( 3, 0 );
Node n[3];

for ( 0 => int i; i < 3; i++ ) {
    n[i].init( i, [i % 3, i % 10] );
    g.addNode( n[i],i );
    g.nodes[i].connect( Math.random2(0, 3) );
}

g.bfs( g.nodes[0] );
