<<< isNeighbor(0, 1),"" >>>;
<<< isNeighbor(0, 35),"" >>>;
<<< isNeighbor(0, 3),"" >>>;

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
