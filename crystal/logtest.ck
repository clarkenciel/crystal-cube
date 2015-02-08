MapCrystal mc;
mc.init();
10::second => dur pulse;
0.0 => float note;
int choice;

for ( 1 => int i; i < 10000; i++ ) {
    Math.random2(0,3) => choice;

    if( choice == 0 ) {
        <<< "BFS" >>>; 
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
        <<< "in order" >>>;
        mc.inOrder( i % 27, 1, pulse );
    } else if( choice == 2 ) {
        <<< "DFS" >>>;
        mc.DFS(
            i%27,
            pulse,
            1.0,
            [2.0, 3.0, 5.0],
            3,
            3000
        );
    }
}
