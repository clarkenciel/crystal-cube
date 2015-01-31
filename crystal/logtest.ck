MapCrystal mc;
mc.init();
250::ms => dur pulse;
0.0 => float note;
int choice;

for ( 1 => int i; i < 10000; i++ ) {
    //Math.random2( 0, 1 ) => choice;
    0 => choice;

    if( choice == 0 ) {
    
        mc.pulse(
            i % 27,
            pulse,
            1.0,
            [2.0, 3.0, 5.0],
            3,
            3000,
            (i*10) $ float 
        );

    } else if( choice == 1 ){
        mc.inOrder( i % 27, 1, pulse );
    }
}
