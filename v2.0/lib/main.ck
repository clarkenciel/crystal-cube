// main.ck
// the main loop of Crystal Growth installation
// Author: Danny Clarke
1::second => now; // wait for piezo handshakes

Port piezo;
piezo.init();

1::second => now;
/*
SinOsc piezo[9][4];
Pan2 pan[9][4];
int c;
for(int i; i < 9; i++)
{
    for(int j; j < 4; j++)
    {
        piezo[i][j] => pan[i][j] => dac;
        pan[i][j].pan(-1.0 + c / 18);
        piezo[i][j].gain(0);
        c++;
    }
}
*/

// --------------------VARS--------------------------
Util debug;
1.0 => float fund;

// minimize our magical shit by declaring up front
[2, 3, 5, 7] @=> int dims[];
Lattice l;
l.set(dims);
l.generate(fund, 100) @=> float freqs[][];
debug.print2df(freqs);

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
        g[i].init(freqs[i], 1.0 / dims[i], dims[i]);
    }
    
    debug.print("pass to piezo array");
    for(int i; i < g.size(); i++)
    {
        Math.random2(0, g[i].size() - 1) => start_idx;
        
        if(Math.random2(0, 1))
        {
            debug.print("BFS");
            g[i].BFS(start_idx) @=> a;
            if(a.size())
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
            if(a.size())
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
    1 => max_nt;

    // spork off piezo path navigations
    for(int i; i < p.size(); i++)
    {
        if(p[i].path.size())
        {
            Math.random2(1, 10) => num_times;
            Math.random2f(10000, 20000)::ms => pulse;

            if(pulse / samp > max_pulse / samp)
                pulse => max_pulse;

            if(num_times > max_nt)
                num_times => max_nt;

            play(p[i], num_times, pulse, piezo);
            spork ~ deleter(i, pulse * num_times);
            //pulse => now;
            second => now;
        }
    }
    second => now;
    /*
    l.generate(fund, 100) @=> freqs;
    debug.print2df(freqs);
    g.size(freqs.size());
    for(int i; i < g.size(); i++)
        new Graph @=> g[i];
    */
    //num_times * max_pulse => now;
    //p.size(0);
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
