36 => int NUM_SINES;

Lattice l;
l.set([13,17,19]);
l.generate(1,NUM_SINES) @=> float f[];
printA(f);

SinOsc s[NUM_SINES];
for(int i; i < s.size(); i++) {
    s[i].freq(f[i]);
    s[i].gain(0.5/s.size());
    s[i] => dac;
}

while(ms => now);

fun void printA( float a[] )
{
    for(int i; i < a.size(); i++)
        chout <= a[i] + " ";
    chout <= "\n"; chout.flush();
}