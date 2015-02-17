[1,2,3] @=> int a[];
printA( a );
change( a ) @=> int b[];
printA( b );
null @=> a;
printA( a );
[1,2,3] @=> a;
printA( a );




fun void printA( int a[] ) {
    for( int i; i < a.cap(); i++ ) {
        chout <= a[i] <= " ";
    }
    chout <= "\n"; chout.flush();
}

fun int[] change( int a[] ) {
    int n[ a.cap() ];
    for( int i; i < n.cap(); i++ ) {
        Math.random2( 0, 5 ) @=> n[i];
    }
    null @=> a;
    return n;
}
