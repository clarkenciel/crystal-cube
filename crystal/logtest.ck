TCrystal tc;

//<<< tc.hDist([0.0, 1.0]) >>>;
spork ~ tc.autoGrow();

for ( 0 => int i; i < 300; i ++ ) {
    if ( i%4 == 3 ) {
        tc.mutate();
    }
    1::ms => now;
}

