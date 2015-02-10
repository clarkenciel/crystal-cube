MapCrystal mc;
10::ms => dur fast;
mc.init(fast);
int choice;

30 => int num;
float filtered_sensor[4][num];
float storage_sensor[4][num];
//Event pause; might use this later to pause shit when we do special stuff - perhaps kill, then respork in the specialSauce

spork ~ choose();
spork ~ mutate();
//spork ~ changeBase();
spork ~ changeDims();
spork ~ changePulse();
spork ~ deMutate();
spork ~ stopListen();
spork ~ mc.port.receive(0);
//spork ~ specialSauce();
//spork ~ mc.unPulse( 3 );

while( ms => now );

// FUNCS------------------
fun void choose() {
    int i;
    [-1, 1] @=> int c[];

    while( true ) {
        laundry(0, mc.port.sensor[0])*10 @=> mc.gliss[0];
        laundry(1, mc.port.sensor[1])*10 @=> mc.gliss[1];
        
        Math.random2(0,2) => choice;
        
        if( choice == 0 ) {
            //<<< "BFS", "" >>>; 
            mc.BFS(i % 27);
            mc.unmarkNodes();
        } else if( choice == 1 ){
            //<<< "in order", "" >>>;
            1 => int d;
            mc.inOrder( i % 27, d  );
            mc.unmarkNodes();
        } else if( choice == 2 ) {
            //<<< "DFS", "" >>>;
            mc.DFS( i%27 );
            mc.unmarkNodes();
        }
        i++;
    }
}

fun float fir(int idx, float val) {
    float sum;
    for (num - 2 => int i; i >= 0; i--) {
         filtered_sensor[idx][i] => filtered_sensor[idx][i + 1];
    }
    val => filtered_sensor[idx][0];
    for (int i; i < num; i++) {
        filtered_sensor[idx][i] +=> sum; 
    }
    return sum/num;
}

fun float std( float arr[] ) {
    float sum, mn;
    float std_arr[num];
    for( int i; i < num; i ++ ) {
        arr[i] +=> sum;
    }
    sum/num => mn;
    for( int i; i < num; i++ ) {
        arr[i] - mn => std_arr[i];
        std_arr[i] *=> std_arr[i];
    }

    0 => sum;
    for( int i; i < num; i ++ ) {
        std_arr[i] +=> sum;
    }

    sum/num => mn;
    return Math.sqrt(mn);
}

fun float laundry(int idx, float val) {
    fir(idx, val);
    return std(filtered_sensor[idx]);
}

fun void changePulse() {
    100::ms => dur rate;
    50::ms => dur inc;
    2::ms => dur dec;
    
    while( true ) {
        for( 0 => int i; i < 2; i ++  ) {
            //chout <= i <=" "<= laundry(i, mc.port.sensor[i]) <= " ";
            if( laundry(i, mc.port.sensor[i]) > 30.0 && mc.pulse < 10::second ) {
                inc +=> mc.pulse;
            } else if( mc.pulse > fast ) {
                dec -=> mc.pulse;
            }
            //<<< "Pulse Rate:", mc.pulse/ms,"" >>>;
            rate => now;
        }
    }
}

fun void mutate() {
    float m;
    int c;
    while( 500::ms => now ) {
        Math.random2(0, 1) => c;
        1.0 + (laundry(c, mc.port.sensor[c]) * 0.1 ) => m;
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
           //<<< "DeMutate:", mc.tc.mutateVar, "" >>>;
        }
    }
}
        

fun void changeBase() {
    float nuBase;
    [-1, 1] @=> int choice[];
    while( true ) {
        laundry(0, mc.port.sensor[0]) +=> nuBase;
        laundry(1, mc.port.sensor[1]) +=> nuBase;
        
        nuBase * choice[ Math.random2(0, 1) ]  => nuBase;
        mc.tc.baseFreq - nuBase => nuBase;
        nuBase +=> mc.tc.baseFreq;        
        10::ms => now;
    }
}

fun void changeDims() {
    int nuNum;
    float nuDim[];
    [2.0, 3.0, 5.0, 7.0, 11.0, 13.0, 17.0] @=> float nuDims[];
    minute => now;
    while( minute => now ) {
        3 => nuNum;
        nuDim.size( nuNum );
        for( 0 => int i; i < nuNum; i++ ) {
            nuDims[ Math.random2(0, nuDims.cap()) ] @=> nuDim[i];
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
        for( 0 => int i; i < 4; i ++ ) {
            // see if all the sensors are activated
            if( mc.port.sensor[i] < 230 ) check ++;
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

