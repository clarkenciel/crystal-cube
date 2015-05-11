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
//debug.print2df("freqs:", freqs);

Graph g[freqs.size()];

PiezoArray p[0];
Pair a[0];

int start_idx;
1 => int num_times => int max_nt => int dim_grow;
second => dur pulse => dur max_pulse;
now + 5::minute => time later;
now + 30::minute => time much_later;

// ------------------MAIN LOOP ----------------------
spork ~ gramListen();
while(true)
{
        
    debug.print("Generating Patterns");
    // generate new graphs
    for(int i; i < freqs.size(); i++)
    {
        g[i].init(freqs[i], 1.0 / dims[i], dims[i]);
    }
    
    //debug.print("pass to piezo array");
    for(int i; i < g.size(); i++)
    {
        //Math.random2(0, g[i].size() - 1) => start_idx;
        
        if(Math.random2(0, 1))
        {
            //debug.print("BFS");
            g[i].BFS(start_idx) @=> a;
            if(a.size() && p.size() < 4)
            {
                p.size(p.size()+1);
                new PiezoArray @=> p[p.size() - 1];
                p[p.size() - 1].init(a);
            }
            //else
                //debug.print("pair array:" + a + "is null");
        }
        else
        {
            //debug.print("DFS");
            g[i].DFS(start_idx) @=> a;
            if(a.size() < p.size() < 4)
            {
                p.size(p.size()+1);
                new PiezoArray @=> p[p.size() - 1];
                p[p.size() - 1].init(a);
            }
            //else
                //debug.print("pair array:" + a + "is null");
        }
    }

    //debug.print("spork off piezo paths");
    1::ms => max_pulse;
    1 => max_nt;

    // spork off piezo path navigations
    for(int i; i < p.size(); i++)
    {
        if(p[i].path.size())
        {
            /*
            Math.random2(1, 10) => num_times;
            Math.random2f(10000, 20000)::ms => pulse;
            */

            if(pulse / samp > max_pulse / samp)
                pulse => max_pulse;

            if(num_times > max_nt)
                num_times => max_nt;

            play(p[i], num_times, pulse, piezo);
            spork ~ deleter(i, pulse * num_times);
            pulse => now;
        }
    }

    while(p.size() > 2)
    {
        //debug.print(p.size());
        ms => now;
    }

    // change dimensions sometimes
    if(now >= later)
    {
        debug.print("Changing Dimensions!");
        now + 5::minute => later;
        for(int i; i < dims.size(); i++)
        {
            dim_grow +=> dims[i];
        }
        debug.printIArr("New Dimensions:", dims);
    }

    if(now >= much_later)
    {
        now + 30::minute => much_later;
        -1 *=> dim_grow;
    }

    // generate new frequencies
    l.generate(fund, 100) @=> freqs;
    debug.print("New Fundamental: " + fund);
    //debug.print2df("freqs:", freqs);
}

// ----------------------FUNCS-------------------------
fun void play(PiezoArray p, int num_times, dur pulse, Port piezo)
{
    //debug.print("sporking new thing "+num_times+" times @ "+(pulse/second)+"seconds");
    //debug.print("starting at: " + p.path[0].id);
    if(Math.random2(0, 1))
        spork ~ p.sequential(num_times, pulse, piezo);
    else
        spork ~ p.chord(num_times, pulse, piezo);
}

fun void deleter(int idx, dur wait)
{
    wait => now;
    //debug.print("deleting: "+idx);
    for(idx => int i; i < p.size() - 1; i++)
    {
        p[i+1] @=> p[i];
    }
    p.size(p.size() - 1);
    //debug.print("p size: " + p.size());
}

fun void gramListen()
{
    OscIn in;
    OscMsg m;
    in.port(12345);
    in.listenAll();

    while(true)
    {
        //debug.print("listening for grams");
        in => now;
        while(in.recv(m))
        {
            if(m.address.find("ids"))
            {
                m.getInt(0) => start_idx;
                //<<< "ids", m.getInt(0), "" >>>;
                if(start_idx > 35) 35 => start_idx;
                if(start_idx < 0) 0 => start_idx;
            }
            if(m.address.find("rms"))
            {
                (Math.fabs(m.getFloat(0)) * 10 + 0.01)::ms => pulse;
                //<<< "rms", pulse / ms, "" >>>;
            }
            if(m.address.find("centroid"))
            {
                (m.getFloat(0) * 0.025 + 1) $ int => num_times;
                //<<< "centroid", num_times, "" >>>;
            }
            if(m.address.find("meanCentroid"))
            {
                m.getFloat(0) => fund;
                //<<< "mean cent", m.getFloat(0), "" >>>;
            }
        }
    }
}
