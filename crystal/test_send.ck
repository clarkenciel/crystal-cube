Port p;
p.init();

1500 => int inc;
while (true) {  
     for (int i; i < 9; i++) {
        p.note(i + 1, 0, inc);
        p.note(i + 1, 1, inc);
        p.note(i + 1, 2, inc);
    }
    0.1::second => now;
    inc++;
    <<< inc >>>;
}

