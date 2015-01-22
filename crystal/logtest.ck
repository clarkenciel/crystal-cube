MapCrystal mc;
mc.init();
100::ms => dur pulse;
0.0 => float note;

for ( 1 => int i; i < 10000; i++ ) {
    mc.pulse(
        i % 27,
        i::ms,
        1.0,
        [2.0, 3.0, 5.0],
        3,
        3000,
        (i*10) $ float 
    );
}
