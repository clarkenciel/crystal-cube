TCrystal tc;
tc.init(1.0,500::ms,[2.0, 3.0, 5.0],1, 500);   
SinOsc s[3];

for ( 0 => int i; i < s.cap(); i++ ) {
    s[i] => dac;
    s[i].gain( 0.3 );
}

0.0 => float note;
//550::ms => dur pulse;

for ( 0 => int i; i < 400; i++ ) {
    //tc.grow(); 
    tc.lastNote( 0 ) => note;
    s[i%3].freq( note );
    //<<< note >>>;
//    pulse => now;
}
