MapCrystal mc;
mc.init();
10::second => dur pulse;
0.0 => float note;
int choice;
float mut;

spork ~ choose();
spork ~ mutate();
spork ~ changeBase();
spork ~ changeDims();
spork ~ deMutate();
spork ~ stopListen();

while( ms => now );

// FUNCS------------------
fun void choose() {
    int i;
    while( true ) {
        Math.random2(0,3) => choice;

        if( choice == 0 ) {
            <<< "BFS", "" >>>; 
            mc.BFS(i % 27, pulse, 0.0 );
    
        } else if( choice == 1 ){
            <<< "in order", "" >>>;
            mc.inOrder( i % 27, 1, pulse );
        } else if( choice == 2 ) {
            <<< "DFS", "" >>>;
            mc.DFS( i%27, pulse, 0 );
        }
        i++;
    }
}

fun void mutate() {
    float m;
    while( 5::minute => now ) {
        Math.random2f( 0.1, 1.0 ) => m; 
        m => mc.tc.mutateVar; 
        <<< "Mutate:", mc.tc.mutateVar, "" >>>;
    }
}

fun void deMutate() {
    float dif;
    while( 15::minute => now ) {
        mc.tc.mutateVar - 1.0 => dif; 
        if( dif > 0.0 ) {
           dif / 96.0 -=> mc.tc.mutateVar;
           <<< "DeMutate:", mc.tc.mutateVar, "" >>>;
        }
    }
}
        

fun void changeBase() {
    float nuBase;
    while( 5::minute => now ) {
        Math.random2f( 0.1, 1.0 ) * mc.tc.baseFreq => nuBase;
        nuBase => mc.tc.baseFreq;        
    }
}

fun void changeDims() {
    int nuNum;
    float nuDim[];
    while( 3::minute => now ) {
        Math.random2( 2, 5 ) => nuNum;
        nuDim.size( nuNum );
        for( 0 => int i; i < nuNum; i++ ) {
            Math.random2f( 2.0, 17.0 ) @=> nuDim[i];
        }
        mc.tc.dim.size(nuNum);
        for( 0 => int i; i < nuNum; i++ ) {
            nuDim[i] @=> mc.tc.dim[i];
        }
    }
}

fun void offOn( float a ) {
    // send 0 to all arduinos & change the multplier for all the algs 
    mc.kill();
    a => mc.active;
}

fun void stopListen() {
    KBHit space;
    int check;
    <<< "---------------------- press space bar to turn off/on --------------------------" >>>;
    while( true ) {
        space => now;
        while( space.more() ) {
            space.getchar() => int s;
            if( s == 32 && check == 0 ) {
                offOn(0);1=>check;
                <<< "off", "" >>>;
            }
            if( s == 32 && check == 1 ) {
                <<< "on", "" >>>;
                offOn(1);0=>check;
            }
        }
    }
}
