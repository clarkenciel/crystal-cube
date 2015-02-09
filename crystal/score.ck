MapCrystal mc;
10::ms => dur fast;
mc.init(fast);
int choice;

spork ~ choose();
//spork ~ mutate();
//spork ~ changeBase();
//spork ~ changeDims();
//spork ~ changePulse();
//spork ~ deMutate();
spork ~ stopListen();
spork ~ mc.port.receive(0);
//spork ~ mc.unPulse( 3 );

while( ms => now );

// FUNCS------------------
fun void choose() {
    int i;
    float v;
    [-1, 1] @=> int c[];

    while( true ) {
        60 - (mc.port.sensor[0]-11) => v;
        Math.random2(0,2) => choice;
        v * 10 => float g;
        chout <= v;
        chout <= "\n";
        chout.flush();
        if( choice == 0 ) {
            //<<< "BFS", "" >>>; 
            mc.BFS(i % 27, g );
    
        } else if( choice == 1 ){
            //<<< "in order", "" >>>;
            c[ Math.random2( 0, 1 ) ] @=> int d;
            mc.inOrder( i % 27, d  );
        } else if( choice == 2 ) {
            //<<< "DFS", "" >>>;
            mc.DFS( i%27 );
        }
        i++;
    }
}

fun void changePulse() {
    100::ms => dur rate;
    10::ms => dur inc;
    100::ms => dur dec;
    
    while( true ) {
        for( 0 => int i; i < mc.port.sensor.cap(); i ++  ) {
            //<<< "Sensor:", mc.port.sensor[i], "" >>>;
            if( mc.port.sensor[i] < 500 && mc.pulse < fast*10 ) {
                inc +=> mc.pulse;
            } else if( mc.pulse > fast ) {
                dec -=> mc.pulse;
            }
        }
        rate => now;
    }
}

fun void mutate() {
    float m;
    while( 500::ms => now ) {
        1.0 / (mc.port.sensor[0] + 1) => m;
        m => mc.tc.mutateVar; 
        //<<< "Mutate:", mc.tc.mutateVar, "" >>>;
    }
}

fun void deMutate() {
    float dif;
    while( 1500::ms => now ) {
        mc.tc.mutateVar - 1.0 => dif; 
        if( dif > 0.0 ) {
           dif / 96.0 -=> mc.tc.mutateVar;
           <<< "DeMutate:", mc.tc.mutateVar, "" >>>;
        }
    }
}
        

fun void changeBase() {
    float nuBase;
    while( true ) {
        //mc.tc.baseFreq / (mc.port.sensor[1]+1) => nuBase;
        1.0 => nuBase;
        nuBase => mc.tc.baseFreq;        
        10::ms => now;
    }
}

fun void changeDims() {
    int nuNum;
    float nuDim[];
    minute => now;
    while( minute => now ) {
        3 => nuNum;
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
                offOn(0);
                1 => check;
                <<< "off", "" >>>;
            }
            if( s == 32 && check == 1 ) {
                <<< "on", "" >>>;
                offOn(1);0=>check;
            }
        }
    }
}

