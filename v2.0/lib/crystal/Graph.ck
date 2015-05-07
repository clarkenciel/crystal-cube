// Graph.ck
// Graph class for BFS and DFS searches. It holds an array of node ids and will export arrays of pairs
// Author: Danny Clarke

public class Graph
{
    Pair pairs[0];
    0.5 => float related_lo;
    2.0 => float related_hi;

    //---------------------MAIN FUNCS------------------//
    /*
    * init( freq_array, lower_bound, upper_bound )
    * set up our array of pairs using our ids array
    * and an input array of frequencies (taken from 
    * Lattice)
    */
    fun void init(float freqs[], float lo, float hi)
    {
        int rand_id;

        lo => related_lo;
        hi => related_hi;

        //for(int i; i < freqs.size(); i++) 
        for(int i; i < 36; i++)
        {
            //Math.random2(0, freqs.size()-1) => rand_id;
            Math.random2(0, 35) => rand_id;
            if( !idIsSet(pairs, rand_id) ) 
            {
                pairs.size(pairs.size() + 1);
                new Pair @=> pairs[pairs.size() - 1];
                pairs[pairs.size() - 1].init(rand_id, freqs[Math.random2(0,freqs.size() - 1)]);
            }
        }
    }

    /*
    * BFS( starting_id )
    * return a connected componenet of pairs
    * generated using Breadth-First Search
    */
    fun Pair[] BFS(int start_id)
    {
        getPairIdx(start_id) => int start_idx;

        if(start_idx >= 0)
        {
            // do the BFS
            Pair path[0];               // our output
            [start_idx] @=> int queue[];// the queue
            int cur_idx;

            while(queue.size() > 0)
            {
                queue[0] => cur_idx;

                // add all of the neighbors to the queue
                for(int i; i < pairs.size(); i++)
                {
                    if(isNeighbor(cur_idx, pairs[i].id)
                        && isRelated(pairs[cur_idx].freq, pairs[i].freq)
                        && !isIn(path, pairs[i]))
                    {
                        queue << i;
                    }
                }

                // append to the path
                path.size(path.size() + 1);
                new Pair @=> path[path.size()-1];
                pairs[cur_idx] @=> path[path.size()-1];
                
                // shrink the queue
                for(1 => int i; i < queue.size(); i++)
                    queue[i] @=> queue[i - 1];
                queue.size(queue.size() - 1);
            }

            return path;
        } 
        else
        {
            return Pair path[0];
        }
    }
    
    /*
    * DFS( starting_id )
    * return a connected componenet of pairs
    * generated using Depth-First Search
    */
    fun Pair[] DFS(int start_id)
    {
        getPairIdx(start_id) => int idx;
        int didAdd;

        if(idx >= 0)
        {
            [pairs[idx]] @=> Pair path[];

            // do DFS
            while(idx >= 0)
            {
                0 => didAdd;
                for(int i; i < pairs.size(); i++)
                {
                    if(isNeighbor(idx, i)
                        && isRelated(pairs[idx].freq, pairs[i].freq)
                        && !isIn(path, pairs[i]))
                    {
                        // add to the path
                        path.size(path.size() + 1);
                        new Pair @=> path[path.size() - 1];
                        pairs[i] @=> path[path.size() - 1];

                        // change idx
                        i => idx;

                        1 => didAdd;
                        // break out of this loop
                        break;
                    }
                }
                if(!didAdd)
                {
                    -1 => idx;
                }
            }

            return path;
        } 
        else
        {
            return Pair path[0];
        }
    }

    //---------------------SUPPORT FUNCS------------------//
    fun int isNeighbor(int id1, int id2)
    {
        if(id1 + 1 == id2 || id1 - 1 == id2)
        {
            return 1;
        }
        else if(id1 + 3 == id2 || id1 - 3 == id2)
        {
            return 1;
        }
        else if(id1 + 9 == id2 || id1 - 9 == id2)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    fun int isRelated(float f1, float f2)
    {
        if(f1 * related_lo == f2 || f1 * related_hi == f2)
            return 1;
        else
            return 0;
    }

    fun void setFreqs(float freqs[])
    {
        for(int i; i < pairs.size(); i++)
        {
            freqs[i] => pairs[i].freq;
        }
    }

    fun int getPairIdx(int id)
    {
        for(int i; i < pairs.size(); i++)
        {
            if(pairs[i].id == id)
                return i;
        }

        return -1;
    }

    fun int idIsSet(Pair p[], int id)
    {
        for(int i; i < p.size(); i++) 
        {
            if(id == p[i].id)
                return 1;
        }

        return 0;
    }

    fun int isIn(Pair p[], Pair c)
    {
        for(int i; i < p.size(); i++)
        {
            if(p[i].id == c.id)
                return 1;
        }

        return 0;
    }

    fun int size()
    {
        return pairs.size();
    }
}
