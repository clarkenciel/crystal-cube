public class Util
{
    fun void print2d(float a[][])
    {
        for(int i; i < a.size(); i++)
        {
            chout <= "\n";
            for(int j; j < a[i].size(); j++)
            {
                chout <= a[i][j] + ", ";
            }
        }
        chout <= "\n";
        chout.flush();
    }

    fun void printPA(Pair a[])
    {
        for(int i; i < a.size(); i++)
        {
            <<< a[i].id, a[i].freq, "">>>;
        }
    }

    fun void print(string msg)
    {
        <<< msg, "" >>>;
    }
}
