private class Node {
    int id;
    int coords[2];
    int connections[0];

    fun void init( int aid, int acoords[] ){
        aid => id;
        acoords @=> coords;
    }

    fun void connect( int id ) {
        connections << id;
    }

    fun int[] getConn() {
        return connections;
    }
}

public class Graph {
    int id;
    Node nodes[0];

    fun Node getNode( int n ) {
        return nodes[ n ];
    }

    fun void addNode( Node n ){
        nodes << n;
        n.connect( nodes[nodes.cap() - 2].id  );
    }
}
