MapCrystal mc;
mc.init();
1000::ms => dur pulse;
0.0 => float note;

for ( 1 => int i; i < 10000; i++ ) {
    mc.pulse(
        0,
        500::ms,
        1.0,
        [2.0, 3.0, 5.0],
        3,
        500.0
    );
}
