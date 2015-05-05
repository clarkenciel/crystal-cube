// Pair.ck
// struct for storing a piezo id and corresponding frequency
// Author: Danny Clarke

public class Pair {
    int id;
    float freq;

    fun void init(int i, float f)
    {
        i => id;
        f => freq;
    }
}
