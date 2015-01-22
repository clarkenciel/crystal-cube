public class Node {
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
