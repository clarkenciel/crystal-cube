// PiezoArray.ck
// Interface for working with Arduino sculpture
// REQUIRES: 
//      crystal/TennyArray.ck
//      communication/Port.ck
// Author: Danny clarke

public class PiezoArray 
{
    Pair path[0];
    int addresses[9][4];

    /*
    * init( path )
    * initialize piezo array with path
    */
    fun void init(Pair p[])
    {
        path.size(p.size());
        for (int i; i < p.size(); i++) {
            p[i] @=> path[i];
        }
    }

    /*
    * sequential(pulse)
    * hit each piezo in the path in sequence
    * according to a pulse
    */
    fun void sequential(int n, dur pulse, Port piezo)
    {
        path.size() => int path_size;
        if(path_size)
        {
            int count;
            ///<<< "seq:",path_size,"">>>;
            //<<< (pulse/path_size) / second >>>;
            while(count < n)
            {
                for(int i; i < path_size; i++)
                {
                    //<<< "seq "+me.id()+":",path[i].freq, "" >>>;
                    send(path[i], piezo);
                    pulse / path_size => now;
                    kill(path[i], piezo);
                }
                count ++;
            }
        }
    }

    /*
    * chord()
    * hit all piezos in path "simultaneously"
    * and repeat n times according to a pulse
    */
    fun void chord(int n, dur pulse, Port piezo)
    {
        path.size() => int path_size;
        if(path_size)
        {
            int count;
            //<<< "chord","">>>;
            //<<< pulse/second >>>;
            while(count < n)
            {
                for(int i; i < path_size; i++ )
                {
                    send(path[i], piezo);
                }
                pulse => now;
                for(int i; i < path_size; i++ )
                {
                    kill(path[i], piezo);
                }
                pulse => now;
                count ++;
            }
        }
    }

    /*
    * send( piezo_id_freq_pair )
    * send freq to a piezo
    */
    fun void send(Pair p, Port piezo)
    {
        map(p.id) @=> int address[];
        //<<< "sending "+p.freq+" to "+address[0]+", "+address[1],"">>>;
        piezo.note(address[0], address[1], p.freq, 1.0);
        //s[address[0]][address[1]].freq(p.freq);
        //s[address[0]][address[1]].gain(0.9 / 36);
    }

    /*
    * kill( piezo id, piezo )
    * kill a piezo
    */
    fun void kill(Pair p, Port piezo)
    {
        map(p.id) @=> int address[];
        piezo.note(address[0], address[1], p.freq, 0.0);
        //s[address[0]][address[1]].gain(0.0);
    }
    /*
    * map( id)
    * return a piezo\s address [column, speaker]
    */
    fun int[] map(int id)
    {
        int count1, count2;
        for(int i; i < id; i++)
        {
            count1++;
            if(count1 % 9 == 0)
            {
                0 => count1;
                count2++;
            }
        }
        [count1, count2] @=> int out[];
        return out;
    }
}
