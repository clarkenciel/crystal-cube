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
        p @=> path;
    }

    /*
    * sequential(pulse)
    * hit each piezo in the path in sequence
    * according to a pulse
    */
    fun void sequential(int n, dur pulse, Port piezo)
    {
        int count;
        while(count < n)
        {
            for(int i; i < path.size(); i++)
            {
                send(path[i], piezo);
                pulse => now;
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
        int count;
        while(count < n)
        {
            for(int i; i < path.size(); i++ )
            {
                send(path[i], piezo);
            }
            pulse => now;
        }
    }

    /*
    * send( piezo_id_freq_pair )
    * send freq to a piezo
    */
    fun void send(Pair p, Port piezo)
    {
        map(p.id) @=> int address[];
        piezo.note(address[0], address[1], p.freq);
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
