// main.ck
// the main loop of Crystal Growth installation
// Author: Danny Clarke

1::second => now; // wait for piezo handshakes

Port piezo;
piezo.init();

1::second => now;

// --------------------VARS--------------------------
Util debug;

// minimize our magical shit by declaring up front
Lattice l;
l.set([2, 3, 5]);
l.generate(10, 36) @=> float freqs[][];
debug.print2d(freqs);

Graph g[freqs.size()];

PiezoArray p[0];

int start_idx, num_times, max_nt;
dur pulse, max_pulse;

// ------------------MAIN LOOP ----------------------
while(true)
{
    debug.print("looping");
    debug.print("making new graphs");
    // generate new graphs
    for(int i; i < freqs.size(); i++)
    {
        debug.print("new graph: "+i);
        g[i].init(freqs[i],1 / (i + 1), i + 1);
    }
    
    debug.print("passing to piezos");
    // pass components to Piezo Array
    for(int i; i < g.size(); i++)
    {
        debug.print("new piezo array: "+i);
        p.size(p.size() + 1);
        new PiezoArray @=> p[p.size() - 1];

        Math.random2(0, g[i].size() - 1) => start_idx;

        if(Math.random2(0, 1))
            p[p.size() - 1].init(g[i].BFS(start_idx));
        else
            p[p.size() - 1].init(g[i].DFS(start_idx));
    }

    debug.print("playing piezos");
    // spork off piezo path navigations
    for(int i; i < p.size(); i++)
    {
        Math.random2(1, 10) => num_times;
        Math.random2f(10, 2000)::ms => pulse;

        if(num_times >= max_nt)
            num_times => max_nt;

        if(pulse / ms > max_pulse / ms)
            pulse => max_pulse;

        play(p[i], num_times, pulse, piezo);
        spork ~ deleter(i, num_times * pulse);
    }
    max_nt * max_pulse => now;
}

// ----------------------FUNCS-------------------------
fun void play(PiezoArray p, int num_times, dur pulse, Port piezo)
{
    debug.print("sporking new thing"+num_times+"times @"+(pulse/second)+"seconds");
    if(Math.random2(0, 1))
        spork ~ p.sequential(num_times, pulse, piezo);
    else
        spork ~ p.chord(num_times, pulse, piezo);
}

fun void deleter(int idx, dur wait)
{
    wait => now;
    debug.print("deleting: "+idx);
    for(idx => int i; i < p.size() - 1; i++)
    {
        p[i+1] @=> p[i];
    }
    p.size(p.size() - 1);
}

