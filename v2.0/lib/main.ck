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
l.set([2, 3, 5, 7]);
l.generate(1000, 36) @=> float freqs[][];
debug.print2d(freqs);

Graph g[freqs.size()];
debug.print(""+g.size());

PiezoArray p[g.size()];
Pair a[0];

int start_idx;
1 => int num_times => int max_nt;
dur pulse, max_pulse;

// ------------------MAIN LOOP ----------------------
while(true)
{
    debug.print("generate graphs");
    // generate new graphs
    for(int i; i < freqs.size(); i++)
    {
        g[i].init(freqs[i],1 / (i + 1), i + 1);
    }
    
    debug.print("pass to piezo array");
    for(int i; i < g.size(); i++)
    {
        Math.random2(0, g[i].size() - 1) => start_idx;
        
        if(Math.random2(0, 1))
        {
            debug.print("BFS");
            g[i].BFS(start_idx) @=> a;
            if(a != NULL)
            {
                p.size(p.size()+1);
                new PiezoArray @=> p[p.size() - 1];
                p[p.size() - 1].init(a);
            }
            else
                debug.print("pair array:" + a + "is null");
        }
        else
        {
            debug.print("DFS");
            g[i].DFS(start_idx) @=> a;
            if(a != NULL)
            {
                p.size(p.size()+1);
                new PiezoArray @=> p[p.size() - 1];
                p[p.size() - 1].init(a);
            }
            else
                debug.print("pair array:" + a + "is null");
        }
    }

    debug.print("spork off piezo paths");
    1::ms => max_pulse;
    1 => num_times;

    // spork off piezo path navigations
    for(int i; i < p.size(); i++)
    {
        Math.random2(1, 10) => num_times;
        Math.random2f(1000, 2000)::ms => pulse;

        if(num_times >= max_nt)
            num_times => max_nt;

        if(pulse / samp > max_pulse / samp)
            pulse => max_pulse;

        if(Math.random2(0, 1))
            p[i].sequential(num_times, pulse, piezo);
        else
            p[i].chord(num_times, pulse, piezo);
        //play(p[i], num_times, pulse, piezo);
        //spork ~ deleter(i, num_times * pulse);
    }
    p.size(0);
    /* only uncomment if we can go back to sporking off playing
    //debug.print("waiting: " + (max_pulse * max_nt) / second + " seconds");
    //max_pulse * max_nt => now;
    //debug.print("waiting: " + 1 + " second");
    second => now;
    p.size(0);
    */
}

// ----------------------FUNCS-------------------------
fun void play(PiezoArray p, int num_times, dur pulse, Port piezo)
{
    debug.print("sporking new thing "+num_times+" times @ "+(pulse/second)+"seconds");
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

