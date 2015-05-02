36 => int NUM_SINES;
int c;

Lattice l;
l.set([2,13]);
l.generate(3000,NUM_SINES) @=> float f[][];
printA(f);

SinOsc s[NUM_SINES];
for(int i; i < s.size(); i++) {
    s[i].gain(0.2/s.size());
    s[i] => dac;
}
<<< "harmonic", "" >>>;
while(c < f[f.size()-1].size()) {
    l.generate(f[f.size()-1][c], NUM_SINES);
    
    for(int i; i < s.size(); i++) {
        s[i].freq(l.next());
    }
    c++;
    100::ms => now;
}

<<< "melodic", "" >>>;
for(int i; i < s.size(); i++) {
    s[i] =< dac;
    NULL @=> s[i];
}
NULL @=> s;

SinOsc s2 => dac;
s2.gain(0);
l.generate(3000,NUM_SINES);
while(100::ms => now) {
    s2.freq(l.next());
    s2.gain(0.5);
}

//----------------------------------------
fun void printA( float a[][] )
{
    for(int j; j < a.size(); j++) {
        for(int i; i < a[j].size(); i++)
            chout <= a[j][i] + " ";
        chout <= "\n------\n"; 
    }
    chout.flush();
}