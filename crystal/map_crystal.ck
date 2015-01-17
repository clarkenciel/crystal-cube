public class MapCrystal {
   
   Graph g;
   coords[27][2];

   fun void getCoords() {
        for ( 0 => int i; i < coords.cap(); i++ ) {
            for ( 0 => int j; j < 3; j++ ){
                coords << [i % 9, j];
            }
        }
   }
   fun void drawGraph() {
        int id;
        int conn[0];
        for ( 0 => int i; i < 27; i ++ ) {
            // for each node, create an id and give it connections
            i => id;

            if ( (i + 1) % 3 > 0 ) {
                conn << i + 1;
            }
            if ( (i + 3) % 9 > 0 ) {
                conn << i + 3;
            }
            if ( (i + 9) % 27 > 0) {
                conn << i + 9;
            }
        
            g.addNode( id, conn, coords[i] );
        }
    }
}
