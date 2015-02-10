MapCrystal mc;
20::ms => dur fast;
mc.init(fast);
int choice;
//Event pause; might use this later to pause shit when we do special stuff - perhaps kill, then respork in the specialSauce

spork ~ choose();
//spork ~ mutate();
//spork ~ changeBase();
//spork ~ changeDims();
//spork ~ changePulse();
//spork ~ deMutate();
spork ~ stopListen();
//spork ~ mc.port.receive(0);
//spork ~ specialSauce();
//spork ~ mc.unPulse( 3 );

while( ms => now );

// FUNCS------------------
fun void choose() {
    int i;
    [-1, 1] @=> int c[];

    while( true ) {
        for( 0 => int j; j < mc.port.sensor.cap(); j ++ ) {
            //60 - (mc.port.sensor[i]-11) @=> mc.gliss[i];
        }
        
        Math.random2(0,2) => choice;
        
        if( choice == 0 ) {
            <<< "BFS", "" >>>; 
            mc.BFS(i % 27);
            mc.unmarkNodes();
        } else if( choice == 1 ){
            <<< "in order", "" >>>;
            1 => int d;
            mc.inOrder( i % 27, d  );
            mc.unmarkNodes();
        } else if( choice == 2 ) {
            <<< "DFS", "" >>>;
            mc.DFS( i%27 );
            mc.unmarkNodes();
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

fun void specialSauce() {
    0 => int check;
    while( true ) {
        for( 0 => int i; i < mc.port.sensor.cap(); i ++ ) {
            // see if all the sensors are activated
            if( mc.port.sensor[i] < 71 ) check ++;
        }
        if( check == 4 ) {
            // do something special
            chout <= "SPECIAL SAAAAAUUUUUUUUCE!!!!!";
            chout.flush();
            mc.sSauce();
            0 => check;
        } else {
            mc.unmarkNodes(); // clear the nodes for later
            0 => check;
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
                offOn(1);
                0=>check;
            }
        }
    }
}

