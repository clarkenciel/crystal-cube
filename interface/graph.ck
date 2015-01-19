private class Node {
    int id;
    int coords[2];
    int connections[0];
    int marked;

    fun void init( int aid, int acoords[] ){
        aid => id;
        acoords @=> coords;
    }

    fun void connect( int id ) {
        connections << id;
        <<< "connecting", this.id, "to", id >>>;
    }

    fun int[] getConn() {
        return connections;
    }

    fun void mark() {
        1 => marked;
    }

    fun void unMark() {
        0 => marked;
    }
}

public class Graph {
    int id;
    Node nodes[0];
    Node queue[0];
    int paths[0][0];

    fun void init( int numNodes, int aid ) {
        aid => id;
        new Node[numNodes] @=> nodes;
        new int[numNodes][0] @=> paths;
    }

    fun Node getNode( int n ) {
        return nodes[ n ];
    }

    fun void addNode( Node n ){
        nodes << n;
    }

    fun int[][] bfs( Node n ) {
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
                <<< "adding node: ", adj[i] >>>;
                queue << nodes[adj[i]];
                paths[i] << n.id; // add self to the path to each adjacency
                1 => check;
            }
        }
        
        // remove this node from queue
        Node nuQ[0];
        for ( 1 => int i; i < queue.cap(); i++ ) {
            nuQ << queue[i];
        }
        new Node[ nuQ.cap() ] @=> queue;
        for ( 0 => int i; i < nuQ.cap(); i++ ) {
            queue << nuQ[i];
        }

        this.bfs( queue[0] ); // do bs for the next item in the queue
    }


}

Graph g;
g.init( 3, 0 );
Node n[3];

for ( 0 => int i; i < 3; i++ ) {
    n[i].init( i, [i % 3, i % 10] );
    g.addNode( n[i] );
    g.nodes[i].connect( 2-i );
}

g.bfs( g.nodes[0] );
